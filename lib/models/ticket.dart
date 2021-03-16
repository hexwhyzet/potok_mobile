import 'package:potok/config.dart' as config;
import 'package:potok/models/picture.dart';
import 'package:potok/models/profile.dart';
import 'package:potok/models/response.dart';
import 'dart:convert';

class Ticket {
  final int id;
  final String token;

  final Picture picture;
  final Profile profile;

  bool isIssued = true;
  bool isReturned = false;
  bool isViewed = false;
  bool isLiked = false;
  bool isShared = false;

  Ticket({
    this.id,
    this.token,
    this.picture,
    this.profile,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json["id"],
      token: json["token"],
      profile: Profile.fromJson(json["profile"]),
      picture: Picture.fromJson(json["picture"]),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id": this.id,
      "token": this.token,
      "is_issued": this.isIssued,
      "is_returned": this.isReturned,
      "is_viewed": this.isViewed,
      "is_liked": this.isLiked,
      "is_shared": this.isShared,
    };
  }
}

// Map<String, dynamic> generateJson(Ticket ticket) {
//   Map<String, dynamic> returnJson = {
//     "id": json.encode(ticket.id),
//     "token": json.encode(ticket.token),
//     "isIssued": json.encode(ticket.isIssued),
//     "isReturned": json.encode(ticket.isReturned),
//     "isViewed": json.encode(ticket.isViewed),
//     "isLiked": json.encode(ticket.isLiked),
//     "isShared": json.encode(ticket.isShared),
//   };
//   return jsonEncode(returnJson);
// }

Future<void> returnTickets(tickets) async {
  // List<Map<String, dynamic>> jsonReturn = [];
  // for (var ticket in tickets) {
  //   jsonReturn.add(generateJson(ticket));
  // }
  await postRequest(config.returnTickets, {"content": jsonEncode(tickets)});
}
