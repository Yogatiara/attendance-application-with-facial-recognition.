import 'package:face_recognition_application/api/fetching/auth_fetch.dart';
import 'package:face_recognition_application/provider/attendance_provider.dart';
import 'package:face_recognition_application/screens/attendance_history_screen.dart';
import 'package:face_recognition_application/screens/attendance_screen.dart';
import 'package:face_recognition_application/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jump_to_login.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with WidgetsBindingObserver {
  int _selectedPage = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    AttendanceHistoryScreen(),
    AttendanceScreen(),
    ProfileScreen(),
  ];

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> verifyToken() async {
    final getToken = await _getToken();
    final res = await Auth.verifyToken(getToken!);
    if (res?.statusCode == 401) {
      jumpToLogin(context);
    }
  }

  @override
  void initState() {
    super.initState();
    verifyToken();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      verifyToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AttendanceProvider>(
      create: (BuildContext context) => AttendanceProvider(),
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedPage),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))
          ]),
          child: Consumer<AttendanceProvider>(
            builder: (BuildContext context, AttendanceProvider attendanceProvider, _) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: IgnorePointer(
                  ignoring: attendanceProvider.isLoading,
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: Colors.redAccent,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: Colors.black,
                    tabs: const [
                      GButton(
                        icon: LineIcons.calendarCheck,
                        text: 'My attendance',
                      ),
                      GButton(
                        icon: LineIcons.userCheck,
                        text: 'Attendance',
                      ),
                      GButton(
                        icon: LineIcons.user,
                        text: 'Profile',
                      ),
                    ],
                    selectedIndex: _selectedPage,
                    onTabChange: (index) {
                      setState(() {
                        _selectedPage = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
