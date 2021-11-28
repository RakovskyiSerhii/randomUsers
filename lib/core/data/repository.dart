import 'package:shared_preferences/shared_preferences.dart';

import 'local/entity/UserEntity.dart';
import 'local/local_repository.dart';
import 'models/UserModel.dart';
import 'network/models/base_response.dart';
import 'network/remote_repository.dart';

class DataRepository {
  static DataRepository? _instance;
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;
  SharedPreferences? _preferences;

  SharedPreferences get preferences => _preferences!;

  factory DataRepository() {
    if (_instance == null) throw 'Data repository must be initialized';
    return _instance!;
  }

  DataRepository._(
      this._remoteRepository, this._localRepository, this._preferences);

  static initialize(LocalRepository localRepository,
      RemoteRepository remoteRepository, SharedPreferences sharedPreferences) {
    _instance =
        DataRepository._(remoteRepository, localRepository, sharedPreferences);
  }

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

  Future refreshUsers() async {
    await _localRepository.removeAllUsers();
    var response = await _remoteRepository.getUsers();
    if (response.isSuccessful()) {
      await _localRepository.saveRemoteUsers(response.data?.results);
    }
  }
}
