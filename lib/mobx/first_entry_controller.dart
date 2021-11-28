import 'package:mobx/mobx.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/core/tools/Const.dart';

part 'first_entry_controller.g.dart';

class FirstEntryController = _FirstEntryController with _$FirstEntryController;

abstract class _FirstEntryController with Store {
  final _repository = DataRepository();

  @observable
  bool isLoading = false;
  @observable
  bool isLoaded = false;
  @observable
  bool isErrorWhileLoading = false;

  @action
  Future loadUsers() async {
    isLoading = true;
    isErrorWhileLoading = false;
    final result = await _repository.getRandomUsers();
    isLoading = false;
    isLoaded = result.isSuccessful();
    if (isLoaded) _repository.preferences.setBool(Const.IS_FIRST_LAUNCH, false);
    isErrorWhileLoading = !isLoaded;
  }
}
