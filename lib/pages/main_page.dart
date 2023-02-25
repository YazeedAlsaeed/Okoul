import 'dart:io';

import 'package:flutter/material.dart';
import 'package:okoul_project/api/country_model.dart';
import 'package:okoul_project/api/country_repo.dart';
import 'package:okoul_project/pages/city_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:okoul_project/api/constructor.dart';
import 'package:okoul_project/api/model.dart';
import 'package:okoul_project/api/repo.dart';
import 'package:okoul_project/icons/icons.dart';
import 'package:okoul_project/utils/constants.dart';
import 'package:okoul_project/utils/layouts.dart';
import 'package:okoul_project/utils/main_text.dart';
import 'package:okoul_project/utils/second_text.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:dropdown_search/dropdown_search.dart';

class MainPage extends StatefulWidget {
  String? city;
  String? country;
  TimerModel? model;
  Timings? timing;
  Date? date;
  DateTime now;
  CountryModel? countries;

  MainPage(
      {super.key,
      required this.city,
      required this.country,
      required this.model,
      required this.timing,
      required this.date,
      required this.now,
      required this.countries});

  @override
  State<MainPage> createState() => _MainPageState(
      city: city,
      country: country,
      model: model,
      timing: timing,
      date: date,
      now: now,
      countries: countries);
}

class _MainPageState extends State<MainPage> {
  bool starCondition = true;
  bool condition = false;
  String? stared_country;
  String? iso;
  String? stared_city;
  CoutryRepo repo = CoutryRepo(URI: Constants.COUNTRY_URL);
  List<String> citiesList = [];
  Widget cities = Container();

  List<String> countriesString = [];

  List<String>? getCities() {
    for (var element in countries!.data!) {
      if (element.country == stared_country) return element.cities;
    }
  }

  bool enable = false;
  String? city;
  String? country;
  TimerModel? model;
  Timings? timing;
  Date? date;
  Timings? timing2;
  Date? date2;
  DateTime now;
  int index = 1;
  CountryModel? countries;

  _MainPageState(
      {required this.city,
      required this.country,
      required this.model,
      required this.timing,
      required this.date,
      required this.now,
      required this.countries});

  var selectedDate = new DateTime.now();
  var formatterDate = new DateFormat('d-MM-yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterDayNumber = new DateFormat('d');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Constants.mainColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        enable = true;
        timing = null;
        _getCurrentPosition();
      });
    }
  }

  void _getModel() async {
    Construct construct =
        Construct(city: city, country: country, date: selectedDate);
    Repo repo = Repo(URI: construct.getFullUri());

    try {
      model = await repo.api_request();

      setState(() {
        model = model;

        for (int i = 0; i < model!.data.length; i++) {
          if (model!.data[i].date.gregorian.day ==
              formatterDayNumber
                  .format(selectedDate)
                  .toString()
                  .padLeft(2, "0")) {
            timing = model!.data[i].timings;
            date = model!.data[i].date;
          }
        }
      });
    } catch (e) {
      setState(() {
        country = e.toString();
      });
    }
  }

  void _getModel2() async {
    Construct construct = Construct(city: stared_city, country: iso, date: now);
    Repo repo = Repo(URI: construct.getFullUri());

    try {
      model = await repo.api_request();

      setState(() {
        model = model;

        for (int i = 0; i < model!.data.length; i++) {
          if (model!.data[i].date.gregorian.day ==
              formatterDayNumber
                  .format(selectedDate)
                  .toString()
                  .padLeft(2, "0")) {
            timing2 = model!.data[i].timings;
            date2 = model!.data[i].date;
          }
        }
      });
    } catch (e) {
      setState(() {
        country = e.toString();
      });
    }
  }

  bool triger = true;
  List<String> starred = [];
  String combined = "";

  //bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    for (var element in countries!.data!) {
      countriesString.add(element.country!);
    }
    //print(countries.data![0].country);

    String formattedDate = formatterDate.format(selectedDate);
    String formattedDay = formatterDay.format(selectedDate);

    return IndexedStack(index: index, children: [
      Container(
          margin: EdgeInsets.fromLTRB(0, Layouts.size25 * 2, 0, Layouts.size25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      padding: EdgeInsets.only(right: Layouts.size45),
                      onPressed: (() {
                        setState(() {
                          triger = true;
                          index = 1;
                        });
                      }),
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: Layouts.size35,
                        color: Constants.alterColor,
                      ))
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(Layouts.size25, Layouts.size10,
                    Layouts.size25, Layouts.size10),
                child: Column(children: [
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
                        stared_country = value;
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
                    onChanged: (value) {
                      setState(() {
                        stared_city = value;
                        combined = stared_city! + ";" + stared_country!;
                        if (starred.contains(combined)) {
                          starCondition = false;
                        } else {
                          starCondition = true;
                        }

                        triger = false;
                        timing2 = null;
                        _getModel2();
                      });
                    },
                    selectedItem: "Choose city",
                  ),
                ]),
              ),
              Container(
                child: triger
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Layouts.size75, 0, Layouts.size75, 0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color.fromARGB(
                                                  255, 213, 214, 214),
                                              highlightColor: Color.fromARGB(
                                                  255, 240, 240, 240),
                                              child: Container(
                                                height: Layouts.size35,
                                                width: Layouts.size45 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : MainText(text: stared_city!),
                                    ),
                                  ),
                                  timing2 == null
                                      ? Shimmer.fromColors(
                                          baseColor: Color.fromARGB(
                                              255, 213, 214, 214),
                                          highlightColor: Color.fromARGB(
                                              255, 240, 240, 240),
                                          child: Container(
                                            height: Layouts.size35,
                                            width: Layouts.size75,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Layouts.size10),
                                                color: Constants.mainColor),
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            if (starCondition)
                                              starred.add(combined);
                                            else {
                                              starred.remove(combined);
                                            }
                                            var file = await File(
                                                    '/Users/yzd/Developer/flutter_apps/okoul_project/lib/utils/staredCities.txt')
                                                .writeAsString(
                                                    starred.toString());
                                            setState(() {
                                              starCondition = !starCondition;
                                            });
                                          },
                                          icon: Icon(
                                            starCondition
                                                ? Icons.star_outline
                                                : Icons.star,
                                            color: Constants.alterColor,
                                            size: Layouts.size45,
                                          ),
                                        ),
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.all(Layouts.size25),
                            margin: EdgeInsets.fromLTRB(Layouts.dayPaddingW,
                                Layouts.size15, Layouts.dayPaddingW, 0),
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Fajr)),
                                    ),
                                    SecondText(text: "صلاة الفجر"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Layouts.size25,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Sunrise)),
                                    ),
                                    SecondText(text: "الشروق"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Layouts.size25,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Dhuhr)),
                                    ),
                                    SecondText(text: "صلاة الظهر"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Layouts.size25,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Asr)),
                                    ),
                                    SecondText(text: "صلاة العصر"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Layouts.size25,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Maghrib)),
                                    ),
                                    SecondText(text: "صلاة المغرب"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Layouts.size25,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Layouts.size10, 0, Layouts.size10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: timing2 == null
                                          ? Shimmer.fromColors(
                                              baseColor: Color(0xFFB1E0D6),
                                              highlightColor: Color(0xFFD6F0EB),
                                              child: Container(
                                                height: Layouts.size25,
                                                width: Layouts.size75 * 2,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Layouts.size10),
                                                    color: Constants.mainColor),
                                              ),
                                            )
                                          : SecondText(
                                              text: getTime(timing2!.Isha)),
                                    ),
                                    SecondText(text: "صلاة العشاء"),
                                  ],
                                ),
                              ),
                            ]),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Layouts.size35),
                              color: Constants.mainColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          )),

      /////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////
      ////////////////////////////////////////////////////////////////

      Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            //The day, The date, and the city
            //

            Container(
              padding: EdgeInsets.fromLTRB(Layouts.dayPaddingW,
                  Layouts.dayPaddingH, Layouts.dayPaddingW, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainText(
                            text: "$formattedDay",
                          ),
                          MainText(
                            text: " $formattedDate",
                            size: Layouts.size15,
                          ),
                        ]),
                    Container(
                      padding: EdgeInsets.only(top: Layouts.size35 * 0.7),
                      child: MainText(
                        text: "${city == null ? "Loading" : city}",
                        size: Layouts.size15,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: Layouts.size10 / 2,
            ),

            //
            //The date picker and the search button
            //

            Container(
              margin: EdgeInsets.only(bottom: Layouts.size10),
              child: IntrinsicHeight(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      child: Column(
                        children: [
                          SvgPicture.string(
                            appIcons.calender,
                          ),
                          SizedBox(
                            height: Layouts.size15,
                          ),
                          MainText(
                            text: "Change date",
                            size: Layouts.size10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: Constants.alterColor.withAlpha(100),
                    thickness: 1,
                    width: Layouts.size35 * 2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Container(
                      child: Column(
                        children: [
                          SvgPicture.string(
                            appIcons.search,
                          ),
                          SizedBox(
                            height: Layouts.size15,
                          ),
                          MainText(
                            text: "Search for City",
                            size: Layouts.size10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),

            //
            //RESET BUTTON IF DATE CHANGES
            //

            Container(
              height: Layouts.size45,
              child: enable
                  ? OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.alterColor.withAlpha(100)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Layouts.size15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedDate = now;
                          enable = false;
                          timing = null;
                          _getCurrentPosition();
                        });
                      },
                      child: SecondText(
                        text: " Reset Date ",
                        size: Layouts.size15,
                      ),
                    )
                  : Container(),
            ),

            //
            //Prayer Times
            //

            Container(
              padding: EdgeInsets.all(Layouts.size25),
              margin: EdgeInsets.fromLTRB(
                  Layouts.dayPaddingW,
                  Layouts.size10 * 0.5,
                  Layouts.dayPaddingW,
                  Layouts.size10 * 0.5),
              child: Column(children: [
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Fajr)),
                      ),
                      SecondText(text: "صلاة الفجر"),
                    ],
                  ),
                ),
                SizedBox(
                  height: Layouts.size25,
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Sunrise)),
                      ),
                      SecondText(text: "الشروق"),
                    ],
                  ),
                ),
                SizedBox(
                  height: Layouts.size25,
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Dhuhr)),
                      ),
                      SecondText(text: "صلاة الظهر"),
                    ],
                  ),
                ),
                SizedBox(
                  height: Layouts.size25,
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Asr)),
                      ),
                      SecondText(text: "صلاة العصر"),
                    ],
                  ),
                ),
                SizedBox(
                  height: Layouts.size25,
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Maghrib)),
                      ),
                      SecondText(text: "صلاة المغرب"),
                    ],
                  ),
                ),
                SizedBox(
                  height: Layouts.size25,
                ),
                Container(
                  margin:
                      EdgeInsets.fromLTRB(Layouts.size10, 0, Layouts.size10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: timing == null
                            ? Shimmer.fromColors(
                                baseColor: Color(0xFFB1E0D6),
                                highlightColor: Color(0xFFD6F0EB),
                                child: Container(
                                  height: Layouts.size25,
                                  width: Layouts.size75 * 2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Layouts.size10),
                                      color: Constants.mainColor),
                                ),
                              )
                            : SecondText(text: getTime(timing!.Isha)),
                      ),
                      SecondText(text: "صلاة العشاء"),
                    ],
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Layouts.size35),
                color: Constants.mainColor,
              ),
            ),

            SizedBox(
              height: Layouts.size15,
            ),

            //
            // Footer
            //
          ],
        ),
      ),
    ]);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    var pos = await Geolocator.getCurrentPosition();

    setState(() {
      _getAddressFromLatLng(pos);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude,
            localeIdentifier: "en_US")
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        country = place.country;
        city = place.locality;
        _getModel();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  String getTime(
    String prayer,
  ) {
    String day = date!.gregorian.day;
    String month = date!.gregorian.month.number.toString();
    String year = date!.gregorian.year;
    String time = prayer.substring(0, 5);

    DateTime fullDate = _getPSTTime(
        "$year-${month.toString().padLeft(2, "0")}-$day", "$time:00");

    var formatterPrayer = new DateFormat.jm();

    return formatterPrayer.format(fullDate);
  }

  DateTime _getPSTTime(String date, String time) {
    tz.initializeTimeZones();
    final moonLanding = DateTime.parse('$date ${time}');
    final mekkahtimeZone = tz.getLocation('Asia/Riyadh');
    tz.setLocalLocation(mekkahtimeZone);
    return tz.TZDateTime.from(moonLanding, mekkahtimeZone);
  }
}

// class CustomCity extends StatefulWidget {
//   CountryModel countries;
//   CustomCity({super.key, required this.countries});

//   @override
//   State<CustomCity> createState() => _CustomCityState(countries);
// }

// class _CustomCityState extends State<CustomCity> {
//   CountryModel? countries;
//   bool condition = false;
//   _CustomCityState(this.countries);
//   String? country;
//   TextEditingController city = TextEditingController();
//   CoutryRepo repo = CoutryRepo(URI: Constants.COUNTRY_URL);
//   List<String> citiesList = [];
//   Widget cities = Container();

//   @override
//   Widget build(BuildContext context) {
//     List<String> countriesString = [];
//     for (var element in countries!.data!) {
//       countriesString.add(element.country!);
//     }

//     List<String>? getCities() {
//       for (var element in countries!.data!) {
//         if (element.country == country) return element.cities;
//       }
//     }

//     return Container(
//       margin: EdgeInsets.fromLTRB(
//           Layouts.size25, Layouts.size25 * 2, Layouts.size25, Layouts.size25),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                   onPressed: (() {
//                     setState(() {
//                       return;
//                     });
//                   }),
//                   icon: Icon(
//                     Icons.cancel_outlined,
//                     size: Layouts.size35,
//                     color: Constants.alterColor,
//                   ))
//             ],
//           ),
//           DropdownSearch<String>(
//             popupProps: PopupProps.menu(
//               showSelectedItems: false,
//             ),
//             items: countriesString,
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 labelText: "Country",
//                 hintText: "Choose country",
//               ),
//             ),
//             onChanged: ((value) {
//               setState(() {
//                 country = value;
//                 condition = true;
//                 citiesList = getCities()!;
//               });
//             }),
//             selectedItem: "Choose country",
//           ),
//           DropdownSearch<String>(
//             enabled: condition,
//             popupProps: PopupProps.menu(
//               showSelectedItems: false,
//             ),
//             items: citiesList,
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 labelText: "City",
//                 hintText: "Choose city",
//               ),
//             ),
//             onChanged: print,
//             selectedItem: "Choose city",
//           ),
//           SizedBox(
//             height: Layouts.size10,
//           ),
//           cities,
//           Container(
//             height: 300,
//             width: 150,
//             padding: EdgeInsets.all(Layouts.size25),
//             margin: EdgeInsets.fromLTRB(
//                 Layouts.dayPaddingW,
//                 Layouts.size10 * 0.5,
//                 Layouts.dayPaddingW,
//                 Layouts.size10 * 0.5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(Layouts.size35),
//               color: Constants.mainColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
