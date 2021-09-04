import 'package:day_10/model/post_model.dart';
import 'package:day_10/respository/post_respository.dart';
import 'package:day_10/service/post_service.dart';
import 'package:day_10/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/post_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //  初始化 Bloc
        BlocProvider<PostBloc>(
          create: (BuildContext context) => PostBloc(
            repository: PostRepository(PostService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Bloc Sample'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<SortState>(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('使用 userId 排序'),
                  value: SortState.userID,
                ),
                PopupMenuItem(
                  child: Text('使用 id 排序'),
                  value: SortState.id,
                ),
                PopupMenuItem(
                  child: Text('使用 title 排序'),
                  value: SortState.title,
                ),
                PopupMenuItem(
                  child: Text('使用 body 排序'),
                  value: SortState.body,
                )
              ],
              onSelected: (SortState value) {
                // 觸發事件
                context.read<PostBloc>().add(SortPostEvent(sortState: value));
              },
            )
          ],
        ),
        body: _MyListView());
  }

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPostData());
  }
}

class _MyListView extends StatelessWidget {
  const _MyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bloc Builder
    return BlocBuilder<PostBloc, IPostState>(
      builder: (_, state) {
        if (state is PostSuccess) {
          return ListView.builder(
            key: UniqueKey(),
            itemCount: state.postList.length,
            itemBuilder: (context, index) {
              PostModel item = state.postList[index];
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent, width: 2.0)),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: item.id.toString() + ". " + item.title,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        TextSpan(
                          text: '\n' + item.body,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "\nUser ID：" + item.userId.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ));
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
