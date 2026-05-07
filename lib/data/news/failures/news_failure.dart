abstract class NewsFailure {
  const NewsFailure(this.message);

  final String message;
}

class NewsNetworkFailure extends NewsFailure {
  const NewsNetworkFailure()
      : super(
          'No internet connection. Please check your network and try again.',
        );
}

class NewsServerFailure extends NewsFailure {
  const NewsServerFailure()
      : super(
          'News service is temporarily unavailable. Please try again shortly.',
        );
}

class MissingNewsApiKeyFailure extends NewsFailure {
  const MissingNewsApiKeyFailure()
      : super(
          'News API key is missing. Please check your environment setup.',
        );
}

class NewsParsingFailure extends NewsFailure {
  const NewsParsingFailure()
      : super(
          'We could not read news data. Please try again.',
        );
}

class UnknownNewsFailure extends NewsFailure {
  const UnknownNewsFailure()
      : super(
          'Something went wrong while loading news. Please try again.',
        );
}

class UnknownNewsFailureWithMessage extends NewsFailure {
  const UnknownNewsFailureWithMessage(super.message);
}
