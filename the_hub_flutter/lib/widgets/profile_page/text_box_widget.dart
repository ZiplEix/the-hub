import 'package:flutter/material.dart';

class ProfileTextBox extends StatelessWidget {
  const ProfileTextBox({
    super.key,
    required this.sectionName,
    required this.text,
    this.onPressed,
    this.isEditable = true,
  });

  final String text;
  final String sectionName;
  final void Function()? onPressed;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              isEditable
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey[400],
                        size: 25,
                      ),
                    )
                  : const SizedBox(
                      height: 50,
                    ),
            ],
          ),

          // text
          Text(text),
        ],
      ),
    );
  }
}
