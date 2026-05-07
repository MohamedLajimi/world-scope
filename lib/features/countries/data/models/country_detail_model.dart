class CountryDetailModel {
  const CountryDetailModel({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.currency,
    required this.currencySymbol,
    required this.languages,
    required this.population,
  });

  final String name;
  final String flagUrl;
  final String capital;
  final String currency;
  final String currencySymbol;
  final String languages;
  final int population;

  factory CountryDetailModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>?;
    final flagsMap = json['flags'] as Map<String, dynamic>?;
    final currenciesMap = json['currencies'] as Map<String, dynamic>?;
    final firstCurrency = currenciesMap == null || currenciesMap.isEmpty
        ? null
        : currenciesMap.values.first as Map<String, dynamic>?;

    final capitalList = json['capital'] as List<dynamic>?;
    final languagesMap = json['languages'] as Map<String, dynamic>?;

    return CountryDetailModel(
      name: (nameMap?['common'] as String?) ?? '',
      flagUrl: (flagsMap?['png'] as String?) ?? '',
      capital: (capitalList?.isNotEmpty == true ? capitalList!.first : null)
              as String? ??
          'N/A',
      currency: (firstCurrency?['name'] as String?) ?? 'N/A',
      currencySymbol: (firstCurrency?['symbol'] as String?) ?? '',
      languages: languagesMap == null || languagesMap.isEmpty
          ? 'N/A'
          : languagesMap.values.map((value) => '$value').join(', '),
      population: (json['population'] as num?)?.toInt() ?? 0,
    );
  }
}
