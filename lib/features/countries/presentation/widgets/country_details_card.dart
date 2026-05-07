import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worldscope/data/countries/models/country_detail_model.dart';

class CountryDetailsCard extends StatelessWidget {
  const CountryDetailsCard({super.key, required this.detail});

  final CountryDetailModel detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(label: 'Capital', value: detail.capital),
            _InfoRow(
              label: 'Currency',
              value: detail.currencySymbol.isEmpty
                  ? detail.currency
                  : '${detail.currency} (${detail.currencySymbol})',
            ),
            _InfoRow(label: 'Languages', value: detail.languages),
            _InfoRow(
              label: 'Population',
              value: NumberFormat.compact().format(detail.population),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$label:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
