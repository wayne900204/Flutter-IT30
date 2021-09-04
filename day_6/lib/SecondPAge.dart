import 'package:flutter/material.dart';

import 'app_localizations.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  AppLocalizations localeApp = AppLocalizations();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text('change Language'),
              onPressed: () async {
                if (await localeApp.readLocaleKey() == "zh") {
                  localeApp.setLocale(context, Locale("en", "EN"));
                } else {
                  localeApp.setLocale(
                      context, Locale.fromSubtags(languageCode: 'zh'));
                }
              }),
          TextButton(
            child: Text("Next Page"),
            onPressed: () {
              return Navigator.pop(context);
            },
          )
        ],
      )),
    );
  }
}