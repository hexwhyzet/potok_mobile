abstract class ComplexListRepository<E> {
  Future<List<E>> fetchItems(List<E> oldList);
}

class ComplexListRepositoryFromUrl<E> {
  ComplexListRepositoryFromUrl({
    required this.sourceUrl,
  });

  final String sourceUrl;
  final int pageNumber = 1;

  String constructUrl(int offset) {
    var url = sourceUrl;
    if (enableOffset) url += "/$offset";
    return url;
  }

  Future<List<E>> fetchItems(List<E> oldList) {
    String url = constructUrl(offset);
    E.fromJson()
  }
}