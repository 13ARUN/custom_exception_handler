
import 'package:equatable/equatable.dart';
import 'package:custom_exception_handler/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failures, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
