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
      message: '$statusCode :Oops, Somthing Went Wrong :(',
      data: null,
    );
  }

  factory ServerResponse.fromError() {
    return ServerResponse(
      status: 'bad',
      message: "Something went wrong,Check internet and try again",
      data: null,
    );
  }

  factory ServerResponse.noInternet() {
    return ServerResponse(
      status: 'no Internet',
      message: "Something went wrong,Check internet and try again",
      data: null,
    );
  }

   factory ServerResponse.authError() {
    return ServerResponse(
      status: 'bad',
      message: "Session Expired ,Please Close and Restart App",
      data: null,
    );
  }
}
