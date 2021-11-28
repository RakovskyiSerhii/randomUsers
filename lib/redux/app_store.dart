import 'package:random_users/core/data/local/local_repository.dart';
import 'package:random_users/core/data/models/UserModel.dart';
import 'package:random_users/core/data/network/remote_repository.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/core/tools/Const.dart';
import 'package:random_users/redux/actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_reducer.dart';
import 'app_state.dart';
import 'package:redux/redux.dart';

Future<Store<AppState>> createReduxStore() async {
  final localRepository = LocalRepository();
  await localRepository.initDataBase();
  final repository = DataRepository();
  final sharedPreferences = await SharedPreferences.getInstance();
  DataRepository.initialize(
      localRepository, RemoteRepository(), sharedPreferences);

  return Store<AppState>(
    appStateReducers,
    initialState: AppState.empty(),
    middleware: [
      RepositoryMiddleware(repository, sharedPreferences),
    ],
  );
}

class RepositoryMiddleware extends MiddlewareClass<AppState> {
  final DataRepository _repository;
  final SharedPreferences _sharedPreferences;

  RepositoryMiddleware(this._repository, this._sharedPreferences);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is LoadListAction) {
      final results = await _repository.getRandomUsers();
      if (results.isSuccessful()) {
        _sharedPreferences.setBool(Const.IS_FIRST_LAUNCH, false);
        store.dispatch(UserLoadedAction());
      } else {
        store.dispatch(UsersLoadingError());
      }
    } else if (action is GetListFromDBAction) {
      _getUsersFromDB(store);
    } else if (action is RemoveUserAction) {
      await _repository.removeUser(action.userModel);
      _getUsersFromDB(store);
    } else if (action is RefreshUsersAction) {
      await _repository.refreshUsers();
      _getUsersFromDB(store);
    } else if (action is SaveUserAction) {
      await _saveUser(action.userModel);
    }else if (action is GetIsFirstLaunch) {
      store.dispatch(
          IsFirstLaunch(_repository.preferences.getBool(Const.IS_FIRST_LAUNCH) ?? true));
    }
    next(action);
  }

  Future _saveUser(UserModel model) async {
    if (model.id == null) {
      _repository.insertUser(model);
    } else {
      _repository.updateUser(model);
    }
  }

  void _getUsersFromDB(Store<AppState> store) async {
    final result = await _repository.getUsers();
    store.dispatch(UsersRetrievedAction(result));
  }
}
