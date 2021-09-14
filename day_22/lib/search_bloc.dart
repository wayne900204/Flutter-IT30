import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'github_api.dart';
import 'search_state.dart';

class SearchBloc {
  final Sink<String> onTextChanged;
  final Stream<SearchState> state;

  /// 這邊用 factory 的目的，是為了讓這個 SearchBloc 參數一樣時，物件判定會是一樣的。
  /// 雖然傳遞的參數只有一個，但是實際上我們要創建這個 SearchBloc 需要兩個參數。
  ///
  /// 建構子前以關鍵字 factory 宣告一個工廠建構子，工廠建構子不一定會產生一個新物件，可能回傳一個既存物件。
  /// 要注意工廠建構子在return之前還未有實體，故不能使用this引用成員變數的值或呼叫函數。
  factory SearchBloc(GithubApi api) {
    final onTextChanged = PublishSubject<String>();

    final state = onTextChanged
        // If the text has not changed, do not perform a new search
        // 如果與前一比資料一樣，將不會觸發。
        .distinct()
        // Wait for the user to stop typing for 250ms before running a search
        // 等 0.25 秒後，才開始搜尋，執行 api
        .debounceTime(const Duration(milliseconds: 250))
        // Call the Github api with the given search term and convert it to a
        // State. If another search term is entered, switchMap will ensure
        // the previous search is discarded so we don't deliver stale results
        // to the View.
        // 如果輸入 a 的時候，開始搜尋，再輸入 b 後，變成 ab，但是 a 的搜尋結果還沒出來，那麼變成 ab 後，他會把這個還沒搜尋完成的 a 流程給停止掉。避免浪費搜尋時間。
        .switchMap<SearchState>((String term) => _search(term, api))
        // The initial state to deliver to the screen.
        // 在這個 stream 的最前面加上一個初始值
        .startWith(SearchNoTerm());
    // 這邊已經初始化完成了，在第 15 行、17 行
    return SearchBloc._(onTextChanged, state);
  }

  SearchBloc._(this.onTextChanged, this.state);

  // 給畫面 call 的，好讓這個 dispose 掉。
  void dispose() {
    onTextChanged.close();
  }

  static Stream<SearchState> _search(String term, GithubApi api) => term.isEmpty
      ? Stream.value(SearchNoTerm())
      //  when the future completes, this stream will fire one event, either data or error, and then close with a done-event.
      // Rx.fromCallable，它在偵聽時調用您指定的函數，然後發出從該函數返回的值。這整個 Rx.fromCallable(()=>future) 會是一個 Stream
      : Rx.fromCallable(() => api.search(term))
          .map((result) =>
              result.isEmpty? SearchEmpty() : SearchPopulated(result))
          .startWith(SearchLoading())
          .onErrorReturn(SearchError());
}
