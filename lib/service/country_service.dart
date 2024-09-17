import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/country_model.dart';

class CountryService {
  static const String baseUrl = 'https://restcountries.com/v3.1';

  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/all?fields=name,population,region,subregion,capital,tld,currencies,languages,flags,borders,cca3,'
      ));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => CountryModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return [];
    }
  }

  Future<List<CountryModel>> getCountriesByName({required String name}) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/name/$name?fields=name,population,region,subregion,capital,tld,currencies,languages,flags,borders,cca3,'
      ));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => CountryModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return [];
    }
  }

  Future<List<CountryModel>> getCountriesByRegion({required String region}) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/region/$region?fields=name,population,region,subregion,capital,tld,currencies,languages,flags,borders,cca3,'
      ));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => CountryModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      return [];
    }
  }

  Future<CountryModel> getBorderCountrieName({required String cca3}) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/alpha/${cca3}?fields=name,population,region,subregion,capital,tld,currencies,languages,flags,borders,cca3,'
      ));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return CountryModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load border countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching border countries: $e');
      return CountryModel(
        commonName: 'N/A',
        commonNativeName: 'N/A',
        population: 0,
        region: 'N/A',
        subregion: 'N/A',
        capital: 'N/A',
        topLevelDomain: 'N/A',
        currencies: 'N/A',
        languages: [],
        flagUrl: 'N/A',
        borders: [],
        cca3: 'N/A',
      );
    }
  }
}
