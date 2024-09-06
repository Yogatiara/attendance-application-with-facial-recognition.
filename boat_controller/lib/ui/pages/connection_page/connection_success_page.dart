import 'package:boat_controller/ui/font/app_font.dart';
import 'package:boat_controller/ui/pages/controller_page/controller_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionSuccessPage extends StatefulWidget {
  final double iconSize;
  final bool potrait;
  const ConnectionSuccessPage(
      {super.key, required this.iconSize, required this.potrait});

  @override
  State<ConnectionSuccessPage> createState() => _ConnectionSuccessPageState();
}

class _ConnectionSuccessPageState extends State<ConnectionSuccessPage> {
  late AppFonts appFonts;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      getMonitoringConfiguration(context);
    });

    super.initState();
    appFonts = AppFonts();
  }

  Future<void> getMonitoringConfiguration(context) async {
    final prefs = await SharedPreferences.getInstance();

    String locationValue = prefs.getString('location') ?? 'defaultLocation';
    String ipAddressValue = prefs.getString('ipAddress') ?? 'defaultIpAddress';
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ControllerPage(
            location: locationValue,
            ipAddress: ipAddressValue,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/icons/connection success.json',
                width: widget.iconSize, height: widget.iconSize),
            Text(
              'Connection success',
              style:
                  appFonts.connectLabel("connection success", widget.potrait),
            ),
          ],
        ),
      ),
    );
  }
}
