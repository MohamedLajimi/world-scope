import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worldscope/features/countries/data/models/country_summary_model.dart';
import 'package:worldscope/features/countries/data/services/country_service.dart';

part 'country_list_event.dart';
part 'country_list_state.dart';

class CountryListBloc extends Bloc<CountryListEvent, CountryListState> {
  CountryListBloc({
    required CountryService countryService,
  })  : _countryService = countryService,
        super(const CountryListLoading()) {
    on<CountryListLoadRequested>(_onLoadRequested);
    on<CountryListSearchChanged>(_onSearchChanged);
  }

  final CountryService _countryService;
  List<CountrySummaryModel> _allCountries = const [];

  Future<void> _onLoadRequested(
    CountryListLoadRequested event,
    Emitter<CountryListState> emit,
  ) async {
    emit(const CountryListLoading());

    final result = await _countryService.fetchAllCountries();
    result.fold(
      (failure) => emit(CountryListFailure(failure.message)),
      (countries) {
        _allCountries = countries;
        emit(
          CountryListSuccess(
            countries: countries,
            query: '',
          ),
        );
      },
    );
  }

  Future<void> _onSearchChanged(
    CountryListSearchChanged event,
    Emitter<CountryListState> emit,
  ) async {
    final filteredResult = _countryService.searchCountries(
      countries: _allCountries,
      query: event.query,
    );

    filteredResult.fold(
      (failure) => emit(CountryListFailure(failure.message)),
      (filteredCountries) => emit(
        CountryListSuccess(
          countries: filteredCountries,
          query: event.query,
        ),
      ),
    );
  }
}
