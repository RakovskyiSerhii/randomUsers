import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:random_users/core/data/network/remote_repository.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/data/local/local_repository.dart';
import 'core/resources/style.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routing_names.dart';
import 'core/tools/Const.dart';

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
      title: "Random User App",
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
