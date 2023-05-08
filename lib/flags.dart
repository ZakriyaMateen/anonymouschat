import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CountryFlagPicker extends StatefulWidget {
  const CountryFlagPicker({Key? key}) : super(key: key);

  @override
  State<CountryFlagPicker> createState() => _CountryFlagPickerState();
}

class _CountryFlagPickerState extends State<CountryFlagPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: <Widget>[
          Image.asset('icons/flags/png/de.png', package: 'country_icons'),
          Image.asset('icons/flags/png/gb.png', package: 'country_icons'),
          Image.asset('icons/flags/png/fr.png', package: 'country_icons'),
          Image.asset('icons/flags/png/es.png', package: 'country_icons'),
          Image.asset('icons/flags/png/it.png', package: 'country_icons'),
          Image.asset('icons/flags/png/eu.png', package: 'country_icons'),

          Image.asset('icons/flags/png/2.5x/de.png', package: 'country_icons'),
          Image.asset('icons/flags/png/2.5x/gb.png', package: 'country_icons'),
          Image.asset('icons/flags/png/2.5x/fr.png', package: 'country_icons'),
          Image.asset('icons/flags/png/2.5x/es.png', package: 'country_icons'),
          Image.asset('icons/flags/png/2.5x/it.png', package: 'country_icons'),
          Image.asset('icons/flags/png/2.5x/eu.png', package: 'country_icons'),

          SvgPicture.asset('icons/flags/svg/de.svg', package: 'country_icons'),
          SvgPicture.asset('icons/flags/svg/gb.svg', package: 'country_icons'),
          SvgPicture.asset('icons/flags/svg/fr.svg', package: 'country_icons'),
          SvgPicture.asset('icons/flags/svg/es.svg', package: 'country_icons'),
          SvgPicture.asset('icons/flags/svg/it.svg', package: 'country_icons'),
          SvgPicture.asset('icons/flags/svg/eu.svg', package: 'country_icons'),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );  }
}
