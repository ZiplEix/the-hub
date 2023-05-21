import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:the_hub_flutter/models/users.dart';

class AuthException extends Error {
  AuthException(this.message);

  final String message;

  @override
  String toString() {
    return "Error: $message";
  }
}

class AuthGoogle {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential? credentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (credentials.user == null) {
      throw AuthException("Failed to sign in with Google");
    }

    String email = credentials.user!.email ?? "";

    if (email == "") {
      throw AuthException("Can't login with this google account");
    }

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("users")
        .doc(credentials.user!.uid)
        .get();

    if (document.exists) {
      // Utilisateur déjà existant
      debugPrint("User already exists in Firestore");
      return;
    }

    Users user = Users(
      email: email,
      uid: credentials.user!.uid,
      username: credentials.user!.displayName ?? credentials.user!.uid,
      photoUrl: credentials.user!.photoURL ?? "",
      bio: "",
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(credentials.user!.uid)
        .set(user.toJson());
  }
}

class AuthWithoutServices {
  Future<void> logInUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message!);
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String confirmPassword,
    String username,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty) {
      throw AuthException("Please fill all the fields");
    }

    if (password != confirmPassword) {
      throw AuthException("Passwords don't match");
    }

    try {
      UserCredential? credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException("Failed to create user");
      }

      Users user = Users(
        email: email,
        uid: credential.user!.uid,
        username: username,
        bio: "",
      );

      user.create();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "Failed to instantiate user");
    } on AuthException catch (e) {
      throw AuthException(e.toString());
    } catch (e) {
      throw AuthException("OTHER ERROR: ${e.toString()}");
    }
  }
}

class AuthService {
  AuthGoogle google = AuthGoogle();
  AuthWithoutServices noServices = AuthWithoutServices();
}
