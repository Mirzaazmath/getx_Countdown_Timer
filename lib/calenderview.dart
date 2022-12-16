import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class Calenderview extends StatelessWidget {
  const Calenderview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child:Column(
            children: [

              Container(
                height: 700,
                child: SfCalendar(
                  cellBorderColor: Colors.white,
                    view: CalendarView.month,
                  dataSource: MeetingDataSource(_getDataSource()),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,


                      showAgenda: true,


                ),
              ),
              )],
          )
        ));
  }

}
List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
  DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(
      Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
  meetings.add(
      Meeting('Conference', DateTime(today.year, today.month, today.day, 20, 0, 0),  DateTime(today.year, today.month, today.day, 21, 0, 0), Colors.red, false));
  meetings.add( Meeting('lunch with friends',  DateTime(today.year, today.month, today.day, 14, 0, 0),  DateTime(today.year, today.month, today.day, 15, 0, 0), Colors.blue, false));
  return meetings;
}


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
