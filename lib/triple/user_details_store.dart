import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/triple/triple_state.dart';

class UserDetailsStore extends StreamStore<Exception, UserDetailsState> {
  UserDetailsStore(UserModel? userModel)
      : super(userModel == null
            ? UserDetailsState.initial()
            : UserDetailsState.fromData(userModel));

  final _repository = DataRepository();

  void initUser(UserModel userModel) {
    update(UserDetailsState.fromData(userModel));
  }

  Future saveUser(String name, String surname, String email) async {
    if (state.value == null) {
      await _repository.insertUser(
          UserModel(firstName: name, lastName: surname, email: email));
    } else {
      final newUser = state.value!
        ..firstName = name
        ..lastName = surname
        ..email = email;
      await _repository.updateUser(newUser);
    }
  }

  Future removeUser(UserModel userModel) {
    return _repository.removeUser(userModel);
  }
}

class UserDetailsState extends TripleState<UserModel> {
  UserDetailsState.fromData(UserModel value) : super.fromData(value);

  UserDetailsState.initial() : super.initial();
}
