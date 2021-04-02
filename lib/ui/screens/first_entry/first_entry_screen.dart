import 'package:flutter/material.dart';
import 'package:random_users/block/FirstEntryBlock.dart';
import 'package:random_users/data/network/models/base_response.dart';
import 'package:random_users/extensions/parser.dart';
import 'package:random_users/resources/drawables.dart';
import 'package:random_users/router/app_routing_names.dart';
import 'package:random_users/tools/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstEntryScreen extends StatefulWidget {
  @override
  _FirstEntryScreenState createState() => _FirstEntryScreenState();
}

class _FirstEntryScreenState extends State<FirstEntryScreen> {
  late FirstEntryBlock _block;
  bool _isUsersRetrieved = false;

  @override
  void initState() {
    _block = FirstEntryBlock();
    getUsers();
    super.initState();
  }

  void getUsers() async {
    _block.clearError();
    Future.delayed(Duration(seconds: 1), () async {
      var response = await _block.getUserList();
      if (response.isSuccessful()) {
        (await SharedPreferences.getInstance())
            .setBool(Const.IS_FIRST_LAUNCH, false);
        setState(() {
          _isUsersRetrieved = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.green[500],
      ),
      body: Center(
        child: StreamBuilder<BaseResponse<dynamic>?>(
            stream: _block.errorStream,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Center(
                  child: _getErrorWidget(),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    getUsers();
                  },
                  child: Container(
                    child: StreamBuilder<bool>(
                        stream: _block.progressStream,
                        builder: (context, snapshot) {
                          return (snapshot.data ?? true) == true
                              ? _getLoadingWidget()
                              : _isUsersRetrieved
                                  ? _getSuccessWidget()
                                  : Container();
                        }),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget _getErrorWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Drawables.getSvg(Drawables.NETWORK_CONNECTIONS) ?? Container(),
        Padding(
          padding: EdgeInsets.only(top: 5.dp()),
          child: Text(
            "Check your internet connection",
            style: Theme.of(context)
                .textTheme
                .headline1
                ?.copyWith(fontSize: 16.dp()),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.dp()),
          child: MaterialButton(
            onPressed: () {
              getUsers();
            },
            child: Text(
              "Try again",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: Colors.green[500]),
            ),
          ),
        )
      ],
    );
  }

  Widget _getLoadingWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.green[500]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.dp()),
          child: Text(
            "Downloading users. Please stand by ... ",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 14.dp()),
          ),
        ),
      ],
    );
  }

  Widget _getSuccessWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Downloading successful! You free to go :)",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: 14.dp()),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.dp()),
          child: MaterialButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.USER_LIST_SCREEN, (route) => false);
            },
            child: Text(
              "Go to list",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontSize: 18.dp(), color: Colors.green[500]),
            ),
          ),
        )
      ],
    );
  }
}
