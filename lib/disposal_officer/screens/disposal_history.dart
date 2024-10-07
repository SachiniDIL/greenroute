import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/back_arrow.dart';
import 'package:greenroute/theme.dart';

class DisposalHistory extends StatelessWidget {
  const DisposalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for history items
    final List<Map<String, String>> historyData = [
      {"truckNumber": "KADU0231", "date": "10 Sept 2024", "time": "17:20"},
      {"truckNumber": "KADU0231", "date": "10 Sept 2024", "time": "17:20"},
      {"truckNumber": "KADU0231", "date": "10 Sept 2024", "time": "17:20"},
      {"truckNumber": "KADU0231", "date": "10 Sept 2024", "time": "17:20"},
    ];

    return Scaffold(
      body: Column(
        children: [
          BackArrow(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "History",
                    style: AppTextStyles.topic,
                  ),
                  const SizedBox(height: 20),

                  // List of history items
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: historyData.length,
                    itemBuilder: (context, index) {
                      final item = historyData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
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
                                    item['truckNumber']!,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item['date']!,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item['time']!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
