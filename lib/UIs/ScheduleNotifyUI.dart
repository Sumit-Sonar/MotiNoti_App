import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:motinoti_app/services/notifiService.dart';

DateTime scheduleTime = DateTime.now();

class ScheduleNotifyUI extends StatefulWidget {
  final NotificationService notificationService;

  const ScheduleNotifyUI({Key? key, required this.notificationService})
      : super(key: key);

  @override
  State<ScheduleNotifyUI> createState() => _ScheduleNotifyUIState();
}

class _ScheduleNotifyUIState extends State<ScheduleNotifyUI> {
  @override
  void initState() {
    super.initState();
    widget.notificationService.initNotification(context,
        notificationService: widget.notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Schedule Notification"),
        ),
        body: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/images/schedulebck.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatePickerTxt(),
                      SizedBox(
                        width: 5,
                      ),
                      ScheduleBtn(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          onPressed: null,
                          icon: Icon(Icons.hourglass_top_sharp),
                          label: Text(
                            "Get Notified Hourly",
                            style: TextStyle(color: Colors.black),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      ScheduleSwitch(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.timer_sharp),
      onPressed: () {
        DatePicker.showDatePicker(
          context,
          pickerTheme: const DateTimePickerTheme(
            showTitle: true,
            confirm: Text('Confirm', style: TextStyle(color: Colors.blue)),
            cancel: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          minDateTime: DateTime(2000),
          maxDateTime: DateTime(2100),
          initialDateTime: scheduleTime,
          dateFormat: 'HH:mm',
          locale: DateTimePickerLocale.en_us,
          onClose: () => print(""),
          onCancel: () => print('canceled'),
          onChange: (dateTime, List<int> index) {
            setState(() {
              scheduleTime = dateTime;
            });
          },
          onConfirm: (dateTime, List<int> index) {
            setState(() {
              scheduleTime = dateTime;
            });
          },
        );
      },
      label: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification Scheduled for $scheduleTime'),
            duration: Duration(seconds: 10),
          ),
        );
        NotificationService().scheduleNotification(
          id: 1,
          title: 'Lost in phone?',
          body: 'Checkout this Quote By...',
          scheduledNotificationDateTime: scheduleTime,
        );
      },
      child: const Text('Set'),
    );
  }
}

class ScheduleSwitch extends StatefulWidget {
  const ScheduleSwitch({
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleSwitchState createState() => _ScheduleSwitchState();
}

class _ScheduleSwitchState extends State<ScheduleSwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          if (isSwitched) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notification Scheduled for Hourly'),
                duration: Duration(seconds: 10),
              ),
            );
            NotificationService().scheduleHourlyNotification(
              id: 2,
              title: 'Lost in phone?',
              body: 'Checkout this Quote By...',
              scheduledNotificationDateTime: scheduleTime,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Hourly Notification Turned Off'),
                duration: Duration(seconds: 5),
              ),
            );
            NotificationService().stopHourlyNotification(2);
          }
        });
      },
    );
  }
}
