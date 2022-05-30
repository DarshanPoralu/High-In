import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:highin_app/models/post.dart';
import 'package:highin_app/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Some Error Occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
