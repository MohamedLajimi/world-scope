part of 'country_detail_bloc.dart';

sealed class CountryDetailEvent extends Equatable {
  const CountryDetailEvent();

  @override
  List<Object?> get props => [];
}

class CountryDetailLoadRequested extends CountryDetailEvent {
  const CountryDetailLoadRequested(this.countryCode);

  final String countryCode;

  @override
  List<Object?> get props => [countryCode];
}
