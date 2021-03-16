import 'package:potok/config.dart' as config;
import 'package:potok/models/objects.dart';
import 'package:potok/models/response.dart';

const int LAST_POSITION = 0;
const int LOAD_MORE_NUMBER = 5;
const bool IS_LOADING = false;
const bool HAS_MORE = true;
const int DELTA_TO_RELOAD = 3;
const bool OFFSET = false;

class Storage {
  final String sourceUrl;
  int lastPosition;
  final int loadMoreNumber;
  bool isLoading;
  bool hasMore;
  final int deltaToReload;
  final bool offset;

  List<dynamic> objects = [];

  Storage({
    this.sourceUrl,
    this.lastPosition = LAST_POSITION,
    this.loadMoreNumber = LOAD_MORE_NUMBER,
    this.isLoading = IS_LOADING,
    this.hasMore = HAS_MORE,
    this.deltaToReload = DELTA_TO_RELOAD,
    this.offset = OFFSET,
  });

  bool isEmpty() {
    return objects.length == 0;
  }

  int size() {
    return objects.length;
  }

  String constructUrl() {
    var url = sourceUrl + "/$loadMoreNumber";
    if (offset) {
      url += "/${objects.length}";
    }
    return url;
  }

  Future<void> addObjects() async {
    isLoading = true;
    List<dynamic> fetchedObjects = await fetchObjects(constructUrl());
    objects.addAll(fetchedObjects);
    hasMore = fetchedObjects.length == this.loadMoreNumber;
    isLoading = false;
  }

  dynamic getObject(position) {
    if (position < objects.length) {
      return objects[position];
    } else {
      return null;
    }
  }

  void deleteObject(position) {
    if (position < objects.length) {
      objects.removeAt(position);
    }
  }

  Future<void> rebuild() async {
    lastPosition = 0;
    this.objects = [];
    await addObjects();
  }
}

class PictureViewerStorage extends Storage {
  PictureViewerStorage({
    sourceUrl,
    lastPosition = LAST_POSITION,
    loadMoreNumber = LOAD_MORE_NUMBER,
    isLoading = IS_LOADING,
    hasMore = HAS_MORE,
    deltaToReload = DELTA_TO_RELOAD,
    offset = OFFSET,
  }) : super(
          sourceUrl: sourceUrl,
          lastPosition: lastPosition,
          loadMoreNumber: loadMoreNumber,
          isLoading: isLoading,
          hasMore: hasMore,
          deltaToReload: deltaToReload,
          offset: offset,
        );

  factory PictureViewerStorage.fromStorage(Storage storage) {
    PictureViewerStorage pictureViewerStorage = PictureViewerStorage(
      sourceUrl: storage.sourceUrl,
      lastPosition: storage.lastPosition,
      loadMoreNumber: storage.loadMoreNumber,
      isLoading: storage.isLoading,
      hasMore: storage.hasMore,
      deltaToReload: storage.deltaToReload,
      offset: storage.offset,
    );
    pictureViewerStorage.objects = [...storage.objects];
    return pictureViewerStorage;
  }

  Future<bool> check() async {
    if (!isLoading && (objects.length - lastPosition) <= deltaToReload) {
      await addObjects();
      return true;
    }
    return false;
  }

  void markAsSeen(int position) {
    String url = "${config.markAsSeenUrl}/${getObject(position).id}";
    getRequest(url);
  }

  void updateLastPosition(int newLastPosition) {
    lastPosition = newLastPosition;
  }
}

class TicketStorage extends Storage {
  TicketStorage({
    sourceUrl,
    lastPosition = LAST_POSITION,
    loadMoreNumber = LOAD_MORE_NUMBER,
    isLoading = IS_LOADING,
    hasMore = HAS_MORE,
    deltaToReload = DELTA_TO_RELOAD,
    offset = OFFSET,
  }) : super(
          sourceUrl: sourceUrl,
          lastPosition: lastPosition,
          loadMoreNumber: loadMoreNumber,
          isLoading: isLoading,
          hasMore: hasMore,
          deltaToReload: deltaToReload,
          offset: offset,
        );

  factory TicketStorage.fromStorage(Storage storage) {
    TicketStorage ticketStorage = TicketStorage(
      sourceUrl: storage.sourceUrl,
      lastPosition: storage.lastPosition,
      loadMoreNumber: storage.loadMoreNumber,
      isLoading: storage.isLoading,
      hasMore: storage.hasMore,
      deltaToReload: storage.deltaToReload,
      offset: storage.offset,
    );
    ticketStorage.objects = [...storage.objects];
    return ticketStorage;
  }

  Future<bool> check() async {
    if (!isLoading && (objects.length - lastPosition) <= deltaToReload) {
      await addObjects();
      return true;
    }
    return false;
  }

  void markAsSeen(int position) {
    String url = "${config.markAsSeenUrl}/${getObject(position).picture.id}";
    getRequest(url);
  }

  void updateLastPosition(int newLastPosition) {
    lastPosition = newLastPosition;
  }
}
