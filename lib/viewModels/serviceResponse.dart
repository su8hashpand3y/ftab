class ServerResponse {
  final dynamic data;
  final String status;
  final String message;

  ServerResponse({this.status, this.message, this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }

  factory ServerResponse.fromHttpCode(String statusCode) {
    return ServerResponse(
      status: 'bad',
      message: statusCode,
      data: null,
    );
  }

  factory ServerResponse.fromError(String error) {
    print('Somthing Didnt worked $error' );
    return ServerResponse(
      status: 'bad',
      message: "Something Went Wrong",
      data: null,
    );
  }
}