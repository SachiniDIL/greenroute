import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisposalService {
  static const String baseUrl =
      "https://greenroute-7251d-default-rtdb.firebaseio.com/";

  // Show custom date picker
  static Future<DateTime?> showDatePickerCustom(
      BuildContext context, Color pickerPrimaryColor) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: pickerPrimaryColor, // Custom primary color
              onPrimary: Colors.white, // Text color when selected
              onSurface: Colors.black, // Default text color
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // Show custom time picker
  static Future<TimeOfDay?> showTimePickerCustom(
      BuildContext context, Color pickerPrimaryColor) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: pickerPrimaryColor, // Custom primary color
              onPrimary: Colors.white, // Text color when selected
              onSurface: Colors.black, // Default text color
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // Fetch truck drivers
  static Future<List<Map<String, dynamic>>> fetchTruckDrivers() async {
    final response = await http.get(Uri.parse("${baseUrl}truck_driver.json"));
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);

      if (decodedData is List) {
        return List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        return List<Map<String, dynamic>>.from(decodedData.values);
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load truck drivers');
    }
  }

  // Fetch all disposal history data
  static Future<List<Map<String, dynamic>>> fetchDisposalHistory() async {
    final response = await http.get(Uri.parse("${baseUrl}disposal.json"));
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);

      if (decodedData is List) {
        // Handle case where Firebase returns a List
        return List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        // Handle case where Firebase returns a Map
        return List<Map<String, dynamic>>.from(decodedData.values);
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load disposal history');
    }
  }

  // Fetch truck data
  static Future<List<Map<String, dynamic>>> fetchTruckData() async {
    final response = await http.get(Uri.parse("${baseUrl}truck.json"));
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);

      if (decodedData is List) {
        return List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        return List<Map<String, dynamic>>.from(decodedData.values);
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load truck data');
    }
  }

  // Fetch municipal councils
  static Future<List<Map<String, dynamic>>> fetchMunicipalCouncils() async {
    final response =
    await http.get(Uri.parse("${baseUrl}municipal_council.json"));
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);

      if (decodedData is List) {
        // Handle case where Firebase returns a List
        return List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        // Handle case where Firebase returns a Map
        return List<Map<String, dynamic>>.from(decodedData.values);
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load municipal councils');
    }
  }


  // Fetch truck drivers and trucks filtered by municipal council ID
  static Future<Map<String, List<Map<String, dynamic>>>>
  fetchTruckDriversAndTrucks(String councilId) async {
    final truckDriverResponse = await http.get(Uri.parse(
        "${baseUrl}truck_driver.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));
    final truckResponse = await http.get(Uri.parse(
        "${baseUrl}truck.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));

    if (truckDriverResponse.statusCode == 200 &&
        truckResponse.statusCode == 200) {
      dynamic truckDriversDecoded = json.decode(truckDriverResponse.body);
      dynamic trucksDecoded = json.decode(truckResponse.body);

      List<Map<String, dynamic>> truckDrivers = truckDriversDecoded is List
          ? List<Map<String, dynamic>>.from(truckDriversDecoded)
          : List<Map<String, dynamic>>.from(truckDriversDecoded.values);

      List<Map<String, dynamic>> trucks = trucksDecoded is List
          ? List<Map<String, dynamic>>.from(trucksDecoded)
          : List<Map<String, dynamic>>.from(trucksDecoded.values);

      return {'truckDrivers': truckDrivers, 'trucks': trucks};
    } else {
      throw Exception('Failed to load truck drivers and trucks');
    }
  }

  // Save Disposal Record
  static Future<void> saveDisposal(
      String? municipalCouncil,
      String? truckDriver,
      String? truckNumber,
      String date,
      String time,
      String disposalWeight) async {
    if (municipalCouncil == null || truckDriver == null || truckNumber == null) {
      throw Exception('Required fields are missing');
    }

    double? weight;
    try {
      weight = double.parse(disposalWeight);
    } catch (e) {
      throw Exception('Disposal weight is not a valid number');
    }

    final response = await http.get(Uri.parse("${baseUrl}disposal.json"));
    String nextDisposalId = _getNextDisposalId(response);

    final disposalData = {
      "disposal_id": nextDisposalId,
      "municipal_council": municipalCouncil,
      "truck_driver": truckDriver,
      "truck_number": truckNumber,
      "date": date,
      "time": time,
      "disposal_weight": weight.toString(),
    };

    final saveResponse = await http.post(
      Uri.parse("${baseUrl}disposal.json"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(disposalData),
    );

    if (saveResponse.statusCode != 200 && saveResponse.statusCode != 201) {
      throw Exception('Failed to save disposal');
    }
  }


  // Helper function to calculate the next disposal ID
  static String _getNextDisposalId(http.Response response) {
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);
      if (decodedData.isEmpty) {
        return 'DIS001';
      } else {
        List<String> disposalIds =
        (decodedData is Map ? decodedData.values : decodedData)
            .where((disposal) => disposal['disposal_id'] != null)
            .map<String>((disposal) => disposal['disposal_id'])
            .toList();

        disposalIds.sort();
        String maxDisposalId = disposalIds.last;
        int currentMaxNumber = int.parse(maxDisposalId.replaceAll('DIS', ''));
        int nextNumber = currentMaxNumber + 1;
        return 'DIS${nextNumber.toString().padLeft(3, '0')}';
      }
    } else {
      throw Exception('Failed to load existing disposals');
    }
  }
}
