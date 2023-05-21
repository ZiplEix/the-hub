import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/posts.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
import 'package:the_hub_flutter/widgets/view_post_page/comments_list_widget.dart';
import 'package:the_hub_flutter/widgets/view_post_page/main_post_widget.dart';
import 'package:the_hub_flutter/widgets/view_post_page/utilitary_bar_widget.dart';
import 'package:uuid/uuid.dart';

class ViewPostPage extends StatefulWidget {
  const ViewPostPage({
    super.key,
    // required this.message,
    // required this.userName,
    // required this.likes,
    // required this.postId,
    // required this.time,
    // required this.commentNb,
    // required this.isAComment,
    // this.commentFrom,
    required this.post,
  });

  // final String message;
  // final String userName;
  // final String postId;
  // final String time;
  // final List<String> likes;
  // final int commentNb;
  // final bool isAComment;
  // final String? commentFrom;

  final Posts post;

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController commentController = TextEditingController();

  bool isLiked = false;
  String likesCount = "0";
  String commentCount = "0";

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likesCount = isLiked
          ? (int.parse(likesCount) + 1).toString()
          : (int.parse(likesCount) - 1).toString();
    });

    widget.post.toggleLike(isLiked);
  }

  void addComent(String commentText) async {
    if (commentText.isEmpty) return;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    Posts comment = Posts(
      owner: currentUser.uid,
      ownerUsername: userData["username"],
      message: commentText,
      timeStamp: Timestamp.now(),
      likes: [],
      commentNb: 0,
      isAComment: true,
      commentFrom: widget.post.postId,
      postId: const Uuid().v4(),
    );

    widget.post.addComment(comment);

    setState(() {
      commentCount = (int.parse(commentCount) + 1).toString();
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add comment"),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: "Write a comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComent(commentController.text);
              commentController.clear();
              Navigator.pop(context);
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likes.contains(currentUser.uid);
    likesCount = widget.post.likes.length.toString();
    commentCount = widget.post.commentNb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Thread"),
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MainPostWidget(
              message: widget.post.message,
              userName: widget.post.ownerUsername,
              time: formatDate(widget.post.timeStamp),
            ),
            const SizedBox(height: 10),
            UtilitaryBar(
              isLiked: isLiked,
              likesCount: likesCount,
              commentCount: commentCount,
              toggleLike: toggleLike,
              showCommentDialog: showCommentDialog,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CommentListWidget(
                postId: widget.post.postId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
