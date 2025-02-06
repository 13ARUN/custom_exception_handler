
import 'package:custom_exception_handler/core/error/failures.dart';
import 'package:custom_exception_handler/core/usecases/usecase.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});
  @override
  Future<Either<Failures, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }
}
