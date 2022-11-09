import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/colorUtils.dart';
import '../widgets/BlogList.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  // sorting options
  var sortingOptions = ["Idea", "Research", "Article"];
  String selectedOption = "Idea";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Blog",
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
        onPressed: () {
          Navigator.pushNamed(context, ADD_BLOG_SCREEN);
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            DropdownButton(
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
                  ? reusableIdeaResearchListView(selectedOption == "Research"
                      ? '${selectedOption.toLowerCase()}es'
                      : '${selectedOption.toLowerCase()}s', true)
                  : reusableArticleListView('${selectedOption.toLowerCase()}s', true),
            ),
          ],
        ),
      ),
    );
  }
}
