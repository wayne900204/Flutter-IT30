import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  /// 當地區更改時，重新設定地區，當使用者按下變換語言時，會觸發。
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = new Locale.fromSubtags(languageCode: 'zh');
  /// 更改地區
  void changeLocale(Locale locale) {
    setState(() {
      this._locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final languageApp = AppLocalizations();
    final localeKey = await languageApp.readLocaleKey();
    if (localeKey == "en") {
      this._locale = new Locale("en", "EN");
    } else {
      this._locale = new Locale.fromSubtags(languageCode: 'zh');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        supportedLocales: [
          Locale('en', 'US'),
          const Locale.fromSubtags(languageCode: 'zh'),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        // 委託確保加載正確語言的本地化數據
        localizationsDelegates: [
          // This class will be added later
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // A class which loads the translations from JSON files
          GlobalMaterialLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: _locale,
        // Returns a locale which will be used by the app
        // 檢查手機是否支援這個語言
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocaleLanguage in supportedLocales) {
            if (supportedLocaleLanguage.languageCode == locale?.languageCode &&
                supportedLocaleLanguage.countryCode == locale?.countryCode) {
              return supportedLocaleLanguage;
            }
          }
          // If device not support with locale to get language code then default get first on from the list
          return supportedLocales.first;
        },
        home: HomePage());
  }
}
