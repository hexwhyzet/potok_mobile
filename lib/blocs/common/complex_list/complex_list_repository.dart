abstract class ComplexListRepository<E> {
  Future<List<E>> fetchItems(List<E> oldList);
}

class ComplexListRepositoryFromUrl<E> {
  ComplexListRepositoryFromUrl({
    required this.sourceUrl,
    this.loadMoreNumber = 5,
    this.enableOffset = true,
  });

  final String sourceUrl;
  final int loadMoreNumber;
  final bool enableOffset;

  String constructUrl(int offset) {
    var url = sourceUrl + "/${this.loadMoreNumber}";
    if (enableOffset) url += "/$offset";
    return url;
  }

  // Future<List<E>> fetchItems(List<E> oldList) {
  //   final int offset = oldList.length;
  //   String url = constructUrl(offset);
  //   E.fromJson()
  // }
}