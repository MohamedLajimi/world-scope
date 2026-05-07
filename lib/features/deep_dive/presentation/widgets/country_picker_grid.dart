import 'package:flutter/material.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';

class CountryPickerGrid extends StatelessWidget {
  const CountryPickerGrid({
    super.key,
    required this.countries,
    required this.onSelect,
  });

  final List<CountrySummaryModel> countries;
  final ValueChanged<CountrySummaryModel> onSelect;

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return const Center(
        child: Text('No countries match your search.'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return InkWell(
          onTap: () => onSelect(country),
          borderRadius: BorderRadius.circular(14),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      country.flagUrl,
                      width: 46,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.flag_outlined),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    country.name.isEmpty ? 'Unknown' : country.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
