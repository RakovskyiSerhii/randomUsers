import 'package:mobx/mobx.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';

part 'user_details_controller.g.dart';

class UserDetailsController = _UserDetailsController with _$UserDetailsController;

abstract class _UserDetailsController with Store {
  final _repository = DataRepository();

  @action
  Future saveUser(String name, String surname, String email, UserModel? user) async {
    if (user == null) {
      await _repository.insertUser(
          UserModel(firstName: name, lastName: surname, email: email));
    } else {
      final newUser = user
        ..firstName = name
        ..lastName = surname
        ..email = email;
      await _repository.updateUser(newUser);
    }
  }

  @action
  Future removeUser(UserModel userModel) {
    return _repository.removeUser(userModel);
  }
}
