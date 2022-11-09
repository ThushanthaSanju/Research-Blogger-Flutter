import 'package:flutter/material.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/models/arguments.dart';
import 'package:research_blogger/models/idea.dart';
import 'package:research_blogger/models/rate.dart';
import 'package:research_blogger/models/requests.dart';
import 'package:research_blogger/screens/addBlog.dart';
import 'package:research_blogger/screens/addComment.dart';
import 'package:research_blogger/screens/authorProfile.dart';
import 'package:research_blogger/screens/blogDetail.dart';
import 'package:research_blogger/screens/home.dart';
import 'package:research_blogger/screens/myRequests.dart';
import 'package:research_blogger/screens/signIn.dart';
import 'package:research_blogger/screens/signUp.dart';
import 'package:research_blogger/screens/updateComment.dart';
import 'package:research_blogger/screens/updateMyRequest.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SIGN_IN_SCREEN:
        return MaterialPageRoute(builder: (_) => const SignIn());
      case SIGN_UP_SCREEN:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => const Home());
      case ADD_BLOG_SCREEN:
        return MaterialPageRoute(builder: (_) => const AddBlog());
      case BLOG_DETAIL_SCREEN:
        {
          final args = settings.arguments as BlogDetailArguments;
          return MaterialPageRoute(
              builder: (_) => BlogDetail(
                    docId: args.docId,
                    type: args.type,
                  ));
        }
      case AUTHOR_PROFILE:
        {
          final String id = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => AuthorProfile(id: id),
          );
        }
      case MY_REQUESTS:
        {
          final bool isMy = settings.arguments as bool;
          return MaterialPageRoute(
            builder: (_) => MyRequests(myRequest: isMy),
          );
        }
      case UPDATE_MY_REQUESTS:
        {
          final Requests request = settings.arguments as Requests;
          return MaterialPageRoute(
            builder: (_) => UpdateMyRequest(requests: request),
          );
        }
      case ADD_COMMENT:
        {
          final AddCommentArguments args = settings.arguments as AddCommentArguments;
          return MaterialPageRoute(
            builder: (_) => AddComment(arguments: args),
          );
        }
      case UPDATE_COMMENT:
        {
          final Rate rate = settings.arguments as Rate;
          return MaterialPageRoute(
            builder: (_) => UpdateComment(rate: rate),
          );
        }
      default:
        return MaterialPageRoute(builder: (_) => const SignIn());
    }
  }
}
