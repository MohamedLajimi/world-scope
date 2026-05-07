part of 'deep_dive_bloc.dart';

sealed class DeepDiveState extends Equatable {
  const DeepDiveState();

  @override
  List<Object?> get props => [];
}

class DeepDiveLoading extends DeepDiveState {
  const DeepDiveLoading();
}

class DeepDiveSuccess extends DeepDiveState {
  const DeepDiveSuccess({
    required this.country,
    required this.detail,
    required this.weather,
    required this.news,
    required this.countryError,
    required this.weatherError,
    required this.newsError,
  });

  final CountrySummaryModel country;
  final CountryDetailModel? detail;
  final WeatherModel? weather;
  final List<NewsArticleModel> news;
  final String? countryError;
  final String? weatherError;
  final String? newsError;

  @override
  List<Object?> get props => [
        country,
        detail,
        weather,
        news,
        countryError,
        weatherError,
        newsError,
      ];
}

class DeepDiveFailure extends DeepDiveState {
  const DeepDiveFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
