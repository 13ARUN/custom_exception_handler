
import 'package:custom_exception_handler/core/error/failures.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fpdart/fpdart.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
  Future<Either<Failures, NumberTrivia>> getCachedTrivia();
}
