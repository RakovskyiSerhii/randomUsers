import 'package:mobx/mobx.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';

part 'user_list_controller.g.dart';

class UserListController = _UserListController with _$UserListController;

abstract class _UserListController with Store {
  final _repository = DataRepository();

  @observable
  List<UserModel>? users;
  @observable
  bool isLoading = false;

  Future loadUsersFromDb() async {
    isLoading = true;
    users = null;
    await _loadUsers();
    isLoading = false;
  }

  @action
  Future _loadUsers() async {
    users = await _repository.getUsers();
  }

  @action
  Future refreshUsers() async {
    isLoading = true;
    users = null;
    await _repository.refreshUsers();
    await _loadUsers();
    isLoading = false;
  }

  @action
  Future removeUser(UserModel userModel, {bool removeFromDB = true}) async {
    final list = users!..remove(userModel);
    if (removeFromDB) _repository.removeUser(userModel);
    users = list;
  }
}
