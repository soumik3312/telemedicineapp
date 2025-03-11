// video_conference_screen.dart
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:telemedicine_app/main.dart';

class VideoConferenceScreen extends StatefulWidget {
  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen> {
  late HMSConfig _hmsConfig;
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    _hmsConfig = HMSConfig(
      authToken: 'your-auth-token', // Replace with actual auth token
      userName: 'Your Name',
    );
  }

  Future<void> _joinMeeting() async {
    try {
      await HMSFlutterPlugin.join(
        meetingUrl: 'your-meeting-url', // Replace with actual meeting URL
        config: _hmsConfig,
      );
      setState(() {
        _isJoined = true;
      });
    } catch (e) {
      print('Error joining meeting: $e');
    }
  }

  Future<void> _leaveMeeting() async {
    try {
      await HMSFlutterPlugin.leave();
      setState(() {
        _isJoined = false;
      });
    } catch (e) {
      print('Error leaving meeting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Conference'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isJoined ? _leaveMeeting : _joinMeeting,
              child: Text(_isJoined ? 'Leave Meeting' : 'Join Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
