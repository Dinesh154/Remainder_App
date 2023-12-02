// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
 

class Add_notification extends StatefulWidget {
  @override
  _Add_notificationState createState() => _Add_notificationState();
}

class _Add_notificationState extends State<Add_notification> {
  String selectedDay = "Monday";
  String selectedActivity = "Wake up";
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
    );
  }

  Future<void> _showNotification(
      String day, String time, String activity) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin!.show(
      0,
      'Reminder',
      'Your Notification is schedule for the activity $activity on $day at $time',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  Future<void> scheduleNotifications({id, title, body, DateTime? time}) async {
    try {
      print("scheduled called");
       
     
      print(tz.local);
      print(time);
      await flutterLocalNotificationsPlugin!.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(time!, tz.local),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      print("Finieshed");
    } catch (e) {
      print(e);
    }
  }

  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();

  Future<DateTime> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (time != null) {
        setState(() {
          fullDate = DateTimeField.combine(date, time);
        });
        print("The full date $fullDate");
      }
      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Select Day:',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                DropdownButton<String>(
                  value: selectedDay == null ? "" : selectedDay,
                  hint: Text(
                    "Select the day",
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value + " "),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Handle day selection
                    setState(() {
                      selectedDay = newValue.toString();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  'Select Time:',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text("Select Time"))
              ],
            ),
            SizedBox(height: 25.h),
            Row(
              children: [
                Text(
                  'Select Activity:',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                DropdownButton<String>(
                  value: selectedActivity,
                  hint: Text(
                    "Select Activity",
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: [
                    'Wake up',
                    'Go to gym',
                    'Breakfast',
                    'Meetings',
                    'Lunch',
                    'Quick nap',
                    'Go to library',
                    'Dinner',
                    'Go to sleep'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue.toString();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Get selected day, time, and activity and set a reminder
                  _showNotification(selectedDay,
                      DateFormat.jm().format(fullDate), selectedActivity);
                  scheduleNotifications(
                      id: 1,
                      title: "Remainder",
                      body: "Hey It's Time to do the $selectedActivity !!",
                      time: fullDate);
                },
                child: Text(
                  'Set Remainder',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
