import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';
import 'package:worldscope/features/countries/bloc/country_detail/country_detail_bloc.dart';
import 'package:worldscope/features/countries/presentation/widgets/country_details_card.dart';

class CountryDetailScreen extends StatefulWidget {
  const CountryDetailScreen({
    super.key,
    required this.country,
  });

  final CountrySummaryModel country;

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CountryDetailBloc>().add(
          CountryDetailLoadRequested(widget.country.cca3),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CountryDetailBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.country.name.isEmpty ? 'Country details' : widget.country.name,
        ),
      ),
      body: BlocBuilder<CountryDetailBloc, CountryDetailState>(
        builder: (context, state) {
          if (state is CountryDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CountryDetailFailure) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                bloc.add(CountryDetailLoadRequested(widget.country.cca3));
              },
            );
          }

          if (state is CountryDetailSuccess) {
            final detail = state.detail;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    detail.flagUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.flag_outlined, size: 40),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      detail.name.isEmpty ? 'Unknown country' : detail.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CountryDetailsCard(detail: detail),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
