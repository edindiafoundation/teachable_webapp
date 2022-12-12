import 'package:event_generator/admin_screens/report/post-test_report.dart';
import 'package:event_generator/admin_screens/report/pre-test_report.dart';
import 'package:event_generator/admin_screens/report/user-session_report.dart';
import 'package:event_generator/admin_screens/report/user_report.dart';
import 'package:event_generator/widgets/upTab.dart';
import 'package:flutter/material.dart';


class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return BuildTab.tabBar(
      'Generate Reports',
      const [
        Tab(icon: Icon(Icons.man), text: 'User'),
        Tab(icon: Icon(Icons.time_to_leave), text: 'User-Session'),
        Tab(icon: Icon(Icons.text_snippet), text: 'Pre-Test'),
        Tab(icon: Icon(Icons.textsms_outlined), text: 'Post-Test'),
      ],
      [
        const UsersReport(),
        const UserSessionReport(),
        const PreTestReport(),
        const PostTestReport(),
      ],
    );
  }
}