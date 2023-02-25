import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:okoul_project/utils/constants.dart';
import 'package:okoul_project/utils/layouts.dart';
import 'package:okoul_project/utils/main_text.dart';

import 'package:shimmer/shimmer.dart';
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
import 'package:okoul_project/utils/second_text.dart';

class StaredPage extends StatefulWidget {
  const StaredPage({super.key});

  @override
  State<StaredPage> createState() => _StaredPageState();
}

class _StaredPageState extends State<StaredPage> {
  TimerModel? model;
  Date? date2;
  String starred = "";
  List<String> starredList = [];
  int indexGeneral = 0;
  int indexGeneral2 = 0;
  DateTime NOW = new DateTime.now();
  String? CITY;
  String? COUNTRY;
  Timings? timing2;
  var formatterDayNumber = new DateFormat('d');

  //bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    File('/Users/yzd/Developer/flutter_apps/okoul_project/lib/utils/staredCities.txt')
        .readAsString()
        .then((String contents) {
      starred = contents;
      try {
        starredList = starred.substring(1, starred.length - 1).split(", ");
        setState(() {
          if (starredList.length == 0) {
            indexGeneral = 0;
          }
          if (starredList.length > 0) {
            indexGeneral = 1;
          }
        });
      } catch (e) {
        print(e);
      }
    });

    return IndexedStack(
      index: indexGeneral2,
      children: [
        IndexedStack(
          index: indexGeneral,
          children: [
            Container(
              alignment: Alignment.center,
              color: Constants.backgroundColor,
              child: MainText(
                text: "No Cities Found yet",
                size: Layouts.size25,
              ),
            ),
            ListView.builder(
                shrinkWrap: false,
                itemCount: starredList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        timing2 = null;
                        _getModel2();
                        indexGeneral2 = 1;
                        CITY = starredList[index].split(";")[0];
                        COUNTRY = starredList[index].split(";")[1];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Layouts.size45),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 5),
                              blurRadius: 20,
                              spreadRadius: -20),
                        ],
                      ),
                      margin: EdgeInsets.all(Layouts.size15),
                      padding: EdgeInsets.fromLTRB(Layouts.size45,
                          Layouts.size45, Layouts.size45, Layouts.size45),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              child: MainText(
                                size: Layouts.size25,
                                text: starredList.length <= index
                                    ? "None"
                                    : "${starredList[index].split(";")[0]} - ${starredList[index].split(";")[1]}",
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                starredList.removeAt(index);
                                if (starredList.length == 0) {
                                  await File(
                                          '/Users/yzd/Developer/flutter_apps/okoul_project/lib/utils/staredCities.txt')
                                      .writeAsString("");
                                } else {
                                  await File(
                                          '/Users/yzd/Developer/flutter_apps/okoul_project/lib/utils/staredCities.txt')
                                      .writeAsString(starredList.toString());
                                }
                                setState(() {
                                  if (starredList.length == 0) indexGeneral = 0;
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Constants.alterColor,
                                size: Layouts.size35,
                              ))
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: Layouts.size75),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                    Layouts.size75, 0, Layouts.size35, Layouts.size75),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          child: timing2 == null
                              ? Shimmer.fromColors(
                                  baseColor: Color.fromARGB(255, 213, 214, 214),
                                  highlightColor:
                                      Color.fromARGB(255, 240, 240, 240),
                                  child: Container(
                                    height: Layouts.size35,
                                    width: Layouts.size45 * 2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : MainText(text: CITY!),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            indexGeneral2 = 0;
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: Layouts.size35,
                            color: Constants.alterColor,
                          ))
                    ]),
              ),
              Container(
                padding: EdgeInsets.all(Layouts.size25),
                margin: EdgeInsets.fromLTRB(Layouts.dayPaddingW, Layouts.size15,
                    Layouts.dayPaddingW, 0),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Layouts.size10, 0, Layouts.size10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Fajr)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Sunrise)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Dhuhr)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Asr)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Maghrib)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Layouts.size10),
                                        color: Constants.mainColor),
                                  ),
                                )
                              : SecondText(text: getTime(timing2!.Isha)),
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
            ],
          ),
        ),
      ],
    );
  }

  DateTime _getPSTTime(String date, String time) {
    tz.initializeTimeZones();
    final moonLanding = DateTime.parse('$date ${time}');
    final mekkahtimeZone = tz.getLocation('Asia/Riyadh');
    tz.setLocalLocation(mekkahtimeZone);
    return tz.TZDateTime.from(moonLanding, mekkahtimeZone);
  }

  String getTime(
    String prayer,
  ) {
    String day = date2!.gregorian.day;
    String month = date2!.gregorian.month.number.toString();
    String year = date2!.gregorian.year;
    String time = prayer.substring(0, 5);

    DateTime fullDate = _getPSTTime(
        "$year-${month.toString().padLeft(2, "0")}-$day", "$time:00");

    var formatterPrayer = new DateFormat.jm();

    return formatterPrayer.format(fullDate);
  }

  void _getModel2() async {
    Construct construct = Construct(city: CITY, country: COUNTRY, date: NOW);
    Repo repo = Repo(URI: construct.getFullUri());

    try {
      model = await repo.api_request();

      setState(() {
        model = model;

        for (int i = 0; i < model!.data.length; i++) {
          if (model!.data[i].date.gregorian.day ==
              formatterDayNumber.format(NOW).toString().padLeft(2, "0")) {
            timing2 = model!.data[i].timings;
            date2 = model!.data[i].date;
          }
        }
      });
    } catch (e) {
      setState(() {
        COUNTRY = e.toString();
      });
    }
  }
}
