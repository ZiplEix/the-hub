import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostsError extends Error {
  PostsError(this.message);

  final String message;

  @override
  String toString() => "PostsError: $message";
}

class Posts {
  Posts({
    required this.commentFrom,
    required this.commentNb,
    required this.isAComment,
    required this.likes,
    required this.message,
    required this.owner,
    required this.ownerUsername,
    required this.timeStamp,
    required this.postId,
  });

  final String commentFrom;
  int commentNb;
  final bool isAComment;
  final List<String> likes;
  final String message;
  final String owner;
  final String ownerUsername;
  final Timestamp timeStamp;
  final String postId;

  late DocumentReference postRef =
      FirebaseFirestore.instance.collection("posts").doc(postId);

  Map<String, dynamic> toJson() => {
        "commentFrom": commentFrom,
        "commentNb": commentNb,
        "isAComment": isAComment,
        "likes": likes,
        "message": message,
        "owner": owner,
        "ownerUsername": ownerUsername,
        "timeStamp": timeStamp,
        "postId": postId,
      };

  static Posts fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    List<String> likesList = List<String>.from(snapshot["likes"]);

    return Posts(
      commentFrom: snapshot["commentFrom"],
      commentNb: snapshot["commentNb"],
      isAComment: snapshot["isAComment"],
      likes: likesList,
      message: snapshot["message"],
      owner: snapshot["owner"],
      ownerUsername: snapshot["ownerUsername"],
      timeStamp: snapshot["timeStamp"],
      postId: snapshot["postId"],
    );
  }

  void addPost() async {
    if (message.isNotEmpty && message.length < 512) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .set(toJson());
    }
    if (message.isEmpty) {
      throw PostsError("Your post is empty");
    }
    if (message.length >= 512) {
      throw PostsError("Your post is too long : 512 characters max");
    }
  }

  static Future<Posts> getFromUid(String postId) async {
    final post =
        await FirebaseFirestore.instance.collection("posts").doc(postId).get();

    return Posts.fromSnapshot(post);
  }

  void addComment(Posts comment) async {
    comment.addPost();

    commentNb++;

    postRef.update({"commentNb": FieldValue.increment(1)});
  }

  void toggleLike(bool isLiked) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
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
}
