class Response {
  int? status;
  String? message;
  dynamic data;

  Response({this.status, this.message, this.data});
}

class Validate {
  bool isValid;
  String message;

  Validate({required this.isValid, required this.message});
}