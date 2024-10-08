import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationsRepos {
  //GET LOCATIONS
  static Future fetchLocationsList() async {
    try {
      final response = await http.get(
        // Uri.parse('http://localhost:9999/pick-location/api/v1/get-loc/filter')); //to get all locations
        Uri.parse(
            'http://localhost:9999/pick-location/api/v1/get-loc/flag/0')); //to get all locations with flag 0

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // debugPrint(
      //     "ORIGINAL API RESPONSE-BODY: " + utf8.decode(response.bodyBytes));
      // debugPrint(json
      //     .decode(utf8.decode(response.bodyBytes))[0]['address']
      //     .toString());
      String decodedResponse = utf8.decode(response.bodyBytes);
      // debugPrint(decodedResponse);

      return json.decode(decodedResponse); //update for reading arabic in json
      // return json.decode(response.body); //original for utf8 encoding in json
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load LocationsList');
    }
    }catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
// UPDATE FLAG
  static Future updateLocations(int id, String latitude, String longitude, String realAddress) async {
    try {
         final response = await http.put(
        Uri.parse(
            'http://localhost:9999/pick-location/api/v1/get-loc/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'flag': '1',  //to update flag to 1
          'latitude': latitude,
          'longitude': longitude,
          'real_address': realAddress,
        }));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update flag.');
    }
  } catch (e) {
    debugPrint(e.toString());
    throw Exception(e.toString());
  }
    }
  }





// import 'dart:convert'; // For UTF-8 decoding
// import 'package:http/http.dart' as http;

// Future<void> fetchData() async {
//   final response = await http.get(Uri.parse('https://your-api-url.com'));

//   // Decode the response as UTF-8
//   String decodedResponse = utf8.decode(response.bodyBytes);

//   print(decodedResponse);  // Now it should display the correct Arabic text
// }
