import 'package:floor/floor.dart';
import 'package:random_users/data/local/entity/UserEntity.dart';

@dao
abstract class UserDao {
  @insert
  Future<void> insertUsers(List<UserEntity> users);

  @insert
  Future<void> insertUser(UserEntity user);

  @Query('SELECT * FROM UserEntity')
  Future<List<UserEntity>> getAllUsers();

  @update
  Future<void> updateUser(UserEntity entity);

  @delete
  Future<int> deleteUsers(List<UserEntity> list);
}
