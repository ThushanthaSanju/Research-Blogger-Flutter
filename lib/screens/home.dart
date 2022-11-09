import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:research_blogger/models/article.dart';
import 'package:research_blogger/screens/blog.dart';
import 'package:research_blogger/screens/myComments.dart';
import 'package:research_blogger/screens/profile.dart';
import 'package:research_blogger/service/userService.dart';

import '../constants.dart';
import '../models/idea.dart';
import '../models/research.dart';
import '../utils/colorUtils.dart';
import '../widgets/BlogList.dart';
import '../widgets/IconButtonBar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPage = 0;

  final screens = [
    const HomeScreen(),
    const Blog(),
    const MyComments(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[_selectedPage],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("1488cc"),
            hexStringToColor("2b32b2")
          ])),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonBar(
                        icon: Icons.home,
                        selected: _selectedPage == 0,
                        onPressed: () {
                          setState(() {
                            _selectedPage = 0;
                          });
                        }),
                    IconButtonBar(
                        icon: Icons.add_circle_outline,
                        selected: _selectedPage == 1,
                        onPressed: () {
                          setState(() {
                            _selectedPage = 1;
                          });
                        }),
                    IconButtonBar(
                        icon: Icons.comment_sharp,
                        selected: _selectedPage == 2,
                        onPressed: () {
                          setState(() {
                            _selectedPage = 2;
                          });
                        }),
                    IconButtonBar(
                        icon: Icons.account_circle,
                        selected: _selectedPage == 3,
                        onPressed: () {
                          setState(() {
                            _selectedPage = 3;
                          });
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // controller
  final TextEditingController _searchController = TextEditingController();

  // sorting options
  var sortingOptions = ["Idea", "Research", "Article"];
  String selectedOption = "Idea";

  String foundUserId = "";
  bool isDownloading = false;

  onSearchChange(String value) async {
    try {
      var response = await UserService.getUserByName(value);

      if (response.data != null) {
        setState(() {
          foundUserId = response.data.uid;
        });
      }
    } catch (e) {
      setState(() {
        foundUserId = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MY_REQUESTS, arguments: true);
            },
            icon: const Icon(
              Icons.messenger,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MY_REQUESTS, arguments: false);
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, SIGN_IN_SCREEN);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  hexStringToColor("1488cc"),
                  hexStringToColor("2b32b2")
                ]),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                labelText: "Search by author",
              ),
              onChanged: (String? val) async {
                await onSearchChange(val!);
              },
            ),
            DropdownButton(
              hint: const Text("Sort"),
              value: selectedOption,
              items: sortingOptions.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (String? newVal) {
                setState(() {
                  selectedOption = newVal!;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: selectedOption == "Idea" || selectedOption == "Research"
                  ? reusableIdeaResearchListHomeView(
                      selectedOption == "Research"
                          ? '${selectedOption.toLowerCase()}es'
                          : '${selectedOption.toLowerCase()}s',
                      foundUserId, addToFavourite)
                  : reusableArticleListHomeView(
                      '${selectedOption.toLowerCase()}s', foundUserId, addToFavourite, download, isDownloading),
            ),
          ],
        ),
      ),
    );
  }

  void addToFavourite(String collection, Idea? idea, Research? research, Article? article) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _collectionReference = _firestore.collection(
        "favourites");

    if (collection == "ideas" && idea != null) {
      _collectionReference.doc().set({
        "category": "idea",
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "post": idea.toJson(),
      }).then((val) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully added!"),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something wrong!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    }

    if (collection == "researches" && research != null) {
      _collectionReference.doc().set({
        "category": "research",
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "post": research.toJson(),
      }).then((val) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully added!"),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something wrong!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    }

    if (collection == "articles" && article != null) {
      _collectionReference.doc().set({
        "category": "article",
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "post": article.toJson(),
      }).then((val) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully added!"),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something wrong!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    }
  }

  Future download(String path) async {
    setState(() {
      isDownloading = true;
    });
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();

      final appDir = await getTemporaryDirectory();
      final filePath = '${appDir.path}/${ref.name}';

      await Dio().download(url, filePath);

      await GallerySaver.saveImage(filePath, toDcim: true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully downloaded!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch(e) {
      print(e.toString());
    } finally {
      setState(() {
        isDownloading = false;
      });
    }

  }
}
