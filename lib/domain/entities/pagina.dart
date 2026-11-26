class Pagina<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const Pagina({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}
