import 'package:flutter/material.dart';
import 'package:greenroute/disposal_officer/screens/disposal_history_clicked.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For parsing and formatting dates
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/theme.dart';

class DisposalHistory extends StatefulWidget {
  const DisposalHistory({super.key});

  @override
  _DisposalHistoryState createState() => _DisposalHistoryState();
}

class _DisposalHistoryState extends State<DisposalHistory> {
  // List to store disposal history data
  List<Map<String, String>> disposalHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDisposalHistory();
  }

  // Function to fetch disposal data from Firebase
  Future<void> _fetchDisposalHistory() async {
    try {
      // Fetch disposals, trucks, truck drivers, and municipal council data
      final disposalResponse = await http.get(
        Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/disposal.json"),
      );
      final truckResponse = await http.get(
        Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/truck.json"),
      );
      final driverResponse = await http.get(
        Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/truck_driver.json"),
      );
      final councilResponse = await http.get(
        Uri.parse("https://greenroute-7251d-default-rtdb.firebaseio.com/municipal_council.json"),
      );

      if (disposalResponse.statusCode == 200 &&
          truckResponse.statusCode == 200 &&
          driverResponse.statusCode == 200 &&
          councilResponse.statusCode == 200) {
        // Parse responses
        dynamic disposalsData = json.decode(disposalResponse.body);
        dynamic trucksData = json.decode(truckResponse.body);
        dynamic driversData = json.decode(driverResponse.body);
        dynamic councilsData = json.decode(councilResponse.body);

        List<Map<String, String>> fetchedData = [];
        final dateFormat = DateFormat('yyyy-MM-dd');

        // Check if `disposalsData` is a List or a Map and handle accordingly
        if (disposalsData is List) {
          for (var disposal in disposalsData) {
            // Handle each disposal item
            _processDisposalItem(
              disposal,
              trucksData,
              driversData,
              councilsData,
              fetchedData,
              dateFormat,
            );
          }
        } else if (disposalsData is Map) {
          disposalsData.forEach((key, disposal) {
            // Handle each disposal item
            _processDisposalItem(
              disposal,
              trucksData,
              driversData,
              councilsData,
              fetchedData,
              dateFormat,
            );
          });
        }

        // Sort the data by date and time
        fetchedData.sort((a, b) {
          try {
            DateTime dateA = dateFormat.parse(a['date']!);
            DateTime dateB = dateFormat.parse(b['date']!);
            if (dateA.compareTo(dateB) != 0) {
              return dateA.compareTo(dateB); // Compare by date
            } else {
              TimeOfDay timeA = TimeOfDay(
                  hour: int.parse(a['time']!.split(":")[0]),
                  minute: int.parse(a['time']!.split(":")[1]));
              TimeOfDay timeB = TimeOfDay(
                  hour: int.parse(b['time']!.split(":")[0]),
                  minute: int.parse(b['time']!.split(":")[1]));
              return timeA.hour.compareTo(timeB.hour) != 0
                  ? timeA.hour.compareTo(timeB.hour)
                  : timeA.minute.compareTo(timeB.minute); // Compare by time
            }
          } catch (e) {
            return 0; // Handle parsing errors, treat as equal
          }
        });

        // Reverse to show the latest data first
        fetchedData = fetchedData.reversed.toList();

        setState(() {
          disposalHistory = fetchedData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to process each disposal item
  void _processDisposalItem(
      dynamic disposal,
      dynamic trucksData,
      dynamic driversData,
      dynamic councilsData,
      List<Map<String, String>> fetchedData,
      DateFormat dateFormat,
      ) {
    // Find truck number by iterating over the list
    String truckNumber = 'Unknown';
    if (trucksData is List) {
      for (var truck in trucksData) {
        if (truck['truck_id'] == disposal['truck_number']) {
          truckNumber = truck['truck_number'];
          break;
        }
      }
    }

    // Find truck driver name by iterating over the list
    String truckDriver = 'Unknown';
    if (driversData is List) {
      for (var driver in driversData) {
        if (driver['emp_id'] == disposal['truck_driver']) {
          truckDriver = driver['first_name'] + ' ' + driver['last_name'];
          break;
        }
      }
    }

    // Find municipal council by iterating over the list
    String councilName = 'Unknown';
    if (councilsData is List) {
      for (var council in councilsData) {
        if (council['council_id'] == disposal['municipal_council']) {
          councilName = council['council_name'];
          break;
        }
      }
    }

    fetchedData.add({
      'truckId': disposal['truck_number'] ?? 'Unknown',
      'truckNumber': truckNumber,
      'truckDriver': truckDriver,
      'municipalCouncil': councilName,
      'date': disposal['date'] ?? 'Unknown',
      'time': disposal['time'] ?? 'Unknown',
      'weight': disposal['disposal_weight'].toString() ?? 'Unknown',
    });
  }

  // Function to handle navigation when an item is clicked
  void _navigateToDetails(Map<String, String?> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisposalHistoryClicked(
          truckId: item['truckId'] ?? 'N/A', // Use default value if null
          truckNumber: item['truckNumber'] ?? 'N/A', // Use default value if null
          truckDriver: item['truckDriver'] ?? 'Unknown',
          municipalCouncil: item['municipalCouncil'] ?? 'Unknown',
          date: item['date'] ?? 'Unknown',
          time: item['time'] ?? 'Unknown',
          weight: item['weight'] ?? 'Unknown',
        ),
      ),
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "History",
                    style: AppTextStyles.topic,
                  ),
                  const SizedBox(height: 20),

                  // Show a loading indicator while data is being fetched
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (disposalHistory.isEmpty)
                    const Center(child: Text('No disposal history found'))
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: disposalHistory.length,
                      itemBuilder: (context, index) {
                        final item = disposalHistory[index];
                        return GestureDetector(
                          onTap: () => _navigateToDetails(item),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['truckNumber'] ?? 'N/A', // Handle null values
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        item['date'] ?? 'Unknown', // Handle null values
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item['time'] ?? 'Unknown', // Handle null values
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
