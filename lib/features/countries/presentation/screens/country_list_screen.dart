import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:worldscope/core/router/app_router.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/core/widgets/app_search_field.dart';
import 'package:worldscope/features/countries/bloc/country_list/country_list_bloc.dart';
import 'package:worldscope/features/countries/presentation/widgets/country_card.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CountryListBloc>().add(const CountryListLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CountryListBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Countries')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchField(
              hintText: 'Search by country name',
              onChanged: (query) {
                bloc.add(CountryListSearchChanged(query));
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CountryListBloc, CountryListState>(
                builder: (context, state) {
                  if (state is CountryListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CountryListFailure) {
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        bloc.add(const CountryListLoadRequested());
                      },
                    );
                  }

                  if (state is CountryListSuccess) {
                    if (state.countries.isEmpty) {
                      return const Center(
                        child: Text('No countries match your search.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.countries.length,
                      itemBuilder: (context, index) {
                        final country = state.countries[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CountryCard(
                            country: country,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.countryDetails.name,
                                extra: country,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
