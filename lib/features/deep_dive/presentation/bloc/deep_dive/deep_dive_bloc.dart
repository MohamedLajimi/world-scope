import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldscope/data/countries/models/country_detail_model.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';
import 'package:worldscope/data/countries/services/country_service.dart';
import 'package:worldscope/data/news/models/news_article_model.dart';
import 'package:worldscope/data/news/services/news_service.dart';
import 'package:worldscope/data/weather/models/weather_model.dart';
import 'package:worldscope/data/weather/services/weather_service.dart';

part 'deep_dive_event.dart';
part 'deep_dive_state.dart';

class DeepDiveBloc extends Bloc<DeepDiveEvent, DeepDiveState> {
  DeepDiveBloc({
    required CountryService countryService,
    required WeatherService weatherService,
    required NewsService newsService,
  }) : _countryService = countryService,
       _weatherService = weatherService,
       _newsService = newsService,
       super(const DeepDiveLoading()) {
    on<DeepDiveLoadRequested>(_onLoadRequested);
  }

  final CountryService _countryService;
  final WeatherService _weatherService;
  final NewsService _newsService;

  Future<void> _onLoadRequested(
    DeepDiveLoadRequested event,
    Emitter<DeepDiveState> emit,
  ) async {
    emit(const DeepDiveLoading());

    CountryDetailModel? detail;
    WeatherModel? weather;
    List<NewsArticleModel> news = const [];

    String? countryError;
    String? weatherError;
    String? newsError;

    await Future.wait<void>([
      _countryService
          .fetchCountryDetail(event.country.cca3)
          .then(
            (result) => result.fold(
              (failure) => countryError = failure.message,
              (data) => detail = data,
            ),
          ),
      _loadWeatherForCountry(event.country).then((result) {
        weatherError = result.$1;
        weather = result.$2;
      }),
      _newsService
          .fetchTopHeadlines(event.country.cca2)
          .then(
            (result) => result.fold(
              (failure) => newsError = failure.message,
              (articles) => news = articles,
            ),
          ),
    ], eagerError: false);

    final allFailed =
        detail == null && weather == null && news.isEmpty && newsError != null;

    if (allFailed) {
      emit(
        DeepDiveFailure(
          message: 'Unable to load country data, weather, and news right now.',
        ),
      );
      return;
    }

    emit(
      DeepDiveSuccess(
        country: event.country,
        detail: detail,
        weather: weather,
        news: news,
        countryError: countryError,
        weatherError: weatherError,
        newsError: newsError,
      ),
    );
  }

  Future<(String?, WeatherModel?)> _loadWeatherForCountry(
    CountrySummaryModel country,
  ) async {
    final city = country.capital.trim().isEmpty
        ? country.name
        : country.capital;

    final weatherResult = await _weatherService.getWeatherForCity(city);
    return weatherResult.fold(
      (failure) => (failure.message, null),
      (weather) => (null, weather),
    );
  }
}
