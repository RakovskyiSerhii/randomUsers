import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/resources/dimen.dart';
import 'package:random_users/ui/screens/first_entry/first_entry_screen.dart';
import 'package:random_users/ui/screens/user_details/user_details_screen.dart';
import 'package:random_users/ui/screens/user_list/UserListScreen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'app_routing_names.dart';

class FlagmanAppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case AppRoutes.FIRST_ENTRY_SCREEN:
        screen = FirstEntryScreen();
        break;
      case AppRoutes.USER_LIST_SCREEN:
        screen = UserListScreen();
        break;
      case AppRoutes.USER_DETAILS_SCREEN:
        return slideInFromRightRoute(UserDetailsScreen(settings.arguments as UserModel?));

      default:
        screen = Container();
        break;
    }

    return Platform.isAndroid
        ? MaterialPageRoute(
            builder: (context) {
              Dimen.init(context);
              return screen;
            },
            settings: settings)
        : CupertinoPageRoute(
            builder: (context) {
              Dimen.init(context);
              return screen;
            },
            settings: settings);
  }

  static Route slideInFromRightRoute(Widget hereWeGo) {
    return SwipeablePageRoute(builder: (ctx) => hereWeGo, canOnlySwipeFromEdge: true);
  }

  static Route slideInFromBottom(Widget hereWeGo) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => hereWeGo,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}
