import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/home_header.dart';
import 'package:greenroute/common/widgets/new_button.dart';
import 'package:greenroute/disposal_officer/screens/disposal_history.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import '../../common/widgets/custom_table.dart';
import '../../theme.dart';
import '../services/disposal_service.dart'; // Correctly import DisposalService
import '../widgets/bottom_nav_do.dart';
import 'new_disposal.dart';

class DOHome extends StatefulWidget {
  const DOHome({super.key});

  @override
  _DOHomeState createState() => _DOHomeState();
}

class _DOHomeState extends State<DOHome> {
  List<Map<String, dynamic>> latestDisposals = [];
  bool isLoading = true;
  double garbageTotal = 0;
  String? userRole;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the widget is initialized
    _fetchLatestDisposals(); // Fetch disposal data
  }

  // Method to load user_role and user_email from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role');
      userEmail = prefs.getString('user_email');
      isLoading = false;
    });

    print("Loaded User Role: $userRole");
    print("Loaded User Email: $userEmail");
  }


  Future<void> _fetchLatestDisposals() async {
    try {
      // Fetch disposal data and truck data from the service
      List<Map<String, dynamic>> disposals = await DisposalService.fetchDisposalHistory();
      List<Map<String, dynamic>> trucks = await DisposalService.fetchTruckData();

      // Combine the truck data into the disposal data by matching truck_number with truck_id
      List<Map<String, dynamic>> combinedData = disposals.map((disposal) {
        String truckId = disposal['truck_number'];
        var truck = trucks.firstWhere((truck) => truck['truck_id'] == truckId, orElse: () => {});
        return {
          'truckNo': truck.isNotEmpty ? truck['truck_number'] : 'Unknown',
          'date': disposal['date'] ?? 'Unknown',
          'time': disposal['time'] ?? 'Unknown',
        };
      }).toList();

      setState(() {
        latestDisposals = combinedData.take(4).toList();
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      body: Column(
        children: [
          SizedBox(
            // Pass userRole and userEmail to HomeHeader
            child: HomeHeader(
              userRole: userRole ?? "Guest", // Provide default values if null
              userEmail: userEmail ?? "Not Available",
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 7.0),
                    Container(
                      height: 52.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'search for truck details',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            title: 'New Disposal',
                            buttonText: 'Add new disposal',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NewDisposal()),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 160,
                            decoration: ShapeDecoration(
                              color: AppColors.backgroundSecondColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Garbage Total',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.6399999856948853),
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 37,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: garbageTotal.toString(),
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.6399999856948853),
                                            fontSize: 40,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' mt',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.6399999856948853),
                                            fontSize: 24,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Divider(thickness: 0.7),
                    SizedBox(height: 30),
                    _buildTruckDetailsTable(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          BottomNavDO(current: 'home'),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String title,
      required String buttonText,
      VoidCallback? onPressed}) {
    return Container(
      height: 160,
      decoration: ShapeDecoration(
        color: AppColors.backgroundSecondColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.64),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 40),
            BtnNew(
              width: double.infinity,
              height: 45,
              buttonText: buttonText,
              onPressed: onPressed ??
                  () {}, // Provide a default empty function if null
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckDetailsTable() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.backgroundSecondColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Truck Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.64),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 15.0),
            CustomTable(rows: _buildTableRows()),
            SizedBox(height: 15.0),
            BtnNew(
              width: 170.0,
              height: 35.0,
              buttonText: 'See more',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DisposalHistory()));
              },
            ),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [
      TableRow(
        children: [
          _buildTableCell("Truck No"),
          _buildTableCell("Date"),
          _buildTableCell("Time"),
        ],
      ),
    ];

    if (isLoading) {
      rows.add(
        TableRow(
          children: [
            _buildTableCell("Loading..."),
            _buildTableCell(""),
            _buildTableCell(""),
          ],
        ),
      );
    } else {
      for (var disposal in latestDisposals) {
        rows.add(
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border:
                  Border(top: BorderSide(width: 2, color: Color(0xFFD1CFD7))),
            ),
            children: [
              _buildTableCell(disposal['truckNo']),
              _buildTableCell(disposal['date']),
              _buildTableCell(disposal['time']),
            ],
          ),
        );
      }
    }

    return rows;
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF686868),
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
