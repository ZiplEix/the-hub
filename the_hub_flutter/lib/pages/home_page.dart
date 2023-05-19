import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/pages/profile_page.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
import 'package:the_hub_flutter/widgets/home/drawer/drawer_widget.dart';
import 'package:the_hub_flutter/widgets/home/message_input_widget.dart';
import 'package:the_hub_flutter/widgets/home/posts/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController postController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postPost() async {
    if (postController.text.isNotEmpty) {
      final userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();
      FirebaseFirestore.instance.collection("posts").add({
        "owner": currentUser!.uid,
        "ownerUsername": userData["username"],
        "message": postController.text,
        'timeStamp': Timestamp.now(),
        "likes": [],
        "commentNb": 0,
      });
    }

    setState(() {
      postController.clear();
    });
  }

  void goToProfilPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("The Hub"),
        backgroundColor: Colors.grey[900],
      ),
      drawer: DrawerWidget(
        homePage: const HomePage(),
        onProfilTap: goToProfilPage,
        onSignOutTap: signOut,
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Column(
            children: [
              // The Hub
              Expanded(
                child: StreamBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return PostWidget(
                            message: post["message"],
                            userName: post["ownerUsername"],
                            postId: post.id,
                            likes: List<String>.from(post["likes"]),
                            time: formatDate(post["timeStamp"]),
                            commentNb: post["commentNb"],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
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
                      .snapshots(),
                ),
              ),

              // post message
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MessageInput(
                        controller: postController,
                        hintText: "Write your throught",
                      ),
                    ),

                    // post button
                    IconButton(
                      onPressed: postPost,
                      icon: const Icon(Icons.arrow_circle_up),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
