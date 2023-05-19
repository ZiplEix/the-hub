import 'package:flutter/material.dart';

class UtilitaryBarButton extends StatelessWidget {
  const UtilitaryBarButton({
    super.key,
    required this.subTitle,
    required this.icon,
  });

  final String subTitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text(
          subTitle,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
