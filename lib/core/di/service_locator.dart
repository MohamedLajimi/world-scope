import 'package:get_it/get_it.dart';
import 'package:worldscope/data/countries/services/country_service.dart';
import 'package:worldscope/data/news/services/news_service.dart';
import 'package:worldscope/data/weather/services/weather_service.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';
import 'package:worldscope/features/countries/bloc/country_detail/country_detail_bloc.dart';
import 'package:worldscope/features/countries/bloc/country_list/country_list_bloc.dart';
import 'package:worldscope/features/weather/bloc/weather/weather_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<CountryService>(
    CountryService.new,
  );

  sl.registerFactory<CountryListBloc>(
    () => CountryListBloc(
      countryService: sl<CountryService>(),
    ),
  );

  sl.registerFactory<CountryDetailBloc>(
    () => CountryDetailBloc(
      countryService: sl<CountryService>(),
    ),
  );

  sl.registerLazySingleton<WeatherService>(
    WeatherService.new,
  );

  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(
      weatherService: sl<WeatherService>(),
    ),
  );

  sl.registerLazySingleton<NewsService>(
    NewsService.new,
  );

  sl.registerFactory<DeepDiveBloc>(
    () => DeepDiveBloc(
      countryService: sl<CountryService>(),
      weatherService: sl<WeatherService>(),
      newsService: sl<NewsService>(),
    ),
  );

}
