import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';
import 'package:okoul_project/api/country_model.dart';
import 'package:okoul_project/api/country_repo.dart';
import 'package:okoul_project/utils/constants.dart';
import 'package:okoul_project/utils/layouts.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomCity extends StatefulWidget {
  CountryModel countries;
  CustomCity({super.key, required this.countries});

  @override
  State<CustomCity> createState() => _CustomCityState(countries);
}

class _CustomCityState extends State<CustomCity> {
  CountryModel? countries;
  bool condition = false;
  _CustomCityState(this.countries);
  String? country;
  TextEditingController city = TextEditingController();
  CoutryRepo repo = CoutryRepo(URI: Constants.COUNTRY_URL);
  List<String> citiesList = [];
  Widget cities = Container();

  @override
  Widget build(BuildContext context) {
    List<String> countriesString = [];
    for (var element in countries!.data!) {
      countriesString.add(element.country!);
    }

    List<String>? getCities() {
      for (var element in countries!.data!) {
        if (element.country == country) return element.cities;
      }
    }

    return Container(
      margin: EdgeInsets.fromLTRB(
          Layouts.size25, Layouts.size25 * 2, Layouts.size25, Layouts.size25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: (() {
                    Navigator.of(context).pop();
                  }),
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: Layouts.size35,
                    color: Constants.alterColor,
                  ))
            ],
          ),
          DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSelectedItems: false,
            ),
            items: countriesString,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Country",
                hintText: "Choose country",
              ),
            ),
            onChanged: ((value) {
              setState(() {
                country = value;
                condition = true;
                citiesList = getCities()!;
              });
            }),
            selectedItem: "Choose country",
          ),
          DropdownSearch<String>(
            enabled: condition,
            popupProps: PopupProps.menu(
              showSelectedItems: false,
            ),
            items: citiesList,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "City",
                hintText: "Choose city",
              ),
            ),
            onChanged: print,
            selectedItem: "Choose city",
          ),
          SizedBox(
            height: Layouts.size10,
          ),
          cities,
          Container(
            height: 300,
            width: 150,
            padding: EdgeInsets.all(Layouts.size25),
            margin: EdgeInsets.fromLTRB(
                Layouts.dayPaddingW,
                Layouts.size10 * 0.5,
                Layouts.dayPaddingW,
                Layouts.size10 * 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Layouts.size35),
              color: Constants.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
