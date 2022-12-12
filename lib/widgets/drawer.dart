import 'dart:io';
import 'package:event_generator/admin_screens/reports.dart';
import 'package:event_generator/screens/home_screen.dart';
import 'package:event_generator/screens/webinar_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_generator/admin_screens/add_diet.dart';
import 'package:event_generator/admin_screens/admin_screen.dart';
import 'package:event_generator/admin_screens/add_pvt.dart';
import 'package:event_generator/admin_screens/add_links.dart';
import 'package:event_generator/screens/email_login_screen.dart';
import 'package:event_generator/screens/registration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class BuildDrawer {
  static Drawer buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            child: Image.asset('assets/images/company_logo.png'),
            height: 180,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.to(AdminScreen());
            },
          ),
          ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Add-Edit PVT Institute'),
              onTap: () {
                Get.to(AddPVT());
              }),
          ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('Add-Edit DIET'),
              onTap: () {
                Get.to(AddDIET());
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.insert_invitation_rounded),
            title: const Text('Add Latest Webinar'),
            onTap: () {
              Get.to(AddLink());
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Report Generator'),
            onTap: () {
              Get.to(ReportScreen());
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Add User'),
              onTap: () {
                Get.to(RegisterPage());
              }),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Log Out'),
            onTap: () async {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const EmailLoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  static Drawer buildUserDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            child: Image.asset('assets/images/app_icon.png'),
            height: 180,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('Our Resources'),
              onTap: () async {
                final Uri formurl = Uri.parse(
                    'https://edindia.org.in/teachable/teachable-resources/');
                if (!await launchUrl(formurl)) {
                  throw 'Could not launch $formurl';
                }
              }),
          ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('Archived Webinar'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ArchivedWebinar()));
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Edindia'),
              onTap: () async {
                final Uri formurl = Uri.parse('https://edindia.org/');
                if (!await launchUrl(formurl)) {
                  throw 'Could not launch $formurl';
                }
              }),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Log Out'),
            onTap: () async {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EmailLoginPage()),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
