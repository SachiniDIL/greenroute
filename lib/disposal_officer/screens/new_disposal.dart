import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/disposal_officer/screens/do_home.dart';

class NewDisposal extends StatefulWidget {
  const NewDisposal({super.key});

  @override
  _NewDisposalState createState() => _NewDisposalState();
}

class _NewDisposalState extends State<NewDisposal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController disposalWeightController =
      TextEditingController();

  List<Map<String, dynamic>> municipalList = [];
  List<Map<String, dynamic>> truckDriverList = [];
  List<Map<String, dynamic>> truckList = [];
  String? selectedMunicipalCouncil;
  String? selectedTruckDriver;
  String? selectedTruckNumber;
  bool isLoadingTrucksAndDrivers = false;

  final Color pickerPrimaryColor =
      AppColors.primaryColor; // Custom color for pickers

  @override
  void initState() {
    super.initState();
    _fetchMunicipalCouncils();
  }

  Future<void> _fetchMunicipalCouncils() async {
    try {
      final response = await http.get(Uri.parse(
          "https://greenroute-7251d-default-rtdb.firebaseio.com/municipal_council.json"));
      if (response.statusCode == 200) {
        dynamic decodedData = json.decode(response.body);
        if (decodedData is List) {
          municipalList = List<Map<String, dynamic>>.from(decodedData);
        } else if (decodedData is Map) {
          municipalList = List<Map<String, dynamic>>.from(decodedData.values);
        }
      } else {
        throw Exception('Failed to load municipal councils');
      }
      setState(() {
        selectedMunicipalCouncil = null;
      });
    } catch (e) {
      print('Error fetching municipal councils: $e');
    }
  }

  Future<void> _fetchTruckDriversAndTrucks(String councilId) async {
    setState(() {
      isLoadingTrucksAndDrivers = true;
    });

    try {
      final truckDriverResponse = await http.get(Uri.parse(
          "https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));
      final truckResponse = await http.get(Uri.parse(
          "https://greenroute-7251d-default-rtdb.firebaseio.com/truck.json?orderBy=%22municipal_council_id%22&equalTo=%22$councilId%22"));

      if (truckDriverResponse.statusCode == 200 &&
          truckResponse.statusCode == 200) {
        dynamic truckDriversDecoded = json.decode(truckDriverResponse.body);
        dynamic trucksDecoded = json.decode(truckResponse.body);

        setState(() {
          truckDriverList = truckDriversDecoded is Map
              ? List<Map<String, dynamic>>.from(truckDriversDecoded.values)
              : List<Map<String, dynamic>>.from(truckDriversDecoded);

          truckList = trucksDecoded is Map
              ? List<Map<String, dynamic>>.from(trucksDecoded.values)
              : List<Map<String, dynamic>>.from(trucksDecoded);
        });

        selectedTruckDriver = null;
        selectedTruckNumber = null;
      } else {
        throw Exception('Failed to load truck drivers or trucks');
      }
    } catch (e) {
      print('Error fetching truck drivers and trucks: $e');
    } finally {
      setState(() {
        isLoadingTrucksAndDrivers = false;
      });
    }
  }

  Future<void> _saveDisposal(
      String? municipalCouncil,
      String? truckDriver,
      String? truckNumber,
      String date,
      String time,
      String disposalWeight) async {
    try {
      if (municipalCouncil == null ||
          truckDriver == null ||
          truckNumber == null) {
        throw Exception('Required fields are missing');
      }

      double weight = double.parse(disposalWeight);

      // Fetch the next disposal ID from Firebase
      final response = await http.get(Uri.parse(
          "https://greenroute-7251d-default-rtdb.firebaseio.com/disposal.json"));

      String nextDisposalId = _getNextDisposalId(response);

      // Prepare the disposal data
      final disposalData = {
        "disposal_id": nextDisposalId,
        "municipal_council": municipalCouncil,
        "truck_driver": truckDriver,
        "truck_number": truckNumber,
        "date": date,
        "time": time,
        "disposal_weight": weight.toString(),
      };

      // Save the new disposal record
      final saveResponse = await http.post(
        Uri.parse(
            "https://greenroute-7251d-default-rtdb.firebaseio.com/disposal.json"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(disposalData),
      );

      if (saveResponse.statusCode != 200 && saveResponse.statusCode != 201) {
        throw Exception('Failed to save disposal');
      }
    } catch (e) {
      print('Error saving disposal: $e');
      rethrow;
    }
  }

  String _getNextDisposalId(http.Response response) {
    if (response.statusCode == 200) {
      dynamic decodedData = json.decode(response.body);
      if (decodedData.isEmpty) {
        return 'DIS001';
      } else {
        List<String> disposalIds = (decodedData as Map)
            .values
            .where((disposal) => disposal['disposal_id'] != null)
            .map<String>((disposal) => disposal['disposal_id'].toString())
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

  InputDecoration dropdownInputDecoration(String hintText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.buttonColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      hintText: hintText,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      isDense: true, // Ensures the height is compact and consistent
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    disposalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BackArrow(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("New Disposal", style: AppTextStyles.topic),
                    const SizedBox(height: 20),

                    // Municipal Council Dropdown
                    _buildDropdown(
                      "Municipal Council",
                      "Select Municipal Council",
                      selectedMunicipalCouncil,
                      municipalList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['council_id'].toString(),
                          child: Text(item['council_name'] ?? 'Unknown'),
                        );
                      }).toList(),
                      (value) {
                        setState(() {
                          selectedMunicipalCouncil = value;
                          selectedTruckDriver = null;
                          selectedTruckNumber = null;
                          truckDriverList.clear();
                          truckList.clear();
                          _fetchTruckDriversAndTrucks(value!);
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Truck Driver Dropdown
                    _buildDropdown(
                      "Truck Driver",
                      "Select Truck Driver",
                      selectedTruckDriver,
                      truckDriverList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['emp_id'].toString(),
                          child: Text(
                              "${item['first_name']} ${item['last_name']}"),
                        );
                      }).toList(),
                      (value) => setState(() => selectedTruckDriver = value),
                      isLoadingTrucksAndDrivers: isLoadingTrucksAndDrivers,
                    ),

                    const SizedBox(height: 20),

                    // Truck Number Dropdown
                    _buildDropdown(
                      "Truck Number",
                      "Select Truck Number",
                      selectedTruckNumber,
                      truckList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item['truck_id'].toString(),
                          child: Text(item['truck_number'] ?? 'Unknown'),
                        );
                      }).toList(),
                      (value) => setState(() => selectedTruckNumber = value),
                      isLoadingTrucksAndDrivers: isLoadingTrucksAndDrivers,
                    ),

                    const SizedBox(height: 20),

                    // Date Picker
                    CustomTextField(
                      controller: dateController,
                      label: "Date",
                      hint: "Select Date",
                      suffixIcon: Icons.calendar_today,
                      onSuffixTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: pickerPrimaryColor,
                                  // Custom primary color
                                  onPrimary: Colors.white,
                                  // Text color when selected
                                  onSurface: Colors.black, // Default text color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          dateController.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Time Picker
                    CustomTextField(
                      controller: timeController,
                      label: "Time",
                      hint: "Select Time",
                      suffixIcon: Icons.access_time,
                      onSuffixTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: pickerPrimaryColor,
                                  // Custom primary color
                                  onPrimary: Colors.white,
                                  // Text color when selected
                                  onSurface: Colors.black, // Default text color
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          timeController.text = pickedTime.format(context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // Disposal Weight
                    CustomTextField(
                      controller: disposalWeightController,
                      label: "Disposal Weight",
                      hint: "Enter weight",
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter the disposal weight'
                          : null,
                    ),
                    const SizedBox(height: 50),

                    // Submit Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BtnLarge(
                          buttonText: "Submit",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await _saveDisposal(
                                  selectedMunicipalCouncil,
                                  selectedTruckDriver,
                                  selectedTruckNumber,
                                  dateController.text,
                                  timeController.text,
                                  disposalWeightController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Disposal saved successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Navigate to the DOHome screen
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DOHome()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Failed to save disposal: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    String? value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged, {
    bool isLoadingTrucksAndDrivers = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.formText),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: dropdownInputDecoration(hint),
          value: value,
          items: items,
          onChanged: isLoadingTrucksAndDrivers ? null : onChanged,
          validator: (value) => value == null ? 'Please select $label' : null,
          disabledHint:
              isLoadingTrucksAndDrivers ? const Text("Loading...") : null,
        ),
      ],
    );
  }
}
