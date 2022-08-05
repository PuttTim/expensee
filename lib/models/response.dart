enum Status {
  success,
  error,
}

class Response {
  Status status;
  String? message;

  Response({
    required this.status,
    this.message,
  });
}
