import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2021, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    weekNumbersVisible: true,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
              child: Container(
                height: 400,
            width: double.infinity,
            color: Colors.red,
          ))
        ],
      ),
    );
  }
}
