import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<void> saveFormData(
      String eventName,
      String requestDate,
      String location,
      String plasticBags,
      String paperBags,
      String foodWasteBags,
      String additionalNote,
      bool plasticSelected,
      bool paperSelected,
      bool foodWasteSelected,
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('event_name', eventName);
    await prefs.setString('request_date', requestDate);
    await prefs.setString('location', location);
    await prefs.setString('plastic_bags', plasticBags);
    await prefs.setString('paper_bags', paperBags);
    await prefs.setString('food_waste_bags', foodWasteBags);
    await prefs.setString('additional_note', additionalNote);
    await prefs.setBool('plastic_selected', plasticSelected);
    await prefs.setBool('paper_selected', paperSelected);
    await prefs.setBool('food_waste_selected', foodWasteSelected);
  }

  static Future<void> loadFormData({
    required TextEditingController eventNameController,
    required TextEditingController requestDateController,
    required TextEditingController locationController,
    required TextEditingController plasticBagsController,
    required TextEditingController paperBagsController,
    required TextEditingController foodWasteBagsController,
    required TextEditingController additionalNoteController,
    required ValueChanged<bool> plasticSelected,
    required ValueChanged<bool> paperSelected,
    required ValueChanged<bool> foodWasteSelected,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    eventNameController.text = prefs.getString('event_name') ?? '';
    requestDateController.text = prefs.getString('request_date') ?? '';
    locationController.text = prefs.getString('location') ?? '';
    plasticBagsController.text = prefs.getString('plastic_bags') ?? '';
    paperBagsController.text = prefs.getString('paper_bags') ?? '';
    foodWasteBagsController.text = prefs.getString('food_waste_bags') ?? '';
    additionalNoteController.text = prefs.getString('additional_note') ?? '';
    plasticSelected(prefs.getBool('plastic_selected') ?? false);
    paperSelected(prefs.getBool('paper_selected') ?? false);
    foodWasteSelected(prefs.getBool('food_waste_selected') ?? false);
  }

  static Future<void> clearFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('event_name');
    await prefs.remove('request_date');
    await prefs.remove('location');
    await prefs.remove('plastic_bags');
    await prefs.remove('paper_bags');
    await prefs.remove('food_waste_bags');
    await prefs.remove('additional_note');
    await prefs.remove('plastic_selected');
    await prefs.remove('paper_selected');
    await prefs.remove('food_waste_selected');
  }
}
