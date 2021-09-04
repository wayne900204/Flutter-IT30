import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations({this.locale = const Locale.fromSubtags(languageCode: 'zh')});
  /// Helper method to keep the code in the widgets concise
  /// Localizations are accessed using an InheritedWidget "of" syntax
  /// 訪問本地化
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  /// 儲存 SharedPreferences
  void keepLocaleKey(String localeKey) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("localeKey");
    await _prefs.setString("localeKey", localeKey);
  }
  /// 讀取 SharedPreferences
  Future<String> readLocaleKey() async {
    final _prefs = await SharedPreferences.getInstance();
    // 初始化最一剛開始的語言
    return _prefs.getString("localeKey")??'zh';
  }

  /// 更改語言，重新設定語言
  void setLocale(BuildContext context, Locale locale) async {
    // keep value in shared pref
    keepLocaleKey(locale.languageCode);
    print("key language :${locale.languageCode}");
    MyApp.setLocale(context, locale);
  }
  /// Static member to have a simple access to the delegate from the MaterialApp
  /// 提供 Main Page 可以直接訪問。
  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;
  /// Load the language JSON file from the "lang" folder
  /// 讀取 Json 格式
  Future<bool> load() async {
    String jsonString =
    await rootBundle.loadString('language/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// This method will be called from every widget which needs a localized text
  /// 提供每一個需要轉換語言的文字
  String translate(String key) {
    return _localizedStrings[key]!;
  }
}

/// LocalizationsDelegate is a factory for a set of localized resources
/// In this case, the localized strings will be gotten in an AppLocalizations object
/// 本地化的字符串將在 AppLocalizations 對像中獲取
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();
  /// 之泉的語言代碼
  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'zh'].contains(locale.languageCode);
  }
  /// 讀取 Json
  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale: locale);
    await localizations.load();
    return localizations;
  }
  /// 使否重新 reload
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}