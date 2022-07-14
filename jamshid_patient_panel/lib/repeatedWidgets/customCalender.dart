import 'package:doctor_app/res/color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/res/size.dart';

class CustomCalendar extends StatefulWidget {
  CalendarController calendarController;

  Map<DateTime, List> events;
  bool showAll;

  DateTime startDate;
  DateTime initalDatTime;

  Function onDaySelected;
  Function OnVisibleDaysChanged;

  CustomCalendar(
      {this.calendarController,
      this.events,
      this.showAll = true,
      this.startDate,
      this.initalDatTime,
      this.onDaySelected,
      this.OnVisibleDaysChanged});

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  bool setHeight;
  CalendarFormat initialFormat = CalendarFormat.month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setHeight = widget.showAll ?? true;
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    try {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
                color: portionColor,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 6))
          ],
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: size.convert(context, 8),
                ),
                TableCalendar(
                  childVisible: setHeight,
                  headerVisible: true,
                  locale: 'en',
                  onVisibleDaysChanged: widget.OnVisibleDaysChanged,
                  rowHeight: size1.longestSide * 0.067,
                  calendarController: widget.calendarController,
                  initialCalendarFormat: CalendarFormat.month,
//                  childVisible: setHeight,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextBuilder: (date, locale) {
                      return DateFormat.E().format(date)[0].toUpperCase();
                    },
                    weekdayStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: size.convert(context, 14)),
                    weekendStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: size.convert(context, 14)),
                  ),
                  availableGestures: AvailableGestures.horizontalSwipe,
                  events: widget.events,
                  onDaySelected: (DateTime date, List event) {
                    print(date);
//                    String selectedDate = date.toString().substring(0,10).replaceAll("-", "");
//                     selectedDate = selectedDate.toString().replaceAll(":", "");
//                     selectedDate = selectedDate.toString().replaceAll(".", "");
//                     String nowDate = DateTime.now().toString().substring(0,10).replaceAll("-", "");
//                    selectedDate = selectedDate.toString().replaceAll(":", "");
//                    selectedDate = selectedDate.toString().replaceAll(".", "");
//                    print("Select date = ${selectedDate}");
//                    print("Now date = ${nowDate}");
//                    double nowDateTodouble = double.parse(nowDate);
//                    double selectedDateTodouble = double.parse(selectedDate);
//                    if(nowDateTodouble <= selectedDateTodouble){
//
//                    }
                    setState(() {
                      setHeight = false;
                    });
                    widget.onDaySelected(date, event);
                  },
                  initialSelectedDay: widget.initalDatTime != null
                      ? widget.initalDatTime
                      : DateTime.now(),
                  startDay: widget.startDate != null
                      ? widget.startDate
                      : DateTime.now().subtract(Duration(hours: 24)),

                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    leftChevronPadding: EdgeInsets.only(
                        left: size1.width *
                            (size1.shortestSide / size1.longestSide) *
                            .05),
                    rightChevronPadding: EdgeInsets.only(
                        right: size1.width *
                            (size1.shortestSide / size1.longestSide) *
                            .06),
                    titleTextStyle: TextStyle(
                        locale: Locale('en'),
                        color: portionColor,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: size.convert(context, 18)),
                    formatButtonVisible: false,
                    rightChevronIcon: Icon(
                      Icons.navigate_next,
                      color: Colors.grey,
                      size: size.convert(context, 22),
                    ),
                    leftChevronIcon: Icon(
                      Icons.navigate_before,
                      color: Colors.grey,
                      size: size.convert(context, 22),
                    ),
                  ),

                  calendarStyle: CalendarStyle(
//                  holidayStyle: TextStyle(color: Colors.blue),
                    selectedColor: buttonColor,
                    todayColor: buttonColor.withOpacity(0.5),
                    //radius: global.pxl14,
                    outsideHolidayStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'PoppinsSemiBold',
                        fontSize: size.convert(context, 14)),

                    selectedStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.convert(context, 14),
                        fontFamily: 'PoppinsSemiBold'),
                    weekendStyle: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 14),
                        fontFamily: 'LatoBold'),

                    weekdayStyle: TextStyle(
                        color: Colors.black,
                        fontSize: size.convert(context, 14),
                        fontFamily: 'LatoBold'),
                    outsideStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: size.convert(context, 14),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoppinsSemiBold'),
                    todayStyle: TextStyle(
                        color: Colors.white,
                        fontSize: size.convert(context, 14),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoppinsSemiBold'),
                    outsideDaysVisible: false,
                    outsideWeekendStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: size.convert(context, 14),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoppinsSemiBold'),
                    unavailableStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: size.convert(context, 14),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoppinsSemiBold'),
                    markersColor: buttonColor,
                    markersMaxAmount: 2,
                    markersAlignment: Alignment.bottomCenter,
//                    markerShape: BoxShape.rectangle,
//                    markerWidth: 5.0,
//                    markerHeight: 2.0,
                  ),
                ),
                SizedBox(
                  height: size.convert(context, 20),
                ),
              ],
            ),
            Positioned(
              bottom: 0.0,
              child: GestureDetector(
                onTap: () {
                  print("toggle");
//                      _calendarController.toggleCalendarFormat();
                  setState(() {
                    setHeight = !setHeight;
                  });
                  print(setHeight);
                },
//            onVerticalDragUpdate: (DragUpdateDetails status){
//              print(status.globalPosition.dy);
//              print("height $heightValue");
//              if(status.globalPosition.dy>heightValue){
//                setState(() {
//                  heightValue = 407;
//                  setHeight = true;
//                });
//              }else{
//                heightValue = 150;
//                setHeight = false;
//              }
//            },
                child: Container(
                  padding: EdgeInsets.only(
                      top: size.convert(context, 10),
                      bottom: size.convert(context, 10)),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red.withOpacity(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 3.0,
                        width: size.convert(context, 40),
                        color: portionColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container();
    }
  }
}
