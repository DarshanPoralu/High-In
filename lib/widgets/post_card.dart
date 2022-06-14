import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:highin_app/screens/comments_screen.dart';
import 'package:highin_app/utils/colors.dart';
import 'package:highin_app/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PostCard extends StatefulWidget {
  final Map snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLikeAnimating = false;
  Future<void> likePost(String postId, String uid, List likes) async {
    if (likes.contains(uid)) {
      likes.remove(uid);
    } else {
      likes.add(uid);
    }
    Map map = {'postId': postId, 'uid': uid, 'likes': jsonEncode(likes)};
    await http.post(
        Uri.parse(
            "https://us-central1-highin-e8645.cloudfunctions.net/updateLikePost"),
        body: map);
  }

  @override
  Widget build(BuildContext context) {
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
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
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
          GestureDetector(
            onDoubleTap: () async {
              await likePost(widget.snap['postId'], user.uid,
                  jsonDecode(widget.snap['likes']));
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child:
                      Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 0.50 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 100),
                  ),
                )
              ],
            ),
          ),
          // LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: jsonDecode(widget.snap['likes']).contains(user
                    .uid), //Later add the snap thing--------------------------------------------------------
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await likePost(widget.snap['postId'], user.uid,
                        jsonDecode(widget.snap['likes']));
                  },
                  icon: jsonDecode(widget.snap['likes']).contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ), // Icon
                ),
              ), // IconButton
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(postId: widget.snap['postId']),
                  ),
                ),
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
                    "${jsonDecode(widget.snap['likes']).length}",
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
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " ${widget.snap['description']}",
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'View all 200 comments',
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(widget.snap['datePublished'])),
                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
