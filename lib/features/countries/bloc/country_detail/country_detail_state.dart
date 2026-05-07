part of 'country_detail_bloc.dart';

sealed class CountryDetailState extends Equatable {
  const CountryDetailState();

  @override
  List<Object?> get props => [];
}

class CountryDetailLoading extends CountryDetailState {
  const CountryDetailLoading();
}

class CountryDetailSuccess extends CountryDetailState {
  const CountryDetailSuccess(this.detail);

  final CountryDetailModel detail;

  @override
  List<Object?> get props => [detail];
}

class CountryDetailFailure extends CountryDetailState {
  const CountryDetailFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
