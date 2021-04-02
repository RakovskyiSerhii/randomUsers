import 'package:random_users/data/local/entity/UserEntity.dart';
import 'package:random_users/data/local/local_repository.dart';
import 'package:random_users/data/network/models/base_response.dart';
import 'package:random_users/data/network/remote_repository.dart';
import 'package:random_users/tools/Const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/UserModel.dart';

class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  final _remoteRepository = RemoteRepository();
  final _localRepository = LocalRepository();
  SharedPreferences? _preferences;

  factory DataRepository() {
    return _instance;
  }

  DataRepository._internal();

  Future<List<UserModel>> getUsers() async {
    var entityList = await _localRepository.getAllUsers();
    return entityList.map((e) => UserModel.fromEntity(e)).toList();
  }

  Future<BaseResponse> getRandomUsers() async {
    var response = await _remoteRepository.getUsers();
    if (response.isSuccessful()) {
      _localRepository.saveRemoteUsers(response.data!.results);
    }
    return response;
  }

  Future<void> updateUser(UserModel model) {
    return _localRepository.updateUser(UserEntity.fromModel(model));
  }

  Future<void> insertUser(UserModel model) {
    return _localRepository.insertUser(UserEntity.fromModel(model));
  }

  Future<int> removeUser(UserModel model) {
    return _localRepository.removeUser(UserEntity.fromModel(model));
  }

  Future<void> refreshUsers() async {
    await _localRepository.removeAllUsers();
    var response = await _remoteRepository.getUsers();
    if (response.isSuccessful()) {
      await _localRepository.saveRemoteUsers(response.data?.results);
    }
  }
}
