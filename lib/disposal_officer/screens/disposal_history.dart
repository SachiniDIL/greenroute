import 'package:flutter/material.dart';
import 'package:greenroute/disposal_officer/screens/disposal_history_clicked.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/theme.dart';
import '../services/disposal_service.dart';

class DisposalHistory extends StatefulWidget {
  final String? truckDriver; // Add truckDriver parameter

  const DisposalHistory({super.key, this.truckDriver}); // Accept truckDriver parameter

  @override
  _DisposalHistoryState createState() => _DisposalHistoryState();
}

class _DisposalHistoryState extends State<DisposalHistory> {
  // List to store disposal history data
  List<Map<String, String>> disposalHistory = [];
  bool isLoading = true;
  Map<String, String> truckDriverIdToName = {};
  Map<String, String> municipalCouncilIdToName = {};

  @override
  void initState() {
    super.initState();
    _fetchDisposalHistory();
  }

  // Fetch disposal history
  Future<void> _fetchDisposalHistory() async {
    try {
      // Fetch all necessary data
      List<Map<String, dynamic>> history = await DisposalService.fetchDisposalHistory();
      List<Map<String, dynamic>> trucks = await DisposalService.fetchTruckData();
      List<Map<String, dynamic>> truckDrivers = await DisposalService.fetchTruckDrivers();
      List<Map<String, dynamic>> municipalCouncils = await DisposalService.fetchMunicipalCouncils();

      // Map truck ids to truck numbers
      Map<String, String> truckIdToNumber = {
        for (var truck in trucks) truck['truck_id']: truck['truck_number'] ?? 'Unknown'
      };

      // Map truck driver ids to names
      truckDriverIdToName = {
        for (var driver in truckDrivers)
          driver['emp_id']: "${driver['first_name']} ${driver['last_name']}"
      };

      // Map municipal council ids to names
      municipalCouncilIdToName = {
        for (var council in municipalCouncils)
          council['council_id']: council['council_name']
      };

      // Check if a specific truck driver is provided
      String? selectedTruckDriver = widget.truckDriver;

      // Filter the history if a truck driver is provided
      if (selectedTruckDriver != null) {
        // Filter only those disposals where the truck driver matches the selectedTruckDriver
        history = history.where((item) => item['truck_driver'] == selectedTruckDriver).toList();
      }

      // If no disposal records are found after filtering
      if (history.isEmpty) {
        setState(() {
          disposalHistory = []; // Set empty history if no records found
          isLoading = false;
        });
        return; // Exit early if no records to display
      }

      // Parse and process the history data
      setState(() {
        disposalHistory = history.map((item) {
          // Match truck_number from disposal with truck_id from truck data
          String truckId = item['truck_number']?.toString() ?? 'Unknown';
          String truckNumber = truckIdToNumber[truckId] ?? 'Unknown';

          String truckDriverName = truckDriverIdToName[item['truck_driver']] ?? 'Unknown';
          String municipalCouncilName = municipalCouncilIdToName[item['municipal_council']] ?? 'Unknown';

          return {
            'truckId': truckId,
            'truckNumber': truckNumber, // Use the matched truck number
            'truckDriver': truckDriverName, // Use the matched driver name
            'municipalCouncil': municipalCouncilName, // Use the matched council name
            'date': item['date']?.toString() ?? 'Unknown',
            'time': item['time']?.toString() ?? 'Unknown',
            'weight': item['disposal_weight']?.toString() ?? 'Unknown',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
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
                  const Text("History", style: AppTextStyles.topic),
                  const SizedBox(height: 20),

                  // Show a loading indicator while data is being fetched
                  if (isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,))
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
                                color: Color(0x3F5EA417),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['truckNumber'] ?? 'N/A',
                                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        item['date'] ?? 'Unknown',
                                        style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item['time'] ?? 'Unknown',
                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

  void _navigateToDetails(Map<String, String?> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisposalHistoryClicked(
          truckId: item['truckId'] ?? 'N/A',
          truckNumber: item['truckNumber'] ?? 'N/A',
          truckDriverName: item['truckDriver'] ?? 'Unknown', // Pass name instead of ID
          municipalCouncilName: item['municipalCouncil'] ?? 'Unknown', // Pass name instead of ID
          date: item['date'] ?? 'Unknown',
          time: item['time'] ?? 'Unknown',
          weight: item['weight'] ?? 'Unknown',
        ),
      ),
    );
  }
}
