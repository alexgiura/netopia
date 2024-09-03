import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/county_model.dart';

class CountyService {
  final String apiCountyUrl = 'https://roloca.coldfuse.io/judete';

  Future fetchCountyList() async {
    final response = await http.get(Uri.parse(apiCountyUrl));

    if (response.statusCode == 200) {
      // Parsează răspunsul JSON într-o listă de hărți
      List<dynamic> data = jsonDecode(response.body);

      // Transformă fiecare hartă într-un obiect County
      return data.map((json) => County.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load counties');
    }
  }
}
