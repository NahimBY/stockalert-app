class PaginaResponse {
  final List<dynamic> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginaResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginaResponse.fromJson(Map<String, dynamic> json) => PaginaResponse(
        data: (json['data'] as List<dynamic>?) ?? const [],
        page: json['page'] ?? 1,
        limit: json['limit'] ?? 20,
        total: json['total'] ?? 0,
        totalPages: json['totalPages'] ?? 1,
      );
}
