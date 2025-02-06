import 'dart:convert';

import 'package:custom_exception_handler/core/error/exceptions.dart';
import 'package:custom_exception_handler/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getlastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getlastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString == null) {
      throw const CacheException('No cached data found.');
    }

    try {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } catch (e) {
      throw const FormatException('Cached data is corrupted.');
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    try {
      final jsonData = json.encode(triviaToCache.toJson());

      final success =
          await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonData);

      if (!success) {
        throw const CacheException('Failed to store data in cache.');
      }
    } catch (e) {
      throw const CacheException(
          'An unexpected error occurred while writing to cache.');
    }
  }
}
