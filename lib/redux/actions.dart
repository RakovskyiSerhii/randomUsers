import 'package:random_users/core/data/models/UserModel.dart';

abstract class AppAction {}

class LoadListAction {}
class UserLoadedAction {

}
class UsersLoadingError {

}
class UsersRetrievedAction {
  final List<UserModel> users;

  UsersRetrievedAction(this.users);
}
class GetListFromDBAction {}
class RefreshUsersAction {}
class RemoveUserAction {
  final UserModel userModel;

  RemoveUserAction(this.userModel);
}
class SaveUserAction {
  final UserModel userModel;

  SaveUserAction(this.userModel);
}
class GetIsFirstLaunch{}
class IsFirstLaunch{
  final bool isFirstLaunch;

  IsFirstLaunch(this.isFirstLaunch);
}
