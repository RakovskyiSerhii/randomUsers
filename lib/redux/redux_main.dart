import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logging/logging.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/resources/style.dart';
import 'package:random_users/core/router/app_routing_names.dart';
import 'package:random_users/redux/actions.dart';
import 'package:random_users/redux/app_state.dart';
import 'package:random_users/redux/app_store.dart';
import 'package:random_users/ui/redux/first_entry_redux.dart';
import 'package:random_users/ui/redux/user_details_redux.dart';
import 'package:random_users/ui/redux/user_list_redux.dart';
import 'package:redux/redux.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

void main() {
  _runApp();
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final store = await createReduxStore();

  runApp(StoreProvider(store: store, child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      onInit: (store) => store.dispatch(GetIsFirstLaunch()),
      builder: (BuildContext context, isFirstLaunch) {
        return MaterialApp(
          title: "Random User App redux",
          debugShowCheckedModeBanner: false,
          theme: ThemeStyle.theme,
          initialRoute: isFirstLaunch
              ? AppRoutes.FIRST_ENTRY_SCREEN
              : AppRoutes.USER_LIST_SCREEN,
          onGenerateRoute: (settings) =>
              FlagmanAppRouter.generateRoute(settings),
        );
      },
      converter: (store) {
        print('Converter');
        return store.state.isFirstLaunch;
      },
    );
  }
}

class FlagmanAppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case AppRoutes.FIRST_ENTRY_SCREEN:
        screen = FirstEntryRedux();
        break;
      case AppRoutes.USER_LIST_SCREEN:
        screen = UserListRedux();
        break;
      case AppRoutes.USER_DETAILS_SCREEN:
        return slideInFromRightRoute(UserDetailsRedux(settings.arguments as UserModel));
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
