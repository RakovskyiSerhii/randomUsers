import 'dart:async';

import 'package:random_users/core/base_block.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/data/repository.dart';

class UserListBlock extends BaseBloc {
  DataRepository _repository = DataRepository();

  StreamController<List<UserModel>> _userController =
      StreamController.broadcast();
  List<UserModel> _userList = [];

  StreamSink get _userSink => _userController.sink;

  Stream<List<UserModel>> get userStream => _userController.stream;

  UserListBlock() {
    showProgress();
  }

  void getUsers({bool withDelay = false}) async {
    showProgress();
    var list = await _repository.getUsers();
    _userList = list;
    _userSink.add(_userList);
    hideProgress();
  }

  Future<int> removeUser(UserModel model) {
    _userList.remove(model);
    return _repository.removeUser(model);
  }

  void removedUser(UserModel model) {
    _userList.remove(model);
    _userSink.add(_userList);
  }

  void refreshUsers() async {
    showProgress();
    await _repository.refreshUsers();
    _userList.clear();
    var list = await _repository.getUsers();
    Future.delayed(Duration(seconds: 1), () {
      _userList = list;
      _userSink.add(_userList);
    });
    hideProgress();
  }

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }
}
