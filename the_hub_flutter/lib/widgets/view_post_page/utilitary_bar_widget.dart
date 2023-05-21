import 'package:flutter/material.dart';
import 'package:the_hub_flutter/widgets/home/posts/comment_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/like_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/utilitary_bar_button.dart';

class UtilitaryBar extends StatefulWidget {
  const UtilitaryBar({
    super.key,
    required this.isLiked,
    required this.likesCount,
    required this.commentCount,
    required this.toggleLike,
    required this.showCommentDialog,
  });

  final bool isLiked;
  final String likesCount;
  final String commentCount;
  final void Function() toggleLike;
  final void Function() showCommentDialog;

  @override
  State<UtilitaryBar> createState() => _UtilitaryBarState();
}

class _UtilitaryBarState extends State<UtilitaryBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey[500],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UtilitaryBarButton(
              subTitle: widget.commentCount,
              icon: CommentButton(
                onTap: widget.showCommentDialog,
              ),
            ),
            UtilitaryBarButton(
              subTitle: widget.likesCount,
              icon: LikeButton(
                isLiked: widget.isLiked,
                onTap: widget.toggleLike,
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
