// ignore_for_file: prefer_const_constructors

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remainder_app/card_widget.dart';

import 'notification_handler.dart';

 

class MyNoteScreen extends StatefulWidget {
  const MyNoteScreen({Key? key}) : super(key: key);

  @override
  _MyNoteScreenState createState() => _MyNoteScreenState();
}

class _MyNoteScreenState extends State<MyNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 224, 224),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 139, 45, 155),
        elevation: 10,
        title: Text("My Daily Remainders",
        style: TextStyle(
  color: Colors.white
        ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                    child: NoteThumbnail(
                        id: 1,
                        color: Color(0xFFFF9C99),
                        title: "",
                        content: "")),
                 
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
             Row(
               children: [
                 Text("Your Recent Remainders",
                           style: TextStyle(
                             fontSize: 20.sp,
                             fontWeight: FontWeight.w800,
                             color: Colors.black
                           ),),
                           SizedBox(width: 10.w,),
                           Icon(Icons.alarm)
               ],
             ),
         SizedBox(
              height: 15.h,
            ),
             Card_widget(),
          ],
        ),
      ),
    );
  }
}

class NoteThumbnail extends StatefulWidget {
  final int id;
  final Color color;
  final String title;
  final String content;

  const NoteThumbnail(
      {Key? key,
      required this.id,
      required this.color,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  _NoteThumbnailState createState() => _NoteThumbnailState();
}

class _NoteThumbnailState extends State<NoteThumbnail> {
  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();
  final NotificationService _notificationService = NotificationService();

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
        await _notificationService.scheduleNotifications(
            id: widget.id,
            title: widget.title,
            body: widget.content,
            time: fullDate);
      }
      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: 360.w,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule your remainders",
            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text('You can also add note to your Remainders',
            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),),
           SizedBox(
            height: 10.h,
          ),
           SizedBox(
            height: 15.h,
          ),
          ElevatedButton.icon(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.alarm),
              label:  Text("Add Reminder",
               style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp,),))
        ],
      ),
    );
  }
}