
import 'package:custom_exception_handler/core/utils/failure_mappers.dart';
import 'package:custom_exception_handler/core/error/failures.dart';
import 'package:custom_exception_handler/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:custom_exception_handler/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:custom_exception_handler/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:custom_exception_handler/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:custom_exception_handler/services/network/network_info.dart';
import 'package:fpdart/fpdart.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

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

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  @override
  Future<Either<Failures, NumberTrivia>> getCachedTrivia() async {
    try {
      final cachedTrivia = await localDataSource.getlastNumberTrivia();
      return Right(cachedTrivia);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
