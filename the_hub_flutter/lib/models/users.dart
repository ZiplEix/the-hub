import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  const Users({
    required this.email,
    required this.uid,
    required this.username,
    required this.bio,
    this.photoUrl = "",
  });

  final String email;
  final String uid;
  final String username;
  final String bio;
  final String? photoUrl;

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "username": username,
        "bio": bio,
        "photoUrl": photoUrl,
      };

  static Users fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
      email: snapshot["email"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      bio: snapshot["bio"],
      photoUrl: snapshot["photoUrl"],
    );
  }

  void create() async {
    FirebaseFirestore.instance.collection("users").doc(uid).set(toJson());
  }

  void updateBio(String bio) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"bio": bio});
  }

  void updateUsername(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"username": username});
  }

  static Future<Users> getFromUid(String uid) async {
    var snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    return fromSnapshot(snap);
  }

  static Future<Users> getFromEmail(String email) async {
    var snap = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    return fromSnapshot(snap.docs.first);
  }
}
