class CountryModel {
  final String commonName;
  final String commonNativeName;
  final int population;
  final String region;
  final String subregion;
  final String capital;
  final String topLevelDomain;
  final String currencies;
  final List<String> languages;
  final String flagUrl;
  final List<String> borders;
  final String cca3;

  CountryModel({
    required this.commonName,
    required this.commonNativeName,
    required this.population,
    required this.region,
    required this.subregion,
    required this.capital,
    required this.topLevelDomain,
    required this.currencies,
    required this.languages,
    required this.flagUrl,
    required this.borders,
    required this.cca3,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    final nativeName = (name['nativeName'] as Map<String, dynamic>? ?? {}).values.toList();
    final currenciesMap = json['currencies'] as Map<String, dynamic>? ?? {};
    final languagesMap = json['languages'] as Map<String, dynamic>? ?? {};
    final flags = json['flags'] as Map<String, dynamic>? ?? {};

    return CountryModel(
      commonName: name['common'] as String? ?? 'N/A',
      commonNativeName: nativeName.isNotEmpty ? nativeName.first['common'] as String? ?? 'N/A' : 'N/A',
      population: json['population'] as int? ?? 0,
      region: json['region'] as String? ?? 'N/A',
      subregion: json['subregion'] as String? ?? 'N/A',
      capital: (json['capital'] as List<dynamic>?)?.firstOrNull as String? ?? 'N/A',
      topLevelDomain: (json['tld'] as List<dynamic>?)?.firstOrNull as String? ?? 'N/A',
      currencies: currenciesMap.values.firstOrNull?['name'] as String? ?? 'N/A',
      languages: languagesMap.values.map((e) => e as String).toList(),
      flagUrl: flags['png'] as String? ?? 'N/A',
      borders: (json['borders'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      cca3: json['cca3'] as String? ?? 'N/A',
    );
  }
}
