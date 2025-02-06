# Exception Handling in Number Trivia Project

## Overview
This document provides a detailed explanation of the exception handling mechanism implemented in the Number Trivia project. Exception handling is crucial for ensuring the robustness and reliability of the application. This project follows a structured approach to manage exceptions and failures systematically, improving error reporting and debugging.

---

## Exception Handling Mechanism
The exception handling in this project is divided into two main components:

1. **Custom Exception Classes**
2. **Failure Mapping and Handling**

### 1. Custom Exception Classes
Custom exceptions are defined to represent different error scenarios that may arise during API calls and data retrieval.

#### Abstract Base Exception
```dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}
```
This abstract class serves as the base for all exceptions in the project.

#### Specific Exceptions
- `ServerException` - Represents server-related errors.
- `CacheException` - Occurs when there is an issue accessing cached data.
- `TimeoutException` - Indicates a request timeout.
- `UnauthorizedException` - Thrown when authentication fails.
- `UnknownException` - Represents unclassified errors.

```dart
class ServerException extends AppException {
  const ServerException([super.message = "Server error occurred"]);
}

class CacheException extends AppException {
  const CacheException([super.message = "Cache error occurred"]);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = "Request timeout"]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = "Unauthorized request"]);
}

class UnknownException extends AppException {
  const UnknownException([super.message = "Unknown error occurred"]);
}
```

---

### 2. Failure Mapping and Handling
To decouple exception handling from application logic, the project introduces a **Failure** abstraction.

#### Failure Classes
Each exception type has a corresponding failure class that represents the failure state:

```dart
abstract class Failures {
  final String message;
  const Failures(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failures {
  ServerFailure(super.message);
}

class CacheFailure extends Failures {
  CacheFailure(super.message);
}

class TimeoutFailure extends Failures {
  TimeoutFailure(super.message);
}

class UnauthorizedFailure extends Failures {
  UnauthorizedFailure(super.message);
}

class FormatFailure extends Failures {
  FormatFailure(super.message);
}

class UnknownFailure extends Failures {
  UnknownFailure(super.message);
}
```

#### Failure Mapper
The `FailureMapper` class maps exceptions to their corresponding failures:

```dart
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
```

---

## Exception Handling in API Calls
The `NumberTriviaRemoteDataSourceImpl` class demonstrates exception handling in API calls:

```dart
Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException();
    } else if (response.statusCode == 408) {
      throw const TimeoutException();
    } else {
      throw const ServerException();
    }
  } catch (e) {
    throw FailureMapper.mapExceptionToFailure(e);
  }
}
```
This method:
- Makes an API request.
- Throws custom exceptions based on HTTP status codes.
- Ensures error handling is centralized and easily maintainable.

---

## Exception Handling in Repository
The `NumberTriviaRepositoryImpl` class handles exceptions and maps them to failures:

```dart
Future<Either<Failures, NumberTrivia>> _getTrivia(
  Future<NumberTriviaModel> Function() getConcreteOrRandom,
) async {
  if (await networkInfo.isConnected) {
    try {
      final remoteTrivia = await getConcreteOrRandom();
      localDataSource.cacheNumberTrivia(remoteTrivia);
      return Right(remoteTrivia);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  } else {
    try {
      final localTrivia = await localDataSource.getlastNumberTrivia();
      return Right(localTrivia);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
```
This method:
- Checks network availability.
- Handles exceptions from both the remote and local data sources.
- Uses `FailureMapper` to return user-friendly failure messages.

---

## Exception Handling in State Management
The `TriviaNotifier` class manages state using Riverpod and handles exceptions gracefully:

```dart
Future<void> getConcrete(int num) async {
  state = const AsyncValue.loading();
  final result = await _getConcrete(Params(number: num));
  state = result.fold(
    (failure) {
      return AsyncValue.error(failure, StackTrace.current);
    },
    (trivia) => AsyncValue.data(trivia),
  );
}
```
This method:
- Updates the state before making a request.
- Uses `fold()` to handle failures and successes separately.
- Ensures UI components receive appropriate error messages.

---

## Conclusion
This structured exception handling approach:
- Clearly differentiates between different failure types.
- Centralizes error handling for easy maintainability.
- Enhances debugging by providing meaningful error messages.
- Improves user experience by handling API failures gracefully.

By following this methodology, the project ensures robustness and a better error-handling experience for both developers and users.

