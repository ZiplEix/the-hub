import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/pages/add_post_page.dart';
import 'package:the_hub_flutter/pages/profile_page.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
import 'package:the_hub_flutter/widgets/home/drawer/drawer_widget.dart';
import 'package:the_hub_flutter/widgets/home/posts/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  void signOut() {
    FirebaseAuth.instance.signOut();
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostPage()),
          );
        },
        backgroundColor: Colors.grey[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
