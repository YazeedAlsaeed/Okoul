import 'dart:convert';
import 'package:okoul_project/api/country_model.dart';
import 'package:okoul_project/api/model.dart';
import 'package:http/http.dart' as http;

class CoutryRepo {
  String? URI;

  CoutryRepo({required this.URI});

  Future<CountryModel?> api_request() async {
    try {
      final response = await http.get(Uri.parse(URI!));
      final Map<String, dynamic> decoder = jsonDecode(response.body);
      CountryModel countries = CountryModel.fromJson(decoder);

      return countries;
    } catch (e) {
      print(e.toString());
    }
  }
}
