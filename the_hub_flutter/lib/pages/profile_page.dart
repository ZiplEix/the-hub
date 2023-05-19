// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:the_hub_flutter/widgets/profile_page/text_box_widget.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final currentUser = FirebaseAuth.instance.currentUser;

//   final userCollection = FirebaseFirestore.instance.collection("users");

//   Future<void> editField(String field) async {
//     String newValue = "";
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.grey[900],
//         title: Text(
//           "Edit $field",
//           style: const TextStyle(color: Colors.white),
//         ),
//         content: TextField(
//           autofocus: true,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: "Enter new $field",
//             hintStyle: const TextStyle(color: Colors.grey),
//           ),
//           onChanged: (value) {
//             newValue = value;
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(newValue),
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );

//     if (newValue.isNotEmpty) {
//       await userCollection.doc(currentUser!.uid).update({
//         field: newValue,
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         title: const Text("Profile Page"),
//         backgroundColor: Colors.grey[900],
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection("users")
//             .doc(currentUser!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final userData = snapshot.data!.data() as Map<String, dynamic>;

//             return ListView(
//               children: [
//                 const SizedBox(height: 50),
//                 // profil pic
//                 Icon(
//                   Icons.person,
//                   color: Colors.grey[900],
//                   size: 72,
//                 ),
//                 const SizedBox(height: 10),

//                 // user infos
//                 Text(
//                   currentUser!.email!,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 50),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: Text(
//                     "My infos",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),

//                 ProfileTextBox(
//                   text: userData["username"],
//                   sectionName: "Username",
//                   onPressed: () => editField("username"),
//                 ),

//                 ProfileTextBox(
//                   text: userData["bio"],
//                   sectionName: "Bio",
//                   onPressed: () => editField("bio"),
//                 ),
//                 const SizedBox(height: 50),

//                 // user posts
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: Text(
//                     "My posts",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error.toString()}"),
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/utils/format_date.dart';
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
                const SizedBox(height: 50),

                // user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My posts",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                        child: SelectableText("Error: ${snapshot.error}"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .where("owner", isEqualTo: currentUser!.uid)
                      .orderBy(
                        "timeStamp",
                        descending: true,
                      )
                      .snapshots(),
                ),
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
