import 'package:boat_controller/ui/pages/connection_page/connection_form_page.dart';
import 'package:boat_controller/ui/pages/controller_page/jump_to_controller_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.blue.shade300,
        ),
      ),
      home: const ConnectionFormPage(),
      routes: {
        '/connectionFormPage': (context) => const ConnectionFormPage(),
        '/jumpToControllerPage': (context) => const JumpToControllerPage()
        // '/controllerPage': (context) => const ControllerPage()
      },
    );
    // return const ControllerPage();
    // return const ConnectionProgresPage();
  }
}
