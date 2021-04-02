import 'dart:async';

import 'package:random_users/core/base_block.dart';
import 'package:random_users/data/network/models/base_response.dart';
import 'package:random_users/data/repository.dart';
import 'package:random_users/tools/Const.dart';

class FirstEntryBlock extends BaseBloc {
  DataRepository _repository = DataRepository();


  FirstEntryBlock() {
    showProgress();
  }

  StreamController<BaseResponse<dynamic>?> _errorController = StreamController.broadcast();

  StreamSink get _errorSink => _errorController.sink;
  Stream<BaseResponse<dynamic>?> get errorStream => _errorController.stream;

  Future<BaseResponse> getUserList() async {
    showProgress();
    var response = await _repository.getRandomUsers();
    if (!response.isSuccessful()) {
      _errorSink.add(response);
    }
    hideProgress();
    // return BaseResponse(code: Const.NETWORK_CONNECTION);
    return response;
  }

  void clearError() {
    _errorSink.add(null);
  }


  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }
}