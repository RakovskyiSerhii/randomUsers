import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_users/block/user_list_block.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/extensions/parser.dart';
import 'package:random_users/router/app_routing_names.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserListBlock _block;
  var _isLoading = false;

  @override
  void initState() {
    _block = UserListBlock();
    _block.getUsers();
    _block.progressStream.listen((event) {
      setState(() {
        _isLoading = event == true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.green[500],
        title: Text(
          "Random users",
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: Colors.white, fontSize: 22.dp()),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                padding: EdgeInsets.symmetric(
                    vertical: 20.dp(), horizontal: 20.dp()),
                content: Text(
                  "Remove all users, and get some new random?",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16.dp(), color: Colors.white),
                ),
                action: SnackBarAction(
                  onPressed: () {
                    _block.refreshUsers();
                  },
                  label: "Yes",
                  textColor: Colors.green,
                ),
              ));
            },
            icon: Icon(
              CupertinoIcons.arrow_3_trianglepath,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.green[500]),
                  ),
                )
              : StreamBuilder<List<UserModel>>(
                  stream: _block.userStream,
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Container()
                        : snapshot.data!.length == 0
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.account_circle_rounded,
                                      size: 75.dp(),
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.dp()),
                                      child: Text(
                                        "All users have been deleted.\nTry to get random users or create your own.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              fontSize: 18.dp(),
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemBuilder: (ctx, position) =>
                                    _getUserItem(snapshot.data![position]),
                                itemCount: snapshot.data?.length ?? 0,
                              );
                  }),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20.dp()),
              child: FloatingActionButton(
                onPressed: () {
                  openUser(null);
                },
                child: Icon(CupertinoIcons.plus),
                backgroundColor: Colors.green[500],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getUserItem(UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.dp(), vertical: 1.dp()),
      child: Dismissible(
        key: Key(user.id!.toString()),
        onDismissed: (direction) {
          _block.removeUser(user);
        },
        child: Card(
          child: ListTile(
            onTap: () {
              openUser(user);
            },
            leading: user.icon != null
                ? Container(
                    width: 45.dp(),
                    height: 45.dp(),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:
                            DecorationImage(image: NetworkImage(user.icon!))),
                  )
                : Container(
                    width: 45.dp(),
                    height: 45.dp(),
                    child: Icon(Icons.account_circle_sharp),
                  ),
            title: Text(user.firstName + " " + user.lastName),
            subtitle: Text(user.email),
          ),
        ),
      ),
    );
  }

  void openUser(UserModel? user) async {
    var result = await Navigator.of(context)
        .pushNamed(AppRoutes.USER_DETAILS_SCREEN, arguments: user);
    if (result != null) {
      _block.removedUser(result as UserModel);
    }
  }
}
