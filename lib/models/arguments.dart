import 'package:research_blogger/models/article.dart';
import 'package:research_blogger/models/research.dart';

import 'idea.dart';

class BlogDetailArguments {
  String docId;
  String type;

  BlogDetailArguments(this.docId, this.type);
}

class AddCommentArguments {
  String collection;
  Idea? idea;
  Research? research;
  Article? article;

  AddCommentArguments(
      {required this.collection, this.idea, this.research, this.article});
}