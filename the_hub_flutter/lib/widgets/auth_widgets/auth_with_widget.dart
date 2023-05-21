import 'package:flutter/material.dart';

class AuthWithWidget extends StatelessWidget {
  const AuthWithWidget({
    super.key,
    required this.onTap,
    required this.imagePath,
  });

  final void Function()? onTap;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.grey[200],
        ),
        child: Image.asset(imagePath, height: 40),
      ),
    );
  }
}
