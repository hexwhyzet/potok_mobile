class Cacher {
  Map<int, bool> likeCache = {};
  Map<int, bool> subCache = {};

  bool checkLike(int id, bool val) {
    if (likeCache.containsKey(id)) {
      return likeCache[id];
    } else {
      return val;
    }
  }

  bool checkSub(int id, bool val) {
    if (subCache.containsKey(id)) {
      return subCache[id];
    } else {
      return val;
    }
  }

  bool updateLike(int id, bool val) {
    likeCache[id] = val;
    return val;
  }

  bool updateSub(int id, bool val) {
    subCache[id] = val;
    return val;
  }
}
