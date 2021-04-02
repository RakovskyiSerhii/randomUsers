import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_users/block/user_details_block.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/extensions/parser.dart';
import 'package:random_users/resources/style.dart';
import 'package:random_users/tools/EmailValidator.dart';
import 'package:random_users/extensions/widgets.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel? data;

  UserDetailsScreen(this.data);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late UserDetailsBlock _block;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    if (widget.data != null) {
      firstNameController.text = widget.data?.firstName ?? "";
      lastNameController.text = widget.data?.lastName ?? "";
      emailController.text = widget.data?.email ?? "";
    }
    _block = UserDetailsBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null
            ? "New user"
            : widget.data!.firstName + " " + widget.data!.lastName),
        brightness: Brightness.dark,
        backgroundColor: Colors.green[500],
        actions: [
          Visibility(
            visible: widget.data != null,
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.dp(), horizontal: 20.dp()),
                  content: Text(
                    "Delete user",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 16.dp(), color: Colors.white),
                  ),
                  action: SnackBarAction(
                    onPressed: () {
                      removeUser();
                    },
                    label: "Yes",
                    textColor: Colors.red,
                  ),
                ));
              },
              icon: Icon(
                CupertinoIcons.trash,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.dp(), vertical: 10.dp()),
              child: Column(
                children: [
                  widget.data?.photo != null
                      ? ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.data!.photo!),
                              ),
                            ),
                            width: 100.dp(),
                            height: 100.dp(),
                          ),
                        )
                      : Container(
                          width: 100.dp(),
                          height: 100.dp(),
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 100,
                          ),
                        ),
                  Container(
                    height: 80.dp(),
                    padding: EdgeInsets.only(top: 20.dp()),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 3),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: firstNameController,
                              decoration: InputDecoration(
                                  hintText: "First name",
                                  errorText: firstNameController.text.isEmpty
                                      ? "The field cannot be empty"
                                      : null),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: lastNameController,
                                decoration: InputDecoration(
                                    hintText: "Last name",
                                    errorText: lastNameController.text.isEmpty
                                        ? "The field cannot be empty"
                                        : null)),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Email",
                        errorText: EmailValidator.validate(emailController.text)
                            ? null
                            : "Email is invalid"),
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: Opacity(
              opacity: _isFieldsValid() ? 1 : 0.5,
              child: Container(
                margin: EdgeInsets.all(10.dp()),
                width: double.maxFinite,
                height: 56.dp(),
                child: ElevatedButton(
                  onPressed: () {
                    _saveUser();
                  },
                  child: Text("Save"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          ThemeStyle.getColor)),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  void _saveUser() async {
    if (!_isFieldsValid()) return;
    hideKeyboard();
    UserModel model;
    if (widget.data == null) {
      model = UserModel(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text);
    } else {
      model = widget.data!;
      model.firstName = firstNameController.text;
      model.lastName = lastNameController.text;
      model.email = emailController.text;
    }
    await _block.saveUser(model);
    Navigator.pop(context, model);
  }

  void removeUser() async {
    hideKeyboard();
    await _block.removeUser(widget.data!);
    Navigator.pop(context, widget.data);
  }

  bool _isFieldsValid() =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      EmailValidator.validate(emailController.text);
}
