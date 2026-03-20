class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;
  final bool hasNext;
  final bool hasPrevious;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
    required this.hasNext,
    required this.hasPrevious,
  });
}
