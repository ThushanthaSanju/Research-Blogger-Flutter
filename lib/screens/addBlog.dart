import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:research_blogger/models/article.dart';
import 'package:research_blogger/models/idea.dart';
import 'package:research_blogger/models/research.dart';
import 'package:research_blogger/service/articleService.dart';
import 'package:research_blogger/widgets/Button.dart';
import 'package:uuid/uuid.dart';

import '../service/ideaService.dart';
import '../service/researchService.dart';
import '../utils/colorUtils.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  // controller
  final TextEditingController _ideaController = TextEditingController();
  final TextEditingController _researchController = TextEditingController();
  final TextEditingController _articleController = TextEditingController();

  final storageRef = FirebaseStorage.instance.ref();

  bool isLoading = false;
  String profession = "Researcher";
  File? image;

  // professions
  var professions = ["Researcher", "Student"];

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (img == null) return;

      final imgTemp = File(img.path);

      setState(() {
        image = imgTemp;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadImage(String id, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask task = ref.putFile(File(image!.path!));

    return await (await task).ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "New Post",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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
          bottom: const TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              child: Text(
                "Idea",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                "Research",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                "Article",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [ideaTab(), researchTab(), articleTab()]),
      ),
    );
  }

  Container ideaTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          TextField(
              controller: _ideaController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Insert your innovative idea...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                        width: .8,
                        style: BorderStyle.solid,
                        color: Colors.blue)),
              )),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : reusableButton(context, "Add", () async {
                  setState(() {
                    isLoading = true;
                  });
                  var userId = FirebaseAuth.instance.currentUser?.uid;
                  var response = await IdeaService.create(Idea(
                      description: _ideaController.text,
                      uid: userId as String,
                      isRead: false));

                  if (response.status == 201) {
                    setState(() {
                      isLoading = false;
                      _ideaController.text = "";
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(response.message as String),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ));
                  }

                  if (response.status == 500) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(response.message as String),
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(seconds: 3),
                    ));
                  }
                }, null, null),
        ],
      ),
    );
  }

  Container researchTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton(
              value: profession,
              items: professions.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (String? newVal) {
                setState(() {
                  profession = newVal!;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: _researchController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Type here...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                          width: .8,
                          style: BorderStyle.solid,
                          color: Colors.blue)),
                )),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : reusableButton(context, "Upload", () async {
                    setState(() {
                      isLoading = true;
                    });
                    var userId = FirebaseAuth.instance.currentUser?.uid;
                    var response = await ResearchService.create(Research(
                        category: profession,
                        description: _researchController.text,
                        uid: userId as String,
                        isRead: false));

                    if (response.status == 201) {
                      setState(() {
                        isLoading = false;
                        _researchController.text = "";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response.message as String),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ));
                    }

                    if (response.status == 500) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response.message as String),
                        backgroundColor: Colors.redAccent,
                        duration: const Duration(seconds: 3),
                      ));
                    }
                  }, null, null),
          ],
        ),
      ),
    );
  }

  Container articleTab() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: _articleController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Type here...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                          width: .8,
                          style: BorderStyle.solid,
                          color: Colors.blue)),
                )),
            const SizedBox(
              height: 10,
            ),
            image != null
                ? Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: image != null
                                ? FileImage(image!) as ImageProvider
                                : const NetworkImage(
                                    'https://cdn.pixabay.com/photo/2018/01/29/17/01/woman-3116587_960_720.jpg'))),
                  )
                : Container(),
            reusableButton(context, "Pick Image", pickImage, null, null),
            isLoading
                ? const CircularProgressIndicator()
                : reusableButton(context, "Add", () async {
                    String id = const Uuid().v4();
                    final type = lookupMimeType(image?.path as String)?.split('/').last;
                    var path = "images/$id.${type!}";

                    var imageId = await uploadImage(id, path);
                    var userId = FirebaseAuth.instance.currentUser?.uid;

                    setState(() {
                      isLoading = true;
                    });

                    var response = await ArticleService.create(Article(
                        description: _articleController.text,
                        image: imageId,
                        imagePath: path,
                        uid: userId as String,
                        isRead: false));

                    if (response.status == 201) {
                      setState(() {
                        isLoading = false;
                        _articleController.text = "";
                        image = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response.message as String),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ));
                    }

                    if (response.status == 500) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(response.message as String),
                        backgroundColor: Colors.redAccent,
                        duration: const Duration(seconds: 3),
                      ));
                    }
                  }, null, null),
          ],
        ),
      ),
    );
  }
}
