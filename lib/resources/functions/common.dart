import 'package:url_launcher/url_launcher.dart';

String shortenNum(int num) {
  if (num >= 1e9) {
    return "${num ~/ 1e9},${num ~/ 1e8 % 10}B";
  } else if (num >= 1e6) {
    return "${num ~/ 1e6},${num ~/ 1e5 % 10}M";
  } else if (num >= 1e4) {
    return "${num ~/ 1e3},${num ~/ 1e2 % 10}K";
  } else {
    return "$num";
  }
}

String shortenTimeDelta(int sec) {
  int d = sec;
  if (d < 60) {
    return "${d}s";
  }
  d ~/= 60;
  if (d < 60) {
    return "${d}m";
  }
  d ~/= 60;
  if (d < 24) {
    return "${d}h";
  }
  d ~/= 24;
  if (d < 30) {
    return "${d}d";
  }
  d ~/= 30;
  if (d < 12) {
    return "${d}m";
  }
  d ~/= 12;
  return "${d}y";
}

openUniversalUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false, forceWebView: false);
  } else {
    throw 'Could not launch $url';
  }
}
