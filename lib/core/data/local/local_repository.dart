import 'package:random_users/core/data/local/entity/UserEntity.dart';
import 'package:random_users/core/data/network/models/UserResponse.dart';

import 'database.dart';

class LocalRepository {
  static final LocalRepository _instance = LocalRepository._internal();
  AppDatabase? _database;

  factory LocalRepository() {
    return _instance;
  }

  Future<void> initDataBase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  LocalRepository._internal() {
    initDataBase();
  }

  Future<void> saveRemoteUsers(List<UserResponse>? users) async {
    if (_database == null) {
      await initDataBase();
    }
    await _database!.userDao.insertUsers(users
            ?.map((e) => UserEntity(null,
                firstName: e.name?.first ?? "",
                lastName: e.name?.last ?? "",
                email: e.email ?? "",
                icon: e.picture?.thumbnail ?? "",
                photo: e.picture?.large ?? ""))
            .toList() ??
        []);
  }

  Future<List<UserEntity>> getAllUsers() async {
    return _database!.userDao.getAllUsers();
  }

  Future<void> updateUser(UserEntity entity) {
    return _database!.userDao.updateUser(entity);
  }

  Future<void> insertUser(UserEntity entity) {
    return _database!.userDao.insertUser(entity);
  }

  Future<int> removeUser(UserEntity entity) {
    return _database!.userDao.deleteUsers([entity]);
  }

  Future<int> removeAllUsers() async {
    var users = await _database!.userDao.getAllUsers();
    return _database!.userDao.deleteUsers(users);
  }
}
