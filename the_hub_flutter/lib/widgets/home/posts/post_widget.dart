import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
import 'package:the_hub_flutter/widgets/home/posts/comment_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/comment_widget.dart';
import 'package:the_hub_flutter/widgets/home/posts/like_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/utilitary_bar_button.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.message,
    required this.userName,
    required this.likes,
    required this.postId,
    required this.time,
    required this.commentNb,
  });

  final String message;
  final String userName;
  final String postId;
  final String time;
  final List<String> likes;
  final int commentNb;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.uid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        "likes": FieldValue.arrayUnion([currentUser.uid]),
      });
    } else {
      postRef.update({
        "likes": FieldValue.arrayRemove([currentUser.uid]),
      });
    }
  }

  void addComent(String commentText) async {
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get();

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .collection("comments")
        .add({
      "commentText": commentText,
      "commentedById": currentUser.uid,
      "commentedByusername": userData["username"],
      "commentTime": Timestamp.now(),
    });

    // update comment number by 1
    FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .update({"commentNb": FieldValue.increment(1)});
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // post info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // post content
                Text(widget.message),
                const SizedBox(height: 10),

                // utilirary bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UtilitaryBarButton(
                      subTitle: widget.commentNb.toString(),
                      icon: CommentButton(
                        onTap: showCommentDialog,
                      ),
                    ),
                    UtilitaryBarButton(
                      icon: LikeButton(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      subTitle: widget.likes.length.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // comments
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.postId)
                      .collection("comments")
                      .orderBy("commentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        final commentData = doc.data() as Map<String, dynamic>;

                        return CommentWidget(
                          text: commentData["commentText"],
                          user: commentData["commentedByusername"],
                          time: formatDate(commentData["commentTime"]),
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
