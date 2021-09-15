import 'package:flutter/material.dart';
///
class FlutterHead extends StatelessWidget {
  const FlutterHead({
    Key? key,
  }) : super(key: key);

  final imageUrl =
      'https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -5,
      right: 10.0,
      child: FadeInImage.assetNetwork(
        placeholder: 'images/transparent.png',
        image: imageUrl,
        width: 150,
        height: 72,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
