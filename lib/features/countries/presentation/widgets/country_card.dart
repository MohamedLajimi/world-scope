import 'package:flutter/material.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    this.onTap,
  });

  final CountrySummaryModel country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  country.flagUrl,
                  width: 56,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 56,
                    height: 40,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.flag_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  country.name.isEmpty ? 'Unknown country' : country.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
