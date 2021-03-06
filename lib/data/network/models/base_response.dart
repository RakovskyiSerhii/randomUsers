class BaseResponse<T> {
  final int? code;
  String? title;
  String? message;
  final T? data;

  BaseResponse({this.code, this.title, this.message, this.data});

  bool isSuccessful() {
    return code != null &&
        (code == 200 || code == 201 || code == 202 || code == 204);
  }

  factory BaseResponse.fromJson(int httpCode, Map<String, dynamic> json,
      T Function(Map<String, dynamic>) dataConverter) {
    if (json == null) {
      return BaseResponse(code: httpCode);
    } else {
      final data = json;

      return BaseResponse(
          code: httpCode,
          title: json['title'] as String,
          message: json['message'] as String,
          data: data == null
              ? null
              : dataConverter((Map<String, dynamic>.from(data))));
    }
  }

  factory BaseResponse.fromErrorJson(Map<String, dynamic> json) {
    return BaseResponse(
        code: json['status'],
        title: json['error'],
        message: json['message']);
  }

  @override
  String toString() {
    return 'BaseResponse{code: $code, title: $title, message: $message, data: $data}';
  }
}
