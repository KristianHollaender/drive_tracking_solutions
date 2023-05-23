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
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by long pressing a date
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
    return kTours[day] ?? [];
  }

  List<Tour> _getToursForRange(DateTime start, DateTime end) {
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
        _rangeStart = null;
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
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white),
                  color: const Color(0x77AEBEAE)),
              child: _buildTableCalendar(),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        _buildTourDetails(),
      ],
    );
  }

  TableCalendar<Tour> _buildTableCalendar() {
    return TableCalendar<Tour>(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: _rangeSelectionMode,
      eventLoader: _getToursForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle(color: Color(0xff2d4f31)),
        weekendTextStyle: TextStyle(
          color: Color(0xffb8e0bd),
        ),
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
        rangeEndTextStyle: TextStyle(color: Colors.grey),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        decoration: BoxDecoration(
          color: const Color(0xff07460b),
          borderRadius: BorderRadius.circular(35),
        ),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        formatButtonVisible: false,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle:
              TextStyle(color: Color(0xff8dea91), fontWeight: FontWeight.bold),
          weekdayStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      onDaySelected: _onDaySelected,
      onRangeSelected: _onRangeSelected,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Expanded _buildTourDetails() {
    return Expanded(
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
                      border: Border.all(color: Colors.white)),
                  height: 95,
                  width: double.infinity,
                  child: GestureDetector(
                    child: Card(
                      elevation: 1,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: const BoxDecoration(
                                      color: Color(0x8007460b),
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Center(
                                            child: Text(
                                          '${tours[index].startTime?.day}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.white),
                                        )),
                                        Text(
                                          tours[index].getMonth(
                                              tours[index].startTime!),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 26.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total time: ${tours[index].totalTime}',
                                    style: const TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, top: 12.0),
                              child: Column(
                                children: const [
                                  Icon(Icons.hourglass_empty_sharp, size: 35.0),
                                  Text("Review")
                                ],
                              ),
                            ),
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
    );
  }
}
