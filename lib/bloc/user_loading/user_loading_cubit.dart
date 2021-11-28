import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/core/tools/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_loading_state.dart';

class UserLoadingCubit extends Cubit<UserLoadingState> {
  final _repository = DataRepository();

  UserLoadingCubit() : super(UserLoadingProgressState()) {
    loadUsers();
  }

  void loadUsers() async {
    final response = await _repository.getRandomUsers();
    if (response.isSuccessful()) {
      final preferences = await SharedPreferences.getInstance();
      preferences.setBool(Const.IS_FIRST_LAUNCH, false);
      emit(UserLoadingCompleteState());
    } else {
      emit(UserLoadingErrorState());
    }
  }
}
