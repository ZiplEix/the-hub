import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/posts.dart';
import 'package:the_hub_flutter/widgets/home/posts/post_widget.dart';

class CommentListWidget extends StatefulWidget {
  const CommentListWidget({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final Posts comment =
                        Posts.fromSnapshot(snapshot.data!.docs[index]);
                    return PostWidget(post: comment);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: SelectableText("Error: ${snapshot.error}"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy(
                  "timeStamp",
                  descending: true,
                )
                .where("isAComment", isEqualTo: true)
                .where("commentFrom", isEqualTo: widget.postId)
                .snapshots(),
          ),
        ),
      ],
    );
  }
}
