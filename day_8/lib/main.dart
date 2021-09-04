import 'package:day_8/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Provider Sample'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    context.read<PostProvider>().fetchData(SortState.sortWithId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('使用 userId 排序'),
                        value: SortState.sortWithUserId,
                      ),
                      PopupMenuItem(
                        child: Text('使用 id 排序'),
                        value: SortState.sortWithId,
                      ),
                      PopupMenuItem(
                        child: Text('使用 title 排序'),
                        value: SortState.sortWithTitle,
                      ),
                      PopupMenuItem(
                        child: Text('使用 body 排序'),
                        value: SortState.sortWithBody,
                      )
                    ],
                onSelected: (SortState value) {
                  context.read<PostProvider>().fetchData(value);
                })
          ],
        ),
        body: MyListView());
  }
}

class MyListView extends StatelessWidget {
  const MyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<PostProvider>().posts.length,
      itemBuilder: (context, index) {
        var post = context.watch<PostProvider>().posts[index];
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
                    text: post.id.toString() + ". " + post.title,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  TextSpan(
                    text: '\n' + post.body,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\nUser ID：" + post.userId.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
