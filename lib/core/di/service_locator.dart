import 'package:get_it/get_it.dart';
import 'package:worldscope/features/countries/data/services/country_service.dart';
import 'package:worldscope/features/countries/presentation/bloc/country_detail/country_detail_bloc.dart';
import 'package:worldscope/features/countries/presentation/bloc/country_list/country_list_bloc.dart';

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
}
