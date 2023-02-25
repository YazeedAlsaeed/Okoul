import 'package:intl/intl.dart';
import 'package:okoul_project/api/model.dart';
import 'package:okoul_project/utils/constants.dart';

class Construct {
  DateTime? date;
  String? country;
  String? city;
  Construct({required this.date, required this.country, required this.city});

  String getFullUri() {
    String uri = Constants.API_URL;
    String post = "?city=$city&country=$country&method=4";
    DateFormat yearFormat = new DateFormat('y');
    DateFormat monthFormat = new DateFormat('M');
    String year = yearFormat.format(date!);
    String month = monthFormat.format(date!);

    return "$uri$year/$month$post";
  }
}
