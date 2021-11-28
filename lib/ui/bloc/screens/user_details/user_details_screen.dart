import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/bloc/user_details/user_details_cubit.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/resources/style.dart';
import 'package:random_users/core/tools/EmailValidator.dart';

class UserDetailsScreen extends StatelessWidget {
  UserDetailsScreen(UserModel? userModel)
      : _cubit = UserDetailsCubit(userModel == null
            ? CreateUserDetailsState()
            : UserDetailsState(userModel));

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final UserDetailsCubit _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDetailsCubit, UserDetailsInitialState>(
        bloc: _cubit,
        listener: (_, state) {
          if (state is UserSavedState) {
            Navigator.pop(context);
          }
        },
        buildWhen: (prev, state) => !(state is UserSavedState),
        builder: (ctx, state) {
          UserModel? user;
          if (state is UserDetailsState) {
            user = state.userModel;
            firstNameController.text = user.firstName;
            lastNameController.text = user.lastName;
            emailController.text = user.email;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(user == null
                  ? "New user"
                  : user.firstName + " " + user.lastName),
              backgroundColor: Colors.green[500],
              actions: [
                Visibility(
                  visible: user != null,
                  child: IconButton(
                    onPressed: user == null
                        ? null
                        : () => _showRemoveUserSnackBar(user!, context),
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
                      user?.photo != null
                          ? ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(user!.photo!),
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
                                  onChanged: (value) {},
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                      hintText: "First name",
                                      errorText:
                                          firstNameController.text.isEmpty
                                              ? "The field cannot be empty"
                                              : null),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: TextField(
                                    onChanged: (value) {},
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                        hintText: "Last name",
                                        errorText:
                                            lastNameController.text.isEmpty
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
                            errorText:
                                EmailValidator.validate(emailController.text)
                                    ? null
                                    : "Email is invalid"),
                        controller: emailController,
                        onChanged: (value) {},
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
                          backgroundColor: MaterialStateProperty.resolveWith(
                              ThemeStyle.getColor)),
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
    _cubit.saveUser(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
    );
  }

  void removeUser(UserModel user, BuildContext context) async {
    _hideKeyboard(context);
    _cubit.deleteUser(user);
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  bool _isFieldsValid() =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      EmailValidator.validate(emailController.text);
}
