import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restcountries/custom_appbar.dart';
import 'package:restcountries/home_widget.dart';
import 'package:restcountries/model/country_model.dart';
import 'package:restcountries/service/country_service.dart';

class DetailWidget extends StatefulWidget {
  final CountryModel country;

  const DetailWidget({super.key, required this.country});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final CountryService _countryService = CountryService();
  late List<String> _countryBordes;
  late Future<List<CountryModel>> _borderCountrieNamesFuture;
  final _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _countryBordes  = widget.country.borders;
    _borderCountrieNamesFuture = _loadBorderCountrieNames();
  }

  Future<List<CountryModel>> _loadBorderCountrieNames() async {
    List<CountryModel> borderCountries = [];
    for (String cca3 in _countryBordes) {
      CountryModel country = await _countryService.getBorderCountrieName(cca3: cca3);
      borderCountries.add(country);
    }
    return borderCountries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeWidget()),
                  );
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: ClipRRect(
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(widget.country.flagUrl),
                    ),
                  ),
                ),
              ),
              Text(widget.country.commonName, style: _textSytle800(fontSize: 20)),
              _detailTextWidget(description: 'Native Name', response: widget.country.commonNativeName),
              _detailTextWidget(description: 'Population', response: _formatter.format(widget.country.population)),
              _detailTextWidget(description: 'Region', response: widget.country.region),
              _detailTextWidget(description: 'Sub Region', response: widget.country.subregion),
              _detailTextWidget(description: 'Capital', response: widget.country.capital),
              const SizedBox(
                height: 50,
              ),
              _detailTextWidget(description: 'Top Level Domain', response: widget.country.topLevelDomain),
              _detailTextWidget(description: 'Currencies', response: widget.country.currencies),
              _detailTextWidget(description: 'Languages', response: widget.country.languages),
              const SizedBox(
                height: 50,
              ),
              Text('Border Countires:', style: _textSytle600(fontSize: 18)),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder<List<CountryModel>>(
                future: _borderCountrieNamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No border countries available'));
                  } else {
                    return Wrap(
                      spacing: 8.0, // Horizontaler Abstand zwischen den Chips
                      runSpacing: 8.0, // Vertikaler Abstand zwischen den Zeilen
                      children: snapshot.data!.map((borderCountry) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailWidget(country: borderCountry)),
                            );
                          },
                          child: Chip(
                            label: Text(borderCountry.commonName),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailTextWidget({required String description, required dynamic response}){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 4.0,0.0,4.0),
      child: Row(
        children: [
          Text(
            '$description: ',
            style: _textSytle600(),
          ),
          Flexible(
            child: response is String
                ? Text(
              response,
              style: _textSytle300(),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            )
                : Text(
              response.join(', '),
              style: _textSytle300(),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textSytle300({double fontSize = 16}){
    return TextStyle(fontWeight: FontWeight.w300, fontSize: fontSize, fontFamily: 'NunitoSans');
  }

  TextStyle _textSytle600({double fontSize = 16}){
    return TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize, fontFamily: 'NunitoSans');
  }

  TextStyle _textSytle800({double fontSize = 16}){
    return TextStyle(fontWeight: FontWeight.w800, fontSize: fontSize, fontFamily: 'NunitoSans');
  }
}
