import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restcountries/custom_appbar.dart';
import 'package:restcountries/detail_widget.dart';
import 'package:restcountries/service/country_service.dart';

import 'colors/app_colors.dart';
import 'model/country_model.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final CountryService _countryService = CountryService();
  late Future<List<CountryModel>> _countriesFuture;
  String _selectedRegion = 'Filter by Region';
  final _formatter = NumberFormat('#,###');
  List<CountryModel> _filteredCountries = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _countriesFuture = _countryService.getCountries();
  }

  void _filterCountriesByRegion(String region) async {
    setState(() {
      _selectedRegion = region;
    });

    if (region == "Filter by Region") {
      _applyFilters();
    } else {
      try {
        final countries = await _countryService.getCountriesByRegion(region: region);
        setState(() {
          _filteredCountries = countries;
        });
      } catch (e) {
        setState(() {
          _filteredCountries = [];
        });
      }
    }
  }

  void _filterCountriesByName(String query) async {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredCountries = [];
      });
    } else {
      try {
        final countries = await _countryService.getCountriesByName(name: query);
        setState(() {
          _filteredCountries = countries;
        });
      } catch (e) {
        setState(() {
          _filteredCountries = [];
        });
      }
    }
  }

  void _applyFilters() async {
    if (_searchQuery.isEmpty && _selectedRegion == 'Filter by Region') {
      setState(() {
        _filteredCountries = [];
      });
    } else {
      try {
        List<CountryModel> countries;
        if (_searchQuery.isNotEmpty) {
          countries = await _countryService.getCountriesByName(name: _searchQuery);
        } else {
          countries = await _countriesFuture;
        }

        if (_selectedRegion != 'Filter by Region') {
          countries = countries.where((country) => country.region == _selectedRegion).toList();
        }

        setState(() {
          _filteredCountries = countries;
        });
      } catch (e) {
        setState(() {
          _filteredCountries = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 25, 15, 25),
            padding: const EdgeInsets.fromLTRB(5, 25, 25, 25),
            height: 70,
            decoration: AppTheme.getContainerDecoration(context),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search for a country ...', prefixIcon: Icon(Icons.search), border: InputBorder.none),
              onChanged: _filterCountriesByName,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            height: 60,
            decoration: AppTheme.getContainerDecoration(context),
            child: DropdownButton<String>(
              value: _selectedRegion,
              isExpanded: false,
              items: <String>['Filter by Region', 'Africa', 'Americas', 'Asia', 'Europe', 'Oceania']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegion = newValue!;
                  _filterCountriesByRegion(_selectedRegion);
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder<List<CountryModel>>(
            future: _countriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final countries = (_searchQuery.isEmpty && _selectedRegion == 'Filter by Region') ? snapshot.data! : _filteredCountries;
                return ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    CountryModel country = countries[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailWidget(country: country)),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(40),
                        height: 350,
                        width: 200,
                        decoration: AppTheme.getContainerDecoration(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Flagge oben
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.network(country.flagUrl),
                                  ),
                                ),
                              ),
                            ),
                            // Textinformationen unten
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      child: Text(country.commonName, style: _textSytle800(fontSize: 18)),
                                    ),
                                    _homeTextWidget(
                                        description: 'Population', response: _formatter.format(country.population)),
                                    _homeTextWidget(description: 'Region', response: country.region),
                                    _homeTextWidget(description: 'Capital', response: country.capital),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No data available');
              }
            },
          )),
        ],
      ),
    );
  }

  Widget _homeTextWidget({required String description, required dynamic response}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Row(
        children: [
          Text(
            '$description: ',
            style: _textSytle600(),
          ),
          Text(response, style: _textSytle300())
        ],
      ),
    );
  }

  TextStyle _textSytle300({double fontSize = 14}) {
    return TextStyle(fontWeight: FontWeight.w300, fontSize: fontSize, fontFamily: 'NunitoSans');
  }

  TextStyle _textSytle600({double fontSize = 14}) {
    return TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, fontFamily: 'NunitoSans');
  }

  TextStyle _textSytle800({double fontSize = 14}) {
    return TextStyle(fontWeight: FontWeight.w800, fontSize: fontSize, fontFamily: 'NunitoSans');
  }
}
