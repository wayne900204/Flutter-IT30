import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Demo',
      routes: {
        '/': (context) => HomePage(),
        '/second': (context) => SecondPage(),
        '/error': (context) => ErrorPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String _shortUrl = '';

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    /// 當 app 處於活動狀態
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      Navigator.pushNamed(context, '/error');
    });

    /// 當 app 處於非活動狀態
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  Future<void> _createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://2021it30.page.link/',
      link: Uri.parse('https://example.com/'),
      androidParameters: AndroidParameters(
          packageName: 'com.example.android',
          minimumVersion: 125,
          fallbackUrl: Uri.parse('https://www.google.com/')),
      iosParameters: IosParameters(
          bundleId: 'com.example.ios',
          minimumVersion: '1.0.1',
          appStoreId: '123456789',
          fallbackUrl: Uri.parse('https://www.google.com/')),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;

    setState(() {
      _shortUrl = shortUrl.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: const Text('Create Link'),
              onPressed: () {
                _createDynamicLink();
              },
            ),
            SelectableText(_shortUrl),
            OutlinedButton(
              child: const Text('Copy Link'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _shortUrl));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Demo'),
      ),
      body: const Center(
        child: const Text('Second Page'),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Demo'),
      ),
      body: const Center(
        child: const Text('Error Page'),
      ),
    );
  }
}
