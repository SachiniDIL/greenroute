import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/common/widgets/button_large.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/common/widgets/custom_text_field.dart';
import 'package:greenroute/disposal_officer/screens/do_home.dart';

import '../services/disposal_service.dart';

class NewDisposal extends StatefulWidget {
  const NewDisposal({super.key});

  @override
  _NewDisposalState createState() => _NewDisposalState();
}

class _NewDisposalState extends State<NewDisposal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController disposalWeightController = TextEditingController();

  List<Map<String, dynamic>> municipalList = [];
  List<Map<String, dynamic>> truckDriverList = [];
  List<Map<String, dynamic>> truckList = [];
  String? selectedMunicipalCouncil;
  String? selectedTruckDriver;
  String? selectedTruckNumber;
  bool isLoadingTrucksAndDrivers = false;

  final Color pickerPrimaryColor = AppColors.primaryColor;

  @override
  void initState() {
    super.initState();
    _fetchMunicipalCouncils();
  }

  Future<void> _fetchMunicipalCouncils() async {
    try {
      municipalList = await DisposalService.fetchMunicipalCouncils();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchTruckDriversAndTrucks(String councilId) async {
    setState(() {
      isLoadingTrucksAndDrivers = true;
    });

    try {
      var result = await DisposalService.fetchTruckDriversAndTrucks(councilId);

      // Use null-aware operator ?? to provide an empty list if null
      truckDriverList = result['truckDrivers'] ?? [];
      truckList = result['trucks'] ?? [];
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoadingTrucksAndDrivers = false;
      });
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
                    const Text(
                      "New Disposal",
                      style: AppTextStyles.topic,
                    ),
                    const SizedBox(height: 20),

                    // Municipal Council Dropdown
                    _buildDropdown(
                      "Municipal Council",
                      "Select Municipal Council",
                      selectedMunicipalCouncil,
                      municipalList.map((municipal) {
                        return DropdownMenuItem<String>(
                          value: municipal["council_id"].toString(),
                          child: Text(municipal["council_name"]),
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
                      truckDriverList.map((driver) {
                        return DropdownMenuItem<String>(
                          value: driver["emp_id"].toString(),
                          child: Text(driver["first_name"] + " " + driver["last_name"]),
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
                      truckList.map((truck) {
                        return DropdownMenuItem<String>(
                          value: truck["truck_id"].toString(), // Keep this for the value
                          child: Text(truck["truck_number"]),   // Change this to display truck_number
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
                        DateTime? pickedDate = await DisposalService.showDatePickerCustom(context, pickerPrimaryColor);
                        if (pickedDate != null) {
                          dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
                        TimeOfDay? pickedTime = await DisposalService.showTimePickerCustom(context, pickerPrimaryColor);
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
                      validator: (value) => value == null || value.isEmpty ? 'Please enter the disposal weight' : null,
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
                                await DisposalService.saveDisposal(
                                  selectedMunicipalCouncil,
                                  selectedTruckDriver,
                                  selectedTruckNumber,
                                  dateController.text,
                                  timeController.text,
                                  disposalWeightController.text,
                                );
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Disposal saved successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Navigate to the DOHome screen after a short delay
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => DOHome()),
                                );
                              } catch (e) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to save disposal: $e"),
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

  Widget _buildDropdown(String label, String hint, String? value, List<DropdownMenuItem<String>> items, Function(String?) onChanged, {bool isLoadingTrucksAndDrivers = false}) {
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
          disabledHint: isLoadingTrucksAndDrivers ? const Text("Loading...") : null,
        ),
      ],
    );
  }
}
