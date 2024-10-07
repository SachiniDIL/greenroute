import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisposalService {
  static Future<List<Map<String, dynamic>>> fetchMunicipalCouncils() async {
    final response = await http.get(Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/municipal_council.json"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load municipal councils');
    }
  }

  static Future<Map<String, List<Map<String, dynamic>>>> fetchTruckDriversAndTrucks(String councilId) async {
    final truckDriverResponse = await http.get(Uri.parse(
        "https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));
    final truckResponse = await http.get(Uri.parse(
        "https://greenroute-7251d-default-rtdb.firebaseio.com/truck.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));

    if (truckDriverResponse.statusCode == 200 && truckResponse.statusCode == 200) {
      List<Map<String, dynamic>> truckDrivers = List<Map<String, dynamic>>.from(json.decode(truckDriverResponse.body).values);
      List<Map<String, dynamic>> trucks = List<Map<String, dynamic>>.from(json.decode(truckResponse.body).values);
      return {'truckDrivers': truckDrivers, 'trucks': trucks};
    } else {
      throw Exception('Failed to load truck drivers and trucks');
    }
  }

  static Future<void> saveDisposal(
      String? municipalCouncil,
      String? truckDriver,
      String? truckNumber,
      String date,
      String time,
      String disposalWeight) async {

    // Fetch the list of disposals to find the next disposal ID
    final disposalResponse = await http.get(
      Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/disposal.json"),
    );

    String nextDisposalId;

    if (disposalResponse.statusCode == 200) {
      Map<String, dynamic> disposals = json.decode(disposalResponse.body);

      // If no disposals exist, start with DIS001
      if (disposals.isEmpty) {
        nextDisposalId = 'DIS001';
      } else {
        // Extract disposal IDs and determine the next ID
        List<String> disposalIds = disposals.values
            .where((disposal) => disposal['disposal_id'] != null)
            .map<String>((disposal) => disposal['disposal_id'])
            .toList();

        disposalIds.sort();
        String maxDisposalId = disposalIds.last;

        int currentMaxNumber = int.parse(maxDisposalId.replaceAll('DIS', ''));
        int nextNumber = currentMaxNumber + 1;

        nextDisposalId = 'DIS${nextNumber.toString().padLeft(3, '0')}';
      }
    } else {
      throw Exception('Failed to load existing disposals');
    }

    // Create the disposal data with the new disposal ID
    final disposalData = {
      "disposal_id": nextDisposalId,
      "municipal_council": municipalCouncil,
      "truck_driver": truckDriver,
      "truck_number": truckNumber,
      "date": date,
      "time": time,
      "disposal_weight": double.parse(disposalWeight),
    };

    // Save the new disposal record to Firebase
    final response = await http.post(
      Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/disposal.json"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(disposalData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save disposal');
    }
  }


  static Future<DateTime?> showDatePickerCustom(BuildContext context, Color pickerPrimaryColor) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: pickerPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> showTimePickerCustom(BuildContext context, Color pickerPrimaryColor) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: pickerPrimaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
