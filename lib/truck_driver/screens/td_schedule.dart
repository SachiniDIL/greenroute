import 'package:flutter/material.dart';
import 'package:greenroute/common/widgets/new_button.dart';
import 'package:greenroute/truck_driver/screens/truck_driver_home.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:greenroute/theme.dart';
import 'package:greenroute/truck_driver/widgets/bottom_nav_truck.dart';

class TDSchedule extends StatefulWidget {
  const TDSchedule({super.key});

  @override
  _TDScheduleState createState() => _TDScheduleState();
}

class _TDScheduleState extends State<TDSchedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? selectedDate; // To store the selected date
  TimeOfDay? startTime; // To store the start time
  TimeOfDay? endTime; // To store the end time
  String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                SizedBox(height: 55.0),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Schedule",
                    style: AppTextStyles.topic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0), // Adjust spacing as needed
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                    _buildCalendar(),
                    SizedBox(
                      height: 26,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        'Job details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Container(
                      decoration: ShapeDecoration(
                        color: AppColors.backgroundSecondColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            _jobRow("Date", selectedDate.toString()),
                            _jobRow("Start time", startTime.toString()),
                            _jobRow("End time", endTime.toString()),
                            _jobRow("Route No", routeName.toString()),
                            BtnNew(
                              width: 130,
                              height: 30,
                              buttonText: "See route",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TruckDriverHome()),
                                ); // Navigate to Notification screen
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomNavTD(current: "schedule"),
        ],
      ),
    );
  }

  Widget _jobRow(String name, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 30,
            child: Text(
              name,
              style: TextStyle(
                color: Color(0xFF525151),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 30,
            child: Text(
              ": ",
              style: TextStyle(
                color: Color(0xFF525151),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: Text(
                detail,
                style: TextStyle(
                  color: Color(0xFF535252),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondColor.withOpacity(0.5),
        // Light background color for the calendar
        borderRadius:
            BorderRadius.circular(10.0), // Rounded corners for the calendar
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.green.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.buttonColor,
            // Match the green color for selected day
            shape: BoxShape.circle,
          ),
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          outsideDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          cellMargin: EdgeInsets.all(6.0), // Adds padding to the date cells
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          titleTextStyle: TextStyle(
            color: AppColors.buttonColor, // Match the green color for the title
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(color: Colors.black),
          weekdayStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
