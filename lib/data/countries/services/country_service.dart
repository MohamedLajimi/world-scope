import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:worldscope/core/network/dio_client.dart';
import 'package:worldscope/data/countries/failures/country_failure.dart';
import 'package:worldscope/data/countries/models/country_detail_model.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';

class CountryService {
  CountryService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  Future<Either<CountryFailure, List<CountrySummaryModel>>>
      fetchAllCountries() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '$_baseUrl/all?fields=name,flags,cca2,cca3,capital',
      );

      final data = response.data;
      if (data == null) {
        return left(const ParsingFailure());
      }

      final countries = data
          .map((json) => CountrySummaryModel.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return right(countries);
    } on DioException catch (error) {
      return left(_mapDioFailure(error));
    } catch (_) {
      return left(const UnknownFailure());
    }
  }

  Either<CountryFailure, List<CountrySummaryModel>> searchCountries({
    required List<CountrySummaryModel> countries,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return right(countries);
    }

    final filtered = countries
        .where((country) => country.name.toLowerCase().contains(normalizedQuery))
        .toList();

    return right(filtered);
  }

  Future<Either<CountryFailure, CountryDetailModel>> fetchCountryDetail(
    String code,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        '$_baseUrl/alpha/$code?fields=name,capital,currencies,languages,population,flags',
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return left(const ParsingFailure());
      }

      return right(CountryDetailModel.fromJson(data));
    } on DioException catch (error) {
      return left(_mapDioFailure(error));
    } catch (_) {
      return left(const UnknownFailure());
    }
  }

  CountryFailure _mapDioFailure(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      return const NotFoundFailure();
    }
    if (statusCode != null && statusCode >= 500) {
      return const ServerFailure();
    }

    return const UnknownFailure();
  }
}
