import 'package:face_recognition_application/api/fetching/auth_fetch.dart';
import 'package:face_recognition_application/screens/attendance_history_screen.dart';
import 'package:face_recognition_application/screens/attendance_screen.dart';
import 'package:face_recognition_application/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> verifyToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // final authToken = prefs.getString('token');
    // final token = await Auth.verifToken(authToken!);

    // if (token?["message"] == 401) {
    //   Navigator.pushReplacementNamed(context, '/login');
    //   await prefs.remove('token');

    //   // Navigasi atau aksi setelah login berhasil
    // }
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedPage),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.redAccent,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.calendarCheck,
                  text: 'My attendace',
                ),
                GButton(
                  icon: LineIcons.userCheck,
                  text: 'Attendace',
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
    );
  }
}
