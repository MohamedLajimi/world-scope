import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:worldscope/core/network/dio_client.dart';
import 'package:worldscope/data/weather/failures/weather_failure.dart';
import 'package:worldscope/data/weather/models/weather_model.dart';

class WeatherService {
  WeatherService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  static const String _openCageBase =
      'https://api.opencagedata.com/geocode/v1/json';
  static const String _openMeteoBase = 'https://api.open-meteo.com/v1/forecast';

  final Dio _dio;

  Future<Either<WeatherFailure, ({double lat, double lng})>> geocodeCity(
    String city,
  ) async {
    final apiKey = dotenv.env['OPENCAGE_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      return left(const MissingApiKeyFailure());
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _openCageBase,
        queryParameters: {
          'q': city,
          'key': apiKey,
          'limit': 1,
          'no_annotations': 1,
        },
      );

      final results = response.data?['results'] as List<dynamic>? ?? const [];
      if (results.isEmpty) {
        return left(const CityNotFoundFailure());
      }

      final geometry = results.first['geometry'] as Map<String, dynamic>?;
      if (geometry == null) {
        return left(const WeatherParsingFailure());
      }

      final lat = (geometry['lat'] as num?)?.toDouble();
      final lng = (geometry['lng'] as num?)?.toDouble();
      if (lat == null || lng == null) {
        return left(const WeatherParsingFailure());
      }

      return right((lat: lat, lng: lng));
    } on DioException catch (error) {
      return left(_mapDioFailure(error));
    } catch (_) {
      return left(const UnknownWeatherFailure());
    }
  }

  Future<Either<WeatherFailure, WeatherModel>> fetchWeather({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _openMeteoBase,
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'current': 'temperature_2m,wind_speed_10m,weather_code',
          'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
          'timezone': 'auto',
          'forecast_days': 7,
        },
      );

      final data = response.data;
      if (data == null) {
        return left(const WeatherParsingFailure());
      }

      return right(WeatherModel.fromJson(data));
    } on DioException catch (error) {
      return left(_mapDioFailure(error));
    } catch (_) {
      return left(const UnknownWeatherFailure());
    }
  }

  Future<Either<WeatherFailure, WeatherModel>> getWeatherForCity(
    String city,
  ) async {
    final normalized = city.trim();
    if (normalized.isEmpty) {
      return left(const CityNotFoundFailure());
    }

    final geocodeResult = await geocodeCity(normalized);
    return geocodeResult.fold(
      left,
      (coords) async {
        return fetchWeather(
          lat: coords.lat,
          lng: coords.lng,
        );
      },
    );
  }

  WeatherFailure _mapDioFailure(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const WeatherNetworkFailure();
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 404) {
      return const CityNotFoundFailure();
    }
    if (statusCode != null && statusCode >= 500) {
      return const WeatherServerFailure();
    }

    return const UnknownWeatherFailure();
  }
}
