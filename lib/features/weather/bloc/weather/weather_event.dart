part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class WeatherInitialized extends WeatherEvent {
  const WeatherInitialized();
}

class WeatherSearchFieldTapped extends WeatherEvent {
  const WeatherSearchFieldTapped();
}

class WeatherSearchSubmitted extends WeatherEvent {
  const WeatherSearchSubmitted(this.city);

  final String city;

  @override
  List<Object?> get props => [city];
}
