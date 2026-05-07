# WorldScope

WorldScope is a Flutter mobile app that combines country browsing, weather lookup, and a deep-dive dashboard (country info + weather + news).

## Features

- **Countries**: searchable country list with detail screen
- **Weather**: city search, current weather, and 7-day forecast
- **Deep Dive**: select a country and load Country/Weather/News in tabs
- **Parallel Level 3 loading**: deep-dive data fetched with `Future.wait(...)`
- **Resilient UI**: one failed API section does not block other tabs

## Tech Stack

- Flutter + Dart
- BLoC (`flutter_bloc`)
- Dependency injection (`get_it`)
- Networking (`dio`)
- Functional error handling (`fpdart`)
- Routing (`go_router`)
- Local persistence (`shared_preferences`)
- Env vars (`flutter_dotenv`)

## APIs

- REST Countries: `https://restcountries.com/v3.1`
- OpenCage Geocoding: `https://api.opencagedata.com/geocode/v1/json`
- Open-Meteo: `https://api.open-meteo.com/v1/forecast`
- NewsAPI: `https://newsapi.org/v2/top-headlines`

## Project Structure (high level)

```text
lib/
  core/        # router, theme, DI, shared UI/utilities
  data/        # shared models/services/failures (countries, weather, news)
  features/    # feature-specific presentation and blocs
```

## Setup

1. Install Flutter SDK.
2. Install dependencies:
   - `flutter pub get`
3. Create a `.env` file in project root:
   - `OPENCAGE_API_KEY=your_key`
   - `NEWS_API_KEY=your_key`
4. Run:
   - `flutter run`

## Notes

- `.env` is ignored by git.
- Deep Dive uses a searchable country picker and 3 tabs:
  - Country Info
  - Weather
  - News (top headlines, tappable links)
