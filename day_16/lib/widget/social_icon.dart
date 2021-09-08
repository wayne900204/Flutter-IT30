import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Social Icon
class SocialIcon extends StatelessWidget {
  const SocialIcon({
    required this.iconSrc,
    required this.onPress,
    required this.text,
  });

  final String iconSrc;
  final void Function() onPress;

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 56,
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(54),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SvgPicture.asset(
                iconSrc,
                height: 20,
                width: 20,
              ),
            ),
            Text(
              "  " + text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PingFang',
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Padding(
              child: Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.black,
              ),
              padding: EdgeInsets.only(right: 6),
            ),
          ],
        ),
      ),
    );
  }
}