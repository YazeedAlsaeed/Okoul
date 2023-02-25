import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:okoul_project/api/country_model.dart' as Country;
import 'package:okoul_project/api/country_repo.dart';
import 'package:okoul_project/pages/main_page.dart';
import 'package:okoul_project/pages/stared_page.dart';
import 'package:okoul_project/pages/theker_page.dart';
import 'package:okoul_project/utils/constants.dart';
import 'package:okoul_project/utils/layouts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:okoul_project/icons/icons.dart';
import 'package:okoul_project/pages/test.dart';
import 'package:intl/intl.dart';
import 'package:okoul_project/api/constructor.dart';
import 'package:okoul_project/api/model.dart';
import 'package:okoul_project/api/repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'pages/entry_page.dart';
import 'pages/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String usedColor = "86D5C4";
  String closedColor = "CCCDCD";
  String colorBook = "CCCDCD";
  String colorHome = "86D5C4";
  String colorDaimond = "CCCDCD";

  Country.CountryModel dummy =
      Country.CountryModel(error: false, msg: "OK", data: [
    Country.Data(iso2: "AA", iso3: "AA", country: "AA", cities: ["AA"])
  ]);

  String? city;
  String? country;
  TimerModel? model;
  Timings? timing;
  Date? date;
  Country.CountryModel? countries;

  int index = 0;
  List<Widget>? pages;
  PageController? pageController;

  var now = new DateTime.now();
  var formatterDate = new DateFormat('d-MM-yyyy');
  var formatterDay = new DateFormat('EEEE');
  var formatterDayNumber = new DateFormat('d');

  @override
  void initState() {
    super.initState();
    _getCountry();
    pages = [
      EntryPage(),
      Container(),
      ThekerPage(),
      StaredPage(),
    ];
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  void _getCountry() async {
    CoutryRepo repo = CoutryRepo(URI: Constants.COUNTRY_URL);
    try {
      countries = await repo.api_request();
      setState(() {
        // pages![1] = MainPage(
        //   city: city,
        //   country: country,
        //   model: model,
        //   timing: timing,
        //   date: date,
        //   now: now,
        //   countries: countries!,
        // );
        _getCurrentPosition();
      });
    } catch (e) {
      print(e);
    }
  }

  void _getModel() async {
    Construct construct = Construct(city: city, country: country, date: now);
    Repo repo = Repo(URI: construct.getFullUri());

    try {
      model = await repo.api_request();

      setState(() {
        model = model;

        for (int i = 0; i < model!.data.length; i++) {
          if (model!.data[i].date.gregorian.day ==
              formatterDayNumber.format(now).toString().padLeft(2, "0")) {
            timing = model!.data[i].timings;
            date = model!.data[i].date;
          }
          pages![1] = MainPage(
            city: city,
            country: country,
            model: model,
            timing: timing,
            date: date,
            now: now,
            countries: countries,
          );
          if (index == 0) pageController!.jumpToPage(1);
          index = 1;
        }
      });
    } catch (e) {
      setState(() {
        country = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String book =
        '''<svg width="${Layouts.size45}" height="${Layouts.size45}" viewBox="0 0 40 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1 6H12.25C14.2391 6 16.1468 6.79018 17.5533 8.1967C18.9598 9.60322 19.75 11.5109 19.75 13.5V39.75C19.75 38.2582 19.1574 36.8274 18.1025 35.7725C17.0476 34.7176 15.6168 34.125 14.125 34.125H1V6Z" stroke="#$colorBook" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M38.5 6H27.25C25.2609 6 23.3532 6.79018 21.9467 8.1967C20.5402 9.60322 19.75 11.5109 19.75 13.5V39.75C19.75 38.2582 20.3426 36.8274 21.3975 35.7725C22.4524 34.7176 23.8832 34.125 25.375 34.125H38.5V6Z" stroke="#$colorBook" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

    String daimond =
        '''<svg width="${Layouts.size75}" height="${Layouts.size75}" viewBox="0 0 82 80" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="-7.17157" y="38.9117" width="68" height="68" rx="23" transform="rotate(-45 -7.17157 38.9117)" fill="#$colorDaimond" stroke="#F1F2F4" stroke-width="4"/>
</svg>''';

    String home =
        '''<svg width="${Layouts.size45}" height="${Layouts.size45}" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M5.625 16.875L22.5 3.75L39.375 16.875V37.5C39.375 38.4946 38.9799 39.4484 38.2766 40.1516C37.5734 40.8549 36.6196 41.25 35.625 41.25H9.375C8.38044 41.25 7.42661 40.8549 6.72335 40.1516C6.02009 39.4484 5.625 38.4946 5.625 37.5V16.875Z" stroke="#$colorHome" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M16.875 41.25V22.5H28.125V41.25" stroke="#$colorHome" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: PageView(
        controller: pageController,
        children: pages!,
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: Layouts.size35),
            child: SvgPicture.string(
              appIcons.line,
            ),
          ),
          Container(
            width: double.infinity,
            height: Layouts.size45 * 2,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 3;
                        colorHome = closedColor;
                        colorBook = closedColor;
                        colorDaimond = usedColor;
                        pageController!.jumpToPage(index);
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: SvgPicture.string(
                            daimond,
                          ),
                        ),
                        Container(
                          child: SvgPicture.string(
                            appIcons.star,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: Layouts.size25 * 2,
            margin: EdgeInsets.fromLTRB(Layouts.screenWidth / 8, Layouts.size45,
                Layouts.screenWidth / 8, Layouts.size25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 1;
                      colorHome = usedColor;
                      colorBook = closedColor;
                      colorDaimond = closedColor;
                      pageController!.jumpToPage(index);
                    });
                  },
                  child: Container(
                    child: SvgPicture.string(
                      home,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      index = 2;
                      colorHome = closedColor;
                      colorBook = usedColor;
                      colorDaimond = closedColor;
                      pageController!.jumpToPage(index);
                    });
                  },
                  child: Container(
                    child: SvgPicture.string(book),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
