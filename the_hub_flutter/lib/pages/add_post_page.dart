import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/posts.dart';
import 'package:uuid/uuid.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController postController = TextEditingController();

  void showAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Your post is empty",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void postPost() async {
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();
    Posts post = Posts(
      commentFrom: "",
      commentNb: 0,
      isAComment: false,
      likes: [],
      message: postController.text,
      owner: currentUser!.uid,
      ownerUsername: userData["username"],
      timeStamp: Timestamp.now(),
      postId: const Uuid().v4(),
    );

    try {
      post.addPost();
    } on PostsError catch (e) {
      showAlert(e.message);
      return;
    }

    setState(() {
      postController.clear();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: postPost,
            icon: Icon(
              Icons.send_rounded,
              color:
                  postController.text.isEmpty ? Colors.grey[500] : Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: postController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What's up ?",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                autofocus: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
