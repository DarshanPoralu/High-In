import 'package:flutter/material.dart';
import 'package:highin_app/screens/add_post_screen.dart';
import 'package:highin_app/screens/feed_screen.dart';
import 'package:highin_app/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Fav'),
  Text('Profile'),
];
