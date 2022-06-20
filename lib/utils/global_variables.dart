import 'package:appins/screens/add_post_screen.dart';
import 'package:appins/screens/feed_screen.dart';
import 'package:appins/screens/profile_screen.dart';
import 'package:appins/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;


List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

