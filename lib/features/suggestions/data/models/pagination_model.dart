import 'package:smart_assistant/features/suggestions/domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int limit,
    required bool hasNext,
    required bool hasPrevious,
  }) : super(
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          limit: limit,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
        );

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      totalItems: json['total_items'] as int,
      limit: json['limit'] as int,
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );
  }
}
