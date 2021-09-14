

/// Error response data.
class ErrorResponse {
  final int code;

  final String message;

  final Map<String, List<String>> errors;

  ErrorResponse(this.code, this.message, this.errors);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      json['code'], 
      json['message'], 
      parseErrors(json)
      );
  }

  static Map<String, List<String>> parseErrors(Map<String, dynamic> json) {
    var result = Map<String, List<String>>();

    if (json.containsKey('errors')) {
      json['errors'].forEach((key, value) {
        result[key] = List<String>.from(value);
      });
    }

    return result;
  }
}