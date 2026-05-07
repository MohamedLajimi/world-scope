abstract class WeatherFailure {
  const WeatherFailure(this.message);

  final String message;
}

class WeatherNetworkFailure extends WeatherFailure {
  const WeatherNetworkFailure()
      : super(
          'No internet connection. Please check your network and try again.',
        );
}

class WeatherServerFailure extends WeatherFailure {
  const WeatherServerFailure()
      : super(
          'Weather service is temporarily unavailable. Please try again shortly.',
        );
}

class CityNotFoundFailure extends WeatherFailure {
  const CityNotFoundFailure()
      : super(
          'City not found. Please check the name and try again.',
        );
}

class WeatherParsingFailure extends WeatherFailure {
  const WeatherParsingFailure()
      : super(
          'We could not read weather data. Please try again.',
        );
}

class MissingApiKeyFailure extends WeatherFailure {
  const MissingApiKeyFailure()
      : super(
          'OpenCage API key is missing. Please check your environment setup.',
        );
}

class UnknownWeatherFailure extends WeatherFailure {
  const UnknownWeatherFailure()
      : super(
          'Something went wrong while loading weather data. Please try again.',
        );
}
