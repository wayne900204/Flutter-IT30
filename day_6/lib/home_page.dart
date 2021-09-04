import 'package:flutter/material.dart';
import 'SecondPAge.dart';
import 'app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppLocalizations localeApp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localeApp = AppLocalizations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('name')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('introduce'),
              style: TextStyle(fontSize: 32),
            ),
            TextButton(
              child: Text("Next Page"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new SecondPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
