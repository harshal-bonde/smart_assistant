import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/common/network/failures.dart';
import 'package:smart_assistant/common/network/exceptions.dart';

void main() {
  group('Failures', () {
    test('ServerFailure has default message', () {
      const failure = ServerFailure();
      expect(failure.message, 'Server error occurred');
    });

    test('ServerFailure accepts custom message', () {
      const failure = ServerFailure('Custom server error');
      expect(failure.message, 'Custom server error');
    });

    test('CacheFailure has default message', () {
      const failure = CacheFailure();
      expect(failure.message, 'Cache error occurred');
    });

    test('NetworkFailure has default message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'No internet connection');
    });
  });

  group('Exceptions', () {
    test('ServerException has default message', () {
      const exception = ServerException();
      expect(exception.message, 'Server error occurred');
    });

    test('ServerException accepts custom message', () {
      const exception = ServerException('API timeout');
      expect(exception.message, 'API timeout');
    });

    test('CacheException has default message', () {
      const exception = CacheException();
      expect(exception.message, 'Cache error occurred');
    });

    test('ServerException implements Exception', () {
      const exception = ServerException();
      expect(exception, isA<Exception>());
    });
  });
}
