abstract class CountryFailure {
  const CountryFailure(this.message);

  final String message;
}

class NetworkFailure extends CountryFailure {
  const NetworkFailure()
      : super(
          'No internet connection. Please check your network and try again.',
        );
}

class ServerFailure extends CountryFailure {
  const ServerFailure()
      : super(
          'Server error while loading country data. Please try again shortly.',
        );
}

class NotFoundFailure extends CountryFailure {
  const NotFoundFailure()
      : super(
          'Country data was not found. Please try another country.',
        );
}

class ParsingFailure extends CountryFailure {
  const ParsingFailure()
      : super(
          'We could not read country data. Please try again.',
        );
}

class UnknownFailure extends CountryFailure {
  const UnknownFailure()
      : super(
          'Something went wrong. Please try again.',
        );
}
