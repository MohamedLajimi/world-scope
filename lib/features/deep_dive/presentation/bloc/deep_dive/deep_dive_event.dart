part of 'deep_dive_bloc.dart';

sealed class DeepDiveEvent extends Equatable {
  const DeepDiveEvent();

  @override
  List<Object?> get props => [];
}

class DeepDiveLoadRequested extends DeepDiveEvent {
  const DeepDiveLoadRequested(this.country);

  final CountrySummaryModel country;

  @override
  List<Object?> get props => [country];
}
