library void_mobile_app.globals;

import 'package:potok/models/actions_cacher.dart';
import 'package:potok/models/storage.dart';
import 'package:potok/models/tracker.dart';
import 'package:potok/styles/themes.dart';

bool isVisibleInterface = true;

bool isLogged = false;

int homeScreenTabIndex = 0;

String sessionToken;

String authToken;

PictureViewerStorage subscriptionStorage;

TicketStorage feedStorage;

TrackerManager trackerManager;

Cacher cacher;

final darkTheme = DarkTheme();

final lightTheme = LightTheme();

final theme = lightTheme;
