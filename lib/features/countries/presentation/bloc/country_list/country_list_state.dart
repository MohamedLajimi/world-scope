part of 'country_list_bloc.dart';

sealed class CountryListState extends Equatable {
  const CountryListState();

  @override
  List<Object?> get props => [];
}

class CountryListLoading extends CountryListState {
  const CountryListLoading();
}

class CountryListSuccess extends CountryListState {
  const CountryListSuccess({
    required this.countries,
    required this.query,
  });

  final List<CountrySummaryModel> countries;
  final String query;

  @override
  List<Object?> get props => [countries, query];
}

class CountryListFailure extends CountryListState {
  const CountryListFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
