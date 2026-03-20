import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/domain/data_class/pagination.dart';

void main() {
  group('Pagination', () {
    test('stores all fields correctly', () {
      const pagination = Pagination(
        currentPage: 2,
        totalPages: 5,
        totalItems: 50,
        limit: 10,
        hasNext: true,
        hasPrevious: true,
      );
      expect(pagination.currentPage, 2);
      expect(pagination.totalPages, 5);
      expect(pagination.totalItems, 50);
      expect(pagination.limit, 10);
      expect(pagination.hasNext, isTrue);
      expect(pagination.hasPrevious, isTrue);
    });

    test('first page has no previous', () {
      const pagination = Pagination(
        currentPage: 1,
        totalPages: 5,
        totalItems: 50,
        limit: 10,
        hasNext: true,
        hasPrevious: false,
      );
      expect(pagination.hasPrevious, isFalse);
      expect(pagination.hasNext, isTrue);
    });

    test('last page has no next', () {
      const pagination = Pagination(
        currentPage: 5,
        totalPages: 5,
        totalItems: 50,
        limit: 10,
        hasNext: false,
        hasPrevious: true,
      );
      expect(pagination.hasNext, isFalse);
      expect(pagination.hasPrevious, isTrue);
    });
  });
}
