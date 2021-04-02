import 'package:floor/floor.dart';
import 'package:random_users/data/local/dao/UserDao.dart';
import 'package:random_users/data/local/entity/UserEntity.dart';
// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [UserEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
