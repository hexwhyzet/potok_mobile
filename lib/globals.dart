library void_mobile_app.globals;

import 'package:potok/models/actions_cacher.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/styles/themes.dart';

bool isQA = true;

bool isVisibleInterface = true;

bool isLogged = false;

int homeScreenTabIndex = 1;

late String sessionToken;

late String authToken;

late PictureViewerStorage subscriptionStorage;

late TicketStorage feedStorage;

late TrackerManager trackerManager;

late Cacher cacher;

final darkTheme = DarkTheme();

final lightTheme = LightTheme();

final theme = lightTheme;
