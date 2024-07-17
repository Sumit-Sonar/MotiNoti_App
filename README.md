MotiNoti App
MotiNoti is a Flutter-based mobile application designed to provide users with daily motivation through motivational posts, videos, and quotes. The app also features a notification system that allows users to schedule motivational notifications at specified times or receive hourly notifications to help combat phone addiction and endless scrolling.

Features
Motivational Posts: Browse and read motivational posts to stay inspired.
Motivational Videos: Watch motivational videos to boost your mood and motivation.
Motivational Quotes: Get daily motivational quotes to keep you going.
Scheduled Notifications: Schedule notifications at specific times to receive motivational content.
Hourly Notifications: Enable hourly notifications to get regular motivational reminders and reduce phone addiction.


Installation
Clone the repository:

sh
Copy code
git clone https://github.com/yourusername/motinoti_app.git
cd motinoti_app
Install dependencies:

sh
Copy code
flutter pub get
Run the app:

sh
Copy code
flutter run
Usage
Enabling Hourly Notifications
To enable hourly notifications:

Go to the settings screen.
Toggle the switch to enable hourly notifications.
You will receive a motivational notification every hour.
Scheduling Notifications
To schedule a notification at a specific time:

Go to the notification scheduling screen.
Select the date and time you want to receive the notification.
Tap the "Set" button to schedule the notification.
Stopping Hourly Notifications
To stop hourly notifications:

Go to the settings screen.
Toggle the switch to disable hourly notifications.
Hourly notifications will be stopped immediately.
Development
Prerequisites
Flutter SDK
Dart
Android Studio or Visual Studio Code
Dependencies
flutter_local_notifications
timezone
shared_preferences
Directory Structure
css
Copy code
lib/
├── main.dart
├── UIs/
│   ├── MyHomePage.dart
│   ├── MotiQuotesUI.dart
│   ├── ScheduleNotifyUI.dart
├── services/
│   ├── notifiService.dart
│   └── sharedPrefService.dart
Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

Fork the project
Create your feature branch (git checkout -b feature/my-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin feature/my-feature)
Open a Pull Request
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contact
For any questions or inquiries, please contact your-email@example.com.
