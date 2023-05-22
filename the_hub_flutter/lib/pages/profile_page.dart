import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/posts.dart';
import 'package:the_hub_flutter/widgets/home/posts/post_widget.dart';
import 'package:the_hub_flutter/widgets/profile_page/text_box_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final userCollection = FirebaseFirestore.instance.collection("users");

  int onglet = 0;

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (newValue.isNotEmpty) {
      await userCollection.doc(currentUser!.uid).update({
        field: newValue,
      });
    }
  }

  void updateOnglet(int index) {
    setState(() {
      onglet = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Profile Page"),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                // profil pic
                Icon(
                  Icons.person,
                  color: Colors.grey[900],
                  size: 72,
                ),
                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My infos",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                ProfileTextBox(
                  text: userData["email"],
                  sectionName: "Email",
                  isEditable: false,
                ),
                ProfileTextBox(
                  text: userData["username"],
                  sectionName: "Username",
                  onPressed: () => editField("username"),
                ),
                ProfileTextBox(
                  text: userData["bio"],
                  sectionName: "Bio",
                  onPressed: () => editField("bio"),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.grey[700],
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),

                // Choose  for user post or user comment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => updateOnglet(0),
                      child: const Text("My Posts"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => updateOnglet(1),
                      child: const Text("My comments"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => updateOnglet(2),
                      child: const Text("My likes"),
                    ),
                  ],
                ),

                onglet == 0
                    ? MyPostsWidget(currentUser: currentUser)
                    : Container(),
                onglet == 1
                    ? MyCommentsWidget(currentUser: currentUser)
                    : Container(),
                onglet == 2
                    ? MyLikesWidget(currentUser: currentUser)
                    : Container(),

                const SizedBox(height: 25),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class MyLikesWidget extends StatefulWidget {
  const MyLikesWidget({
    super.key,
    required this.currentUser,
  });

  final User? currentUser;

  @override
  State<MyLikesWidget> createState() => _MyLikesWidgetState();
}

class _MyLikesWidgetState extends State<MyLikesWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final Posts post = Posts.fromSnapshot(snapshot.data!.docs[index]);
              return PostWidget(post: post);
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
          .where("likes", arrayContains: widget.currentUser!.uid)
          .snapshots(),
    );
  }
}

class MyCommentsWidget extends StatefulWidget {
  const MyCommentsWidget({
    super.key,
    required this.currentUser,
  });

  final User? currentUser;

  @override
  State<MyCommentsWidget> createState() => _MyCommentsWidgetState();
}

class _MyCommentsWidgetState extends State<MyCommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final Posts post = Posts.fromSnapshot(snapshot.data!.docs[index]);
              return PostWidget(post: post);
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
          .where("owner", isEqualTo: widget.currentUser!.uid)
          .where("isAComment", isEqualTo: true)
          .snapshots(),
    );
  }
}

class MyPostsWidget extends StatefulWidget {
  const MyPostsWidget({
    super.key,
    required this.currentUser,
  });

  final User? currentUser;

  @override
  State<MyPostsWidget> createState() => _MyPostsWidgetState();
}

class _MyPostsWidgetState extends State<MyPostsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final Posts post = Posts.fromSnapshot(snapshot.data!.docs[index]);
              return PostWidget(post: post);
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
          .where("owner", isEqualTo: widget.currentUser!.uid)
          .where("isAComment", isEqualTo: false)
          .snapshots(),
    );
  }
}
