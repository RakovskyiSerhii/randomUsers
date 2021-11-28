import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsInitialState> {
  final _repository = DataRepository();

  UserDetailsCubit(UserDetailsInitialState initialState) : super(initialState);

  void saveUser(String name, String surname, String email) async {
    final oldState = state;
    UserModel userModel;
    if (oldState is UserDetailsState) {
      userModel = oldState.userModel;
      userModel.firstName = name;
      userModel.lastName = surname;
      userModel.email = email;
      await _repository.updateUser(userModel);
    } else {
      userModel = UserModel(firstName: name, lastName: surname, email: email);
      await _repository.insertUser(userModel);
    }
    emit(UserSavedState(userModel));
  }


  void deleteUser(UserModel user) async {
    await _repository.removeUser(user);
    emit(UserSavedState(user));
  }

}
