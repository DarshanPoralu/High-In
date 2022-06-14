import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highin_app/utils/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {
  const CommentScreen({required this.postId, Key? key}) : super(key: key);
  final String postId;

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  var userData = {};
  final TextEditingController comment = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> postComment(String postId, String text, String uid, String name, String profilePic) async {
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        Map map = {
          'postId': postId,
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': "${DateTime.now()}"
        };
        await http.post(
            Uri.parse(
                "https://us-central1-highin-e8645.cloudfunctions.net/uploadCommentDataToFirebase"),
            body: map);
      }
    } catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                userData['photoUrl'],
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8,
                ),
                child: TextField(
                  controller: comment,
                  decoration: const InputDecoration(
                    hintText: 'Comment as username',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async{
                await postComment(widget.postId,comment.text,user.uid,user.displayName!,user.photoURL!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: blueColor,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
