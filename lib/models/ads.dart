import 'package:potok/models/response.dart';

class Ads {
  Ads();

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads();
  }

  factory Ads.formResponse(Response request) {
    return Ads.fromJson(request.jsonContent);
  }
}
