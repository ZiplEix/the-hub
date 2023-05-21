import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/posts.dart';
import 'package:the_hub_flutter/pages/view_post_page.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
import 'package:the_hub_flutter/widgets/home/posts/comment_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/comment_widget.dart';
import 'package:the_hub_flutter/widgets/home/posts/like_button.dart';
import 'package:the_hub_flutter/widgets/home/posts/utilitary_bar_button.dart';
import 'package:uuid/uuid.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final Posts post;

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
    isLiked = widget.post.likes.contains(currentUser.uid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewPostPage(post: widget.post),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(top: 20, left: 25, right: 25),
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 20),
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
                        widget.post.ownerUsername,
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        formatDate(widget.post.timeStamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // post content
                  SelectableText(widget.post.message),
                  const SizedBox(height: 10),

                  // utilirary bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UtilitaryBarButton(
                        subTitle: widget.post.commentNb.toString(),
                        icon: CommentButton(
                          onTap: showCommentDialog,
                        ),
                      ),
                      UtilitaryBarButton(
                        icon: LikeButton(
                          isLiked: isLiked,
                          onTap: toggleLike,
                        ),
                        subTitle: widget.post.likes.length.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // comments
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .orderBy(
                          "timeStamp",
                          descending: true,
                        )
                        .where("isAComment", isEqualTo: true)
                        .where("commentFrom", isEqualTo: widget.post.postId)
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
                        children: snapshot.data!.docs.take(3).map((doc) {
                          final commentData =
                              doc.data() as Map<String, dynamic>;

                          return CommentWidget(
                            text: commentData["message"],
                            user: commentData["ownerUsername"],
                            time: formatDate(commentData["timeStamp"]),
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
      ),
    );
  }
}
