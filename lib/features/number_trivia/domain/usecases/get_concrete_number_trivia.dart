import 'package:equatable/equatable.dart';
import 'package:custom_exception_handler/core/error/failures.dart';
import 'package:custom_exception_handler/core/usecases/usecase.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failures, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
