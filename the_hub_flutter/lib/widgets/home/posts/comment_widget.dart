import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.text,
    required this.time,
    required this.user,
  });

  final String text;
  final String user;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user & time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // comment
          Text(text),
        ],
      ),
    );
  }
}
