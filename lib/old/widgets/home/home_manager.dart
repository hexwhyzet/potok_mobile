import 'package:potok/models/storage.dart';

class HomeManager {
  PictureViewerStorage subscriptionStorage;
  PictureViewerStorage feedStorage;

  HomeManager(subscriptionUrl, feedUrl) {
    subscriptionStorage = PictureViewerStorage(sourceUrl: subscriptionUrl);
    feedStorage = PictureViewerStorage(sourceUrl: feedUrl);
  }
}
