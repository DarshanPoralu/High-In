import 'dart:js_util';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // adding image to firebase

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    ref.putData(file);
  }
}
