import 'package:day_11/service/post_service.dart';
import 'package:get/get.dart';

import '../model/post_model.dart';

enum SortState { userID, id, title, body }

class PostController extends GetxController {
  var isLoading = true.obs;
  var postList = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApi();
  }

  void fetchApi() async {
    isLoading(true);
    await PostService().fetchData().then((value) {
      postList.assignAll(value);
      isLoading(false);
      update();
    }).catchError((e) {});
  }

  // sort method
  void sort(SortState sortState) async {
    switch (sortState) {
      case SortState.title:
        postList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortState.id:
        postList.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortState.userID:
        postList.sort((a, b) => a.userId.compareTo(b.userId));
        break;
      case SortState.body:
        postList.sort((a, b) => a.body.compareTo(b.body));
        break;
    }
    update();
  }
}
