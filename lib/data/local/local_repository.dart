import 'package:random_users/data/local/dao/UserDao.dart';
import 'package:random_users/data/local/entity/UserEntity.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/data/network/models/UserResponse.dart';

import 'database.dart';

class LocalRepository {
  static final LocalRepository _instance = LocalRepository._internal();
  late UserDao _userDao;
  AppDatabase? database;

  factory LocalRepository() {
    return _instance;
  }

  Future<void> initDataBase() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  LocalRepository._internal() {
    initDataBase();
  }

  Future<void> saveRemoteUsers(List<UserResponse>? users) async {
    if (database == null) {
      await initDataBase();
    }
    await database!.userDao.insertUsers(users
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
    if (database == null) {
      await initDataBase();
    }
    return database!.userDao.getAllUsers();
  }

  Future<void> updateUser(UserEntity entity) {
    return database!.userDao.updateUser(entity);
  }

  Future<void> insertUser(UserEntity entity) {
    print("insert = $entity");
    return database!.userDao.insertUser(entity);
  }

  Future<int> removeUser(UserEntity entity) {
    return database!.userDao.deleteUsers([entity]);
  }

  Future<int> removeAllUsers() async {
    var users = await database!.userDao.getAllUsers();
    return database!.userDao.deleteUsers(users);
  }
}
