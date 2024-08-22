import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:motinoti/services/adsServices.dart';
import 'package:motinoti/services/notifiService.dart';
import 'package:motinoti/services/sharedprefclass.dart';

DateTime scheduleTime = DateTime.now();

class ScheduleNotifyUI extends StatefulWidget {
  final NotificationService notificationService;

  const ScheduleNotifyUI({Key? key, required this.notificationService})
      : super(key: key);

  @override
  State<ScheduleNotifyUI> createState() => _ScheduleNotifyUIState();
}

class _ScheduleNotifyUIState extends State<ScheduleNotifyUI> {
  AdsService adsService = AdsService();

  @override
  void initState() {
    super.initState();
    widget.notificationService.initNotification(context,
        notificationService: widget.notificationService);
    adsService.loadBannerAd(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Schedule Notification",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 4,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blueGrey.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const DatePickerTxt(),
                              const SizedBox(width: 10),
                              const ScheduleBtn(),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade800,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.hourglass_top_sharp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Get Notified Hourly",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              const ScheduleSwitch(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: adsService.isbannerAdLoaded
                  ? Container(
                      color: Colors.grey,
                      child: AdWidget(ad: adsService.bannerAd!),
                      width: adsService.bannerAd!.size.width.toDouble(),
                      height: adsService.bannerAd!.size.height.toDouble(),
                      alignment: Alignment.center,
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({Key? key}) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.timer_sharp),
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
      label: const Text('Select Date Time'),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification Scheduled for $scheduleTime'),
            duration: const Duration(seconds: 2),
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
  const ScheduleSwitch({Key? key}) : super(key: key);

  @override
  _ScheduleSwitchState createState() => _ScheduleSwitchState();
}

class _ScheduleSwitchState extends State<ScheduleSwitch> {
  final SharedPrefClass _sharedPrefService = SharedPrefClass();
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    bool savedState = await _sharedPrefService.getHourlyNotification();
    setState(() {
      isSwitched = savedState;
    });
  }

  void toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      _sharedPrefService.setHourlyNotification(value);

      if (isSwitched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hourly notifications enabled'),
            duration: Duration(seconds: 2),
          ),
        );
        NotificationService().scheduleHourlyNotification(
          id: 2,
          title: 'Lost in phone?',
          body: 'Checkout this quote by..',
          scheduledNotificationDateTime: scheduleTime,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hourly notifications disabled'),
            duration: Duration(seconds: 2),
          ),
        );
        NotificationService().stopHourlyNotification(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: toggleSwitch,
      activeColor: Colors.black,
      inactiveTrackColor: Colors.grey,
      inactiveThumbColor: Colors.black26,
    );
  }
}
