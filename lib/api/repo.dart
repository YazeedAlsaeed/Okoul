import 'dart:convert';
import 'package:okoul_project/api/model.dart';
import 'package:http/http.dart' as http;

class Repo {
  String? URI;

  Repo({required this.URI});

  Future<TimerModel?> api_request() async {
    try {
      final response = await http.get(Uri.parse(URI!));
      final Map<String, dynamic> decoder = jsonDecode(response.body);

      TimerModel model = TimerModel.fromJson(decoder);
      return model;
    } catch (e) {
      print(e.toString());
    }
  }
}
