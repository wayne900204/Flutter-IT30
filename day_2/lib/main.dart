import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TextView(callback: (String text) => _showDialog(context, text)),
    );
  }

  void _showDialog(BuildContext context, String text) {
    showDialog<void>(
        context: context, builder: (context) => AlertDialog(title: Text(text)));
  }
}

class TextView extends StatefulWidget {
  const TextView({required this.callback});

  final void Function(String text) callback;

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(controller: _controller),
        IconButton(
          onPressed: () async => widget.callback(_controller.text),
          icon: Icon(Icons.check),
        )
      ],
    );
  }
}
