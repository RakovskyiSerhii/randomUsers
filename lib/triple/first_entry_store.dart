import 'package:flutter_triple/flutter_triple.dart';
import 'package:random_users/core/data/repository.dart';
import 'package:random_users/core/tools/Const.dart';
import 'package:random_users/triple/triple_state.dart';

class FirstEntryStore extends StreamStore<LoadingState, LoadingState> {
  final _repository = DataRepository();

  FirstEntryStore() : super(LoadingState.initial());

  Future loadUsers() async {
    setLoading(true);
    final result = await _repository.getRandomUsers();
    setLoading(false);

    final isLoaded = result.isSuccessful();
    if (isLoaded) {
      _repository.preferences.setBool(Const.IS_FIRST_LAUNCH, false);
      update(LoadingState.complete());
    } else {
      setError(LoadingState.error());
    }
  }
}

class LoadingState extends TripleState<bool> {
  LoadingState.initial() : super.initial();

  LoadingState.fromData(bool value) : super.fromData(value);

  factory LoadingState.complete() => LoadingState.fromData(true);

  factory LoadingState.error() => LoadingState.fromData(false);
}
