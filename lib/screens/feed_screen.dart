// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:highin_app/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:highin_app/widgets/post_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:highin_app/models/post.dart';
import 'package:highin_app/models/user.dart';
import 'package:highin_app/widgets/post_card.dart';
import 'package:highin_app/utils/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset('assets/ic_instagram.svg',
              color: primaryColor, height: 32),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.messenger_outline,
              ),
            )
          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,
          AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError) {
              return const Text('Error');
            }
            else if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            }
            else{
              return const Text('Empty data');
            }
          }
          else{
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
