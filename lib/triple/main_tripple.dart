import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:random_users/core/data/local/local_repository.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/network/remote_repository.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/core/resources/style.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/core/tools/Const.dart';
import 'package:random_users/ui/mobx/first_entry_mobx.dart';
import 'package:random_users/ui/mobx/user_details_mobx.dart';
import 'package:random_users/ui/mobx/user_list_mobx.dart';
import 'package:random_users/ui/triple/first_entry_triple.dart';
import 'package:random_users/ui/triple/user_details_triple.dart';
import 'package:random_users/ui/triple/user_list_triple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

void main() {
  _runApp();
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var isFirstEntry = sharedPreferences.getBool(Const.IS_FIRST_LAUNCH) ?? true;
  final localRepository = LocalRepository();
  await localRepository.initDataBase();
  DataRepository.initialize(
      localRepository, RemoteRepository(), sharedPreferences);
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(App(isFirstEntry));
}

class App extends StatelessWidget {
  final bool _isFirstEntry;

  App(this._isFirstEntry);

  @override
  Widget build(BuildContext context) {
    // final analytics = FirebaseAnalytics();
    return MaterialApp(
      title: "Random User App tripple",
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        // FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeStyle.theme,
      initialRoute: _isFirstEntry
          ? AppRoutes.FIRST_ENTRY_SCREEN
          : AppRoutes.USER_LIST_SCREEN,
      onGenerateRoute: (settings) => FlagmanAppRouter.generateRoute(settings),
    );
  }
}

class FlagmanAppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case AppRoutes.FIRST_ENTRY_SCREEN:
        screen = FirstEntryTriple();
        break;
      case AppRoutes.USER_LIST_SCREEN:
        screen = UserListTriple();
        break;
      case AppRoutes.USER_DETAILS_SCREEN:
        return slideInFromRightRoute(
            UserDetailsTriple(settings.arguments as UserModel?));
      // UserDetailsRedux(settings.arguments as UserModel?));

      default:
        screen = Container();
        break;
    }

    return Platform.isAndroid
        ? MaterialPageRoute(
            builder: (context) {
              return screen;
            },
            settings: settings)
        : CupertinoPageRoute(
            builder: (context) {
              return screen;
            },
            settings: settings);
  }

  static Route slideInFromRightRoute(Widget hereWeGo) {
    return SwipeablePageRoute(
        builder: (ctx) => hereWeGo, canOnlySwipeFromEdge: true);
  }

  static Route slideInFromBottom(Widget hereWeGo) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => hereWeGo,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
