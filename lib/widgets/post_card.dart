import 'package:flutter/material.dart';
import 'package:highin_app/utils/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:highin_app/models/user.dart' as model;
import 'package:highin_app/resources/firestore_method.dart';
import 'package:highin_app/utils/colors.dart';
import 'package:highin_app/utils/global_variables.dart';
import 'package:highin_app/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1653819155995-989f24c8cf60?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80'),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),

          // IMAGE SELECTION
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
                'https://images.unsplash.com/photo-1653763744306-12537eaf2a11?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0NHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=60',
                fit: BoxFit.cover),
          ),

          // LIKE COMMENT SECTION
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ), // Icon
              ), // IconButton
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ), // Icon
              ), // IconButton
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ), // EdgeInsets.sym
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '1,231 likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: '@'+ user.displayName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' Hey this is some description to be replaced',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                  child: Text('View all 200 comments',
                  style: const TextStyle(fontSize: 16,color: secondaryColor),
                  ),
                ),),
                Container(
                  child: Text('30/05/2022',
                  style: const TextStyle(fontSize: 16,color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
