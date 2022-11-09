import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/models/arguments.dart';
import 'package:research_blogger/models/article.dart';
import 'package:research_blogger/models/research.dart';
import 'package:research_blogger/models/user.dart';
import 'package:research_blogger/service/articleService.dart';
import 'package:research_blogger/service/ideaService.dart';
import 'package:research_blogger/service/researchService.dart';
import 'package:research_blogger/service/userService.dart';

import '../models/idea.dart';
import '../models/rate.dart';
import '../utils/colorUtils.dart';
import '../widgets/RatingList.dart';

class BlogDetail extends StatefulWidget {
  final String docId;
  final String type;

  const BlogDetail({Key? key, required this.docId, required this.type})
      : super(key: key);

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  bool isLoading = false;

  // objects
  Idea idea = Idea(description: "", uid: "", id: "", isRead: false);
  Research research =
      Research(category: "", description: "", uid: "", id: "", isRead: false);
  Article article =
      Article(description: "", id: "", image: "", uid: "", isRead: false);
  User user = User(id: "", uid: "", age: "", userName: "", email: "");

  @override
  void initState() {
    super.initState();

    if (widget.type == "idea") {
      getIdeaById();
    }

    if (widget.type == "research") {
      getResearchById();
    }

    if (widget.type == "article") {
      getArticleById();
    }
  }

  @override
  Widget build(BuildContext context) {
    var relatedPostId = widget.type == "idea"
        ? idea.id
        : widget.type == "research"
            ? research.id
            : article.id;
    var description = widget.type == "idea"
        ? idea.description
        : widget.type == "research"
            ? research.description
            : "";
    var author = widget.type == "idea"
        ? user.userName
        : widget.type == "research"
            ? user.userName
            : widget.type == "article"
                ? user.userName
                : "";
    var isRead = widget.type == "idea"
        ? idea.isRead
        : widget.type == "research"
            ? research.isRead
            : widget.type == "article"
                ? article.isRead
                : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail",
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
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Comment",
        onPressed: () {
          var collection = widget.type == "idea"
              ? "ideas"
              : widget.type == "research"
                  ? "researches"
                  : "articles";
          Navigator.pushNamed(context, ADD_COMMENT,
              arguments: AddCommentArguments(
                  collection: collection,
                  article: article,
                  idea: idea,
                  research: research));
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Author: $author',
                                  style: GoogleFonts.ptSans(
                                      fontSize: 20.0, color: Colors.black)),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, AUTHOR_PROFILE,
                                        arguments: user.uid);
                                  },
                                  child: const Text("View Profile")),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.type == "article" && article.image != ""
                              ? Image.network(article.image as String, height: 300, width: MediaQuery.of(context).size.width,)
                              : Container(),
                          Text(description,
                              style: GoogleFonts.ptSans(
                                  fontSize: 16.0, color: Colors.black)),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mark as read",
                                  style: GoogleFonts.ptSans(
                                      fontSize: 17.0, color: Colors.black)),
                              Checkbox(
                                value: isRead,
                                onChanged: (bool? newVal) {
                                  onMarkRead(newVal);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Comments"),
            Expanded(child: reusableCommentSectionList(relatedPostId!)),
          ],
        ),
      ),
    );
  }

  getIdeaById() async {
    setState(() {
      isLoading = true;
    });
    var response = await IdeaService.getById(widget.docId);

    setState(() {
      idea = response.data as Idea;
    });
    getUserById(idea.uid);
  }

  getResearchById() async {
    setState(() {
      isLoading = true;
    });
    var response = await ResearchService.getById(widget.docId);
    setState(() {
      research = response.data as Research;
    });
    getUserById(research.uid);
  }

  getArticleById() async {
    setState(() {
      isLoading = true;
    });
    var response = await ArticleService.getById(widget.docId);
    setState(() {
      article = response.data as Article;
    });
    getUserById(article.uid);
  }

  getUserById(id) async {
    try {
      var response = await UserService.getUser(id);
      setState(() {
        user = response.data as User;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  onMarkRead(bool? newVal) async {
    if (widget.type == "idea") {
      setState(() {
        idea.isRead = newVal!;
      });

      await IdeaService.update(idea);
    }

    if (widget.type == "research") {
      setState(() {
        research.isRead = newVal!;
      });

      await ResearchService.update(research);
    }

    if (widget.type == "article") {
      setState(() {
        article.isRead = newVal!;
      });

      await ArticleService.update(article);
    }
  }
}
