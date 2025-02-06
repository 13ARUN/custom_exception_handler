import '../error/exceptions.dart';
import '../error/failures.dart';

class FailureMapper {
  static Failures mapExceptionToFailure(Object e) {
    if (e is ServerException) {
      return ServerFailure(e.message);
    } else if (e is TimeoutException) {
      return TimeoutFailure(e.message);
    } else if (e is UnauthorizedException) {
      return UnauthorizedFailure(e.message);
    } else if (e is CacheException) {
      return CacheFailure(e.message);
    } else if (e is FormatException) {
      return FormatFailure(e.message);
    } else {
      return UnknownFailure('Unexpected API error occurred');
    }
    
  }
}
