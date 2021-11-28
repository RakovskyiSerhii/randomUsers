import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/triple/triple_state.dart';

class UserListStore extends StreamStore<Exception, UserListState> {
  final _repository = DataRepository();

  UserListStore() : super(UserListState.initial());

  Future loadUsersFromDb() async {
    setLoading(true);
    update(UserListState.initial());

    await _loadUsers();
    setLoading(false);
  }

  Future _loadUsers() async {
    final users = await _repository.getUsers();
    update(UserListState.fromData(users));
  }

  Future refreshUsers() async {
    setLoading(true);
    await _repository.refreshUsers();
    await _loadUsers();
    setLoading(false);
  }

  Future removeUser(UserModel userModel, {bool removeFromDB = true}) async {
    final list = state.value!..remove(userModel);
    if (removeFromDB) _repository.removeUser(userModel);
    update(UserListState.fromData(list));
  }
}

class UserListState extends TripleState<List<UserModel>> {
  UserListState.initial() : super.initial();

  UserListState.fromData(List<UserModel> list) : super.fromData(list);
}
