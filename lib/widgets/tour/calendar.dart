import 'package:drive_tracking_solutions/widgets/tour/tour_details.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/tour.dart';
import '../../util/calender_util.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final ValueNotifier<List<Tour>> _selectedTours;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedTours = ValueNotifier(_getToursForDay(_selectedDay!));
    clearTours();
    populateTours().then((value) => {setState(() => {})});
  }

  @override
  void dispose() {
    _selectedTours.dispose();
    super.dispose();
  }

  List<Tour> _getToursForDay(DateTime day) {
    // Implementation example
    return kTours[day] ?? [];
  }

  List<Tour> _getToursForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getToursForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedTours.value = _getToursForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedTours.value = _getToursForRange(start, end);
    } else if (start != null) {
      _selectedTours.value = _getToursForDay(start);
    } else if (end != null) {
      _selectedTours.value = _getToursForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black)),
            child: TableCalendar<Tour>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getToursForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: Color(0x8007460b),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xff07460b),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Color(0xFFDC5507),
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: Color(0x3307460b),
                  rangeStartDecoration: BoxDecoration(
                    color: Color(0xff47b64f),
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Color(0x3325ea31),
                    shape: BoxShape.circle,
                  ),
                  rangeEndTextStyle: TextStyle(color: Colors.black)),
              headerStyle: HeaderStyle(
                decoration: BoxDecoration(
                  color: const Color(0xff07460b),
                  borderRadius: BorderRadius.circular(20),
                ),
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Tour>>(
            valueListenable: _selectedTours,
            builder: (context, tours, _) {
              return ListView.builder(
                itemCount: tours.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      height: 140,
                      width: double.infinity,
                      child: GestureDetector(
                        child: Card(
                          elevation: 1,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: const BoxDecoration(
                                          color: Color(0x8007460b),
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(
                                        '${tours[index].startTime?.day}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  Text(
                                    tours[index]
                                        .getMonth(tours[index].startTime!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start time:${tours[index].startTime?.hour}:${tours[index].startTime?.minute}:${tours[index].startTime?.second}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        'End time:${tours[index].endTime?.hour}:${tours[index].endTime?.minute}:${tours[index].endTime?.second}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        'Total time: ${tours[index].totalTime}',
                                        style: const TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.data_usage),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => TourDetails(
                                tour: tours[index], id: tours[index].tourId),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
