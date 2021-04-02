import 'package:random_users/core/base_block.dart';
import 'package:random_users/data/models/UserModel.dart';
import 'package:random_users/data/repository.dart';

class UserDetailsBlock extends BaseBloc {
  DataRepository _repository = DataRepository();

  Future<void> saveUser(UserModel model) {
    if (model.id == null) {
      return _repository.insertUser(model);
    } else
      return _repository.updateUser(model);
  }

  Future<int> removeUser(UserModel model) {
    return _repository.removeUser(model);
  }
}
