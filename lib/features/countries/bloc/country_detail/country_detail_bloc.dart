import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worldscope/data/countries/models/country_detail_model.dart';
import 'package:worldscope/data/countries/services/country_service.dart';

part 'country_detail_event.dart';
part 'country_detail_state.dart';

class CountryDetailBloc extends Bloc<CountryDetailEvent, CountryDetailState> {
  CountryDetailBloc({
    required CountryService countryService,
  })  : _countryService = countryService,
        super(const CountryDetailLoading()) {
    on<CountryDetailLoadRequested>(_onLoadRequested);
  }

  final CountryService _countryService;

  Future<void> _onLoadRequested(
    CountryDetailLoadRequested event,
    Emitter<CountryDetailState> emit,
  ) async {
    emit(const CountryDetailLoading());

    final result = await _countryService.fetchCountryDetail(event.countryCode);
    result.fold(
      (failure) => emit(CountryDetailFailure(failure.message)),
      (detail) => emit(CountryDetailSuccess(detail)),
    );
  }
}
