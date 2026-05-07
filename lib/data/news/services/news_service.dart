import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:worldscope/core/network/dio_client.dart';
import 'package:worldscope/data/news/failures/news_failure.dart';
import 'package:worldscope/data/news/models/news_article_model.dart';

class NewsService {
  NewsService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  final Dio _dio;

  Future<Either<NewsFailure, List<NewsArticleModel>>> fetchTopHeadlines(
    String countryCode2,
  ) async {
    final apiKey = dotenv.env['NEWS_API_KEY']?.trim() ?? '';
    if (apiKey.isEmpty) {
      return left(const MissingNewsApiKeyFailure());
    }

    final code = countryCode2.trim().toLowerCase();
    if (code.isEmpty) {
      return right(const []);
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _baseUrl,
        queryParameters: {
          'country': code,
          'pageSize': 5,
          'apiKey': apiKey,
        },
      );

      final data = response.data;
      if (data == null) {
        return left(const NewsParsingFailure());
      }

      final status = data['status'] as String?;
      if (status != 'ok') {
        final message = data['message'] as String?;
        return left(
          message == null || message.isEmpty
              ? const UnknownNewsFailure()
              : UnknownNewsFailureWithMessage(message),
        );
      }

      final rawArticles = data['articles'] as List<dynamic>? ?? const [];
      final articles = rawArticles
          .map((item) => NewsArticleModel.fromJson(item as Map<String, dynamic>))
          .where((article) => article.url.isNotEmpty)
          .toList();

      return right(articles);
    } on DioException catch (error) {
      return left(_mapDioFailure(error));
    } catch (_) {
      return left(const UnknownNewsFailure());
    }
  }

  NewsFailure _mapDioFailure(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NewsNetworkFailure();
    }

    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return const NewsServerFailure();
    }

    return const UnknownNewsFailure();
  }
}
