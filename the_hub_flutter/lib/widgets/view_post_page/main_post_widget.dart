import 'package:flutter/material.dart';

class MainPostWidget extends StatelessWidget {
  const MainPostWidget({
    super.key,
    required this.message,
    required this.userName,
    required this.time,
  });

  final String message;
  final String userName;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // profil pic
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName),
                  Text(time),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SelectableText(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
