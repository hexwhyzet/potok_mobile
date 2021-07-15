import 'package:potok/models/storage.dart';

class HomeManager {
  late PictureViewerStorage subscriptionStorage;
  late PictureViewerStorage feedStorage;

  HomeManager(subscriptionUrl, feedUrl) {
    subscriptionStorage = PictureViewerStorage(sourceUrl: subscriptionUrl);
    feedStorage = PictureViewerStorage(sourceUrl: feedUrl);
  }
}
