import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityWidget extends StatefulWidget {
  @override
  _AvailabilityWidgetState createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  bool _isMondayToFriday = false;
  bool _isSaturdaySunday = false;
  bool _isTwentyFourSeven = false;

  String _fromTime = '08:00 AM';
  String _toTime = '05:00 PM';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isMondayToFriday,
              onChanged: (value) {
                setState(() {
                  _isMondayToFriday = value!;
                });
              },
                checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
               splashRadius: 10,
                           activeColor: Colors.greenAccent,
            ),
            const Text('Monday to Friday',style: TextStyle(fontSize: 16,color: Colors.white),),
            if (_isMondayToFriday)
              Expanded(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => _selectTime(context, isFromTime: true),
                      child: Text(_fromTime),
                    ),
                    const Text('-'),
                    TextButton(
                      onPressed: () => _selectTime(context, isFromTime: false),
                      child: Text(_toTime),
                    ),
                  ],
                ),
              ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isSaturdaySunday,
              onChanged: (value) {
                setState(() {
                  _isSaturdaySunday = value!;
                });
              },
                checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
               splashRadius: 10,
                           activeColor: Colors.greenAccent,
            ),
            const Text('Saturday & Sunday',style: TextStyle(fontSize: 16,color: Colors.white),),
            if (_isSaturdaySunday)
              Expanded(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => _selectTime(context, isFromTime: true),
                      child: Text(_fromTime),
                    ),
                    const Text('-'),
                    TextButton(
                      onPressed: () => _selectTime(context, isFromTime: false),
                      child: Text(_toTime),
                    ),
                  ],
                ),
              ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isTwentyFourSeven,
              onChanged: (value) {
                setState(() {
                  _isTwentyFourSeven = value!;
                });
              },
                checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
               splashRadius: 10,
                           activeColor: Colors.greenAccent,
            ),
            const Text('24/7',style: TextStyle(fontSize: 16,color: Colors.white),),
          ],
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context, {required bool isFromTime}) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final formattedTime = _formatTime(selectedTime);
      setState(() {
        if (isFromTime) {
          _fromTime = formattedTime;
        } else {
          _toTime = formattedTime;
        }
      });
    }
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(dateTime); // You might need to import intl package
  }
}

