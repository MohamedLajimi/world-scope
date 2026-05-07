part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState({
    this.lastSearchedCity,
    this.showLastSearchSuggestion = false,
  });

  final String? lastSearchedCity;
  final bool showLastSearchSuggestion;

  @override
  List<Object?> get props => [lastSearchedCity, showLastSearchSuggestion];
}

class WeatherLoading extends WeatherState {
  const WeatherLoading({
    super.lastSearchedCity,
  });
}

class WeatherSuccess extends WeatherState {
  const WeatherSuccess({
    required this.weather,
    required this.city,
    super.lastSearchedCity,
    super.showLastSearchSuggestion = false,
  });

  final WeatherModel? weather;
  final String? city;

  @override
  List<Object?> get props => [
        ...super.props,
        weather,
        city,
      ];
}

class WeatherFailure extends WeatherState {
  const WeatherFailure({
    required this.message,
    super.lastSearchedCity,
    super.showLastSearchSuggestion = false,
  });

  final String message;

  @override
  List<Object?> get props => [
        ...super.props,
        message,
      ];
}
