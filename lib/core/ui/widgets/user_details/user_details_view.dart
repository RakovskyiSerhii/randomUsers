import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/resources/style.dart';
import 'package:random_users/core/tools/EmailValidator.dart';

typedef OnUserSaveCallback(String name, String surname, String email);

class UserDetailsWidget extends StatefulWidget {
  final UserModel? userModel;
  final OnUserSaveCallback onSave;
  final VoidCallback onRemove;

  UserDetailsWidget({
    this.userModel,
    required this.onSave,
    required this.onRemove,
  });

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    if (widget.userModel != null) {
      firstNameController.text = widget.userModel!.firstName;
      lastNameController.text = widget.userModel!.lastName;
      emailController.text = widget.userModel!.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel == null
            ? "New user"
            : widget.userModel!.firstName + " " + widget.userModel!.lastName),
        backgroundColor: Colors.green[500],
        actions: [
          Visibility(
            visible: widget.userModel != null,
            child: IconButton(
              onPressed: widget.userModel == null
                  ? null
                  : () => _showRemoveUserSnackBar(widget.userModel!, context),
              icon: Icon(
                CupertinoIcons.trash,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                widget.userModel?.photo != null
                    ? ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.userModel!.photo!),
                            ),
                          ),
                          width: 100,
                          height: 100,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: 100,
                        ),
                      ),
                Container(
                  height: 80,
                  padding: EdgeInsets.only(top: 20),
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
          Spacer(),
          Opacity(
            opacity: _isFieldsValid() ? 1 : 0.5,
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.maxFinite,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _saveUser(context);
                },
                child: Text("Save"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith(ThemeStyle.getColor)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showRemoveUserSnackBar(UserModel user, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      content: Text(
        "Delete user?",
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 16, color: Colors.white),
      ),
      action: SnackBarAction(
        onPressed: () {
          removeUser(user, context);
        },
        label: "Yes",
        textColor: Colors.red,
      ),
    ));
  }

  void _saveUser(BuildContext context) async {
    if (!_isFieldsValid()) return;
    _hideKeyboard(context);
    widget.onSave(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
    );
  }

  void removeUser(UserModel user, BuildContext context) async {
    _hideKeyboard(context);
    widget.onRemove();
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  bool _isFieldsValid() =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      EmailValidator.validate(emailController.text);
}
