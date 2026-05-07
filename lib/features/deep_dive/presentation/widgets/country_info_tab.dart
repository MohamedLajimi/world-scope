import 'package:flutter/material.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/features/countries/presentation/widgets/country_details_card.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';

class CountryInfoTab extends StatelessWidget {
  const CountryInfoTab({super.key, required this.state});

  final DeepDiveSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state.countryError != null || state.detail == null) {
      return AppErrorWidget(
        message: state.countryError ?? 'Unable to load country info.',
      );
    }

    final detail = state.detail!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              detail.flagUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 200,
                color: Colors.grey.shade700,
                alignment: Alignment.center,
                child: const Icon(Icons.flag_outlined, size: 42),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CountryDetailsCard(detail: detail),
        ],
      ),
    );
  }
}
