import 'package:boat_controller/model/controller.dart';
import 'package:boat_controller/ui/pages/connection_page/connection_progress_page.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final formKey = GlobalKey<FormState>();

class ConnectionFormPage extends StatefulWidget {
  const ConnectionFormPage({super.key});

  @override
  State<ConnectionFormPage> createState() => _ConnectionFormPageState();
}

class _ConnectionFormPageState extends State<ConnectionFormPage> {
  late Size mediaSize;
  Controller? controller;

  String? valueChoose;
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;
  bool isIpValid = true;

  TextEditingController ipAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    ipAddressController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> setMonitoringConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> data = {
      'location': valueChoose.toString(),
      'ipAddress': ipAddressController.text.toString(),
    };

    for (var entry in data.entries) {
      await prefs.setString(entry.key, entry.value);
    }
  }

  String? validateIpAddress(String? ipAddress) {
    if (ipAddress == null || ipAddress.isEmpty) {
      return 'Please fill a number value';
    }

    int? number;
    try {
      number = int.parse(ipAddress);
    } catch (e) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return 'Please fill a number more than 0';
    }

    return null;
  }

  // data dumy
  List<String> listItem = [
    "Danau itk",
    "Waduk manggar",
    "Danau bpp",
    "test1",
    "test2",
    "test3",
    "Test4",
  ];

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage('assets/images/lake.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: buildTop()),
            Positioned(
                bottom: -5, right: -3, left: -3, child: buildBottom(context))
          ],
        ),
      ),
    );
  }

  Widget buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/WDP Logo Controller.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      spreadRadius: 3,
                    )
                  ],
                  shape: BoxShape.circle)),
          const SizedBox(
            height: 20,
          ),
          Text("WDP CONTROLLER",
              style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                  letterSpacing: 1))
        ],
      ),
    );
  }

  Widget buildBottom(context) {
    return SizedBox(
        width: mediaSize.width,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                buildForm(),
                const SizedBox(
                  height: 40,
                ),
                buildConnectButton(context)
              ],
            ),
          ),
        ));
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monitoring Configuration",
          style: GoogleFonts.firaSans(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
        buildText("Please fill out the form before using WDP", 15),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on_sharp,
              color: Colors.red,
              size: 30.0,
            ),
            const SizedBox(
              width: 5,
            ),
            buildText("Monitoring Location", 19),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        buildDropdownField(),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Image.asset(
              'assets/icons/ip-address.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            buildText("Boat IP Address", 19),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        buildInputField(ipAddressController),
      ],
    );
  }

  Widget buildText(String text, double fontSize) {
    return Text(text,
        style: GoogleFonts.firaSans(
            fontSize: fontSize, color: Colors.grey.shade800));
  }

  // ip address input field
  Widget buildInputField(TextEditingController controller) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.blue.shade300,
            controller: controller,
            focusNode: focusNode,
            // keyboardType: TextInputType.number,
            validator: validateIpAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Example: 192.168.1.56:80',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField() {
    // String value = "";
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade300, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        menuMaxHeight: 200,
        padding: const EdgeInsets.only(left: 10, right: 10),
        hint: Text(
          'choose location',
          style: GoogleFonts.firaSans(color: Colors.grey.shade800),
        ),
        isExpanded: true,
        iconSize: 30,
        iconEnabledColor: Colors.blue.shade300,
        underline: const SizedBox(),
        value: valueChoose,
        onChanged: (newValue) {
          setState(() {
            valueChoose = newValue;
          });
        },
        items: [
          // DropdownMenuItem(
          //     value: value,
          //     child: Text(
          //       value,
          //       style: GoogleFonts.firaSans(color: Colors.grey.shade800),
          //     )),
          ...listItem.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Text(
                valueItem,
                style: GoogleFonts.firaSans(color: Colors.grey.shade800),
              ),
            );
          }),
          DropdownMenuItem(
            value: "add button",
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newLocation = '';
                    return SizedBox(
                      child: AlertDialog(
                        title: buildText("Add Monitoring Location", 18),
                        content: Form(
                          child: TextFormField(
                            onChanged: (value) {
                              newLocation = value;
                            },
                            cursorColor: Colors.blue.shade300,
                            validator: (nameLocation) =>
                                nameLocation!.length <= 3
                                    ? 'Location Name should more than 3 letters'
                                    : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              hintText: 'Example: Danau ITK',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade300, width: 1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (listItem.contains(newLocation)) {
                                  buildSnackBar(
                                      context,
                                      Colors.orange,
                                      Icons.warning_amber_outlined,
                                      "Location name already exists");
                                } else {
                                  if (newLocation.isNotEmpty) {
                                    valueChoose = newLocation;
                                    if (!listItem.contains(newLocation)) {
                                      listItem.add(newLocation);
                                    }
                                    buildSnackBar(
                                        context,
                                        Colors.green,
                                        Icons.done_rounded,
                                        "Location name successfuly added");
                                  }
                                }
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Add',
                                style: GoogleFonts.firaSans(
                                    color: Colors.grey.shade800)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                elevation: 5,
                backgroundColor: Colors.blue.shade300,
              ),
              child: Text('Add Location',
                  style: GoogleFonts.firaSans(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Connect button
  Widget buildConnectButton(context) {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            setMonitoringConfiguration();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ConnectionProgressPage(
                  id: ipAddressController.text,
                  iconSize: 350,
                  potrait: true,
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 5,
            backgroundColor: Colors.blue.shade300,
            shadowColor: Colors.blue.shade400,
            minimumSize: const Size.fromHeight(60)),
        child: Text('CONNECT',
            style: GoogleFonts.firaSans(
                color: Colors.white, fontWeight: FontWeight.w400)));
  }

  void buildSnackBar(
      BuildContext context, MaterialColor color, IconData icon, String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color.shade300,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 25.0,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              info,
              style: GoogleFonts.firaSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )));
  }
}
