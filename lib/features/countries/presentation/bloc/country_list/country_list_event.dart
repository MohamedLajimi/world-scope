part of 'country_list_bloc.dart';

sealed class CountryListEvent extends Equatable {
  const CountryListEvent();

  @override
  List<Object?> get props => [];
}

class CountryListLoadRequested extends CountryListEvent {
  const CountryListLoadRequested();
}

class CountryListSearchChanged extends CountryListEvent {
  const CountryListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
