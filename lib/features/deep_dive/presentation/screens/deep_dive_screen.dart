import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldscope/core/di/service_locator.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/core/widgets/app_search_field.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';
import 'package:worldscope/data/countries/services/country_service.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';
import 'package:worldscope/features/deep_dive/presentation/widgets/country_picker_grid.dart';
import 'package:worldscope/features/deep_dive/presentation/widgets/deep_dive_tabs.dart';

class DeepDiveScreen extends StatefulWidget {
  const DeepDiveScreen({super.key});

  @override
  State<DeepDiveScreen> createState() => _DeepDiveScreenState();
}

class _DeepDiveScreenState extends State<DeepDiveScreen> {
  final CountryService _countryService = sl<CountryService>();
  List<CountrySummaryModel> _allCountries = const [];
  List<CountrySummaryModel> _filteredCountries = const [];
  bool _countriesLoading = true;
  String? _countriesError;
  CountrySummaryModel? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _countriesLoading = true;
      _countriesError = null;
    });

    final result = await _countryService.fetchAllCountries();
    result.fold(
      (failure) {
        setState(() {
          _countriesError = failure.message;
          _countriesLoading = false;
        });
      },
      (countries) {
        setState(() {
          _allCountries = countries;
          _filteredCountries = countries;
          _countriesLoading = false;
        });
      },
    );
  }

  void _filterCountries(String query) {
    final result = _countryService.searchCountries(
      countries: _allCountries,
      query: query,
    );
    result.fold(
      (_) => null,
      (countries) {
        setState(() => _filteredCountries = countries);
      },
    );
  }

  void _selectCountry(CountrySummaryModel country) {
    setState(() => _selectedCountry = country);
    context.read<DeepDiveBloc>().add(DeepDiveLoadRequested(country));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Dive'),
      ),
      body: _countriesLoading
          ? const Center(child: CircularProgressIndicator())
          : _countriesError != null
              ? AppErrorWidget(
                  message: _countriesError!,
                  onRetry: _loadCountries,
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AppSearchField(
                        hintText: 'Search country',
                        onChanged: _filterCountries,
                      ),
                      const SizedBox(height: 12),
                      if (_selectedCountry == null)
                        Expanded(
                          child: CountryPickerGrid(
                            countries: _filteredCountries,
                            onSelect: _selectCountry,
                          ),
                        )
                      else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedCountry!.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() => _selectedCountry = null);
                              },
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Expanded(child: DeepDiveTabs()),
                      ],
                    ],
                  ),
                ),
    );
  }
}
