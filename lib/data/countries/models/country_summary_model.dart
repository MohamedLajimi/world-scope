class CountrySummaryModel {
  const CountrySummaryModel({
    required this.name,
    required this.flagUrl,
    required this.cca2,
    required this.cca3,
    required this.capital,
  });

  final String name;
  final String flagUrl;
  final String cca2;
  final String cca3;
  final String capital;

  factory CountrySummaryModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>?;
    final flagsMap = json['flags'] as Map<String, dynamic>?;
    final capitalList = json['capital'] as List<dynamic>?;

    return CountrySummaryModel(
      name: (nameMap?['common'] as String?) ?? '',
      flagUrl: (flagsMap?['png'] as String?) ?? '',
      cca2: (json['cca2'] as String?) ?? '',
      cca3: (json['cca3'] as String?) ?? '',
      capital: (capitalList?.isNotEmpty == true ? capitalList!.first : null)
              as String? ??
          '',
    );
  }
}
