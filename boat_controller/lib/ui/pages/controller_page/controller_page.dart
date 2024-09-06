import 'dart:developer';
import 'dart:async';

import 'package:boat_controller/model/controller.dart';
import 'package:boat_controller/ui/pages/connection_page/connection_progress_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ControllerPage extends StatefulWidget {
  final String location, ipAddress;
  const ControllerPage(
      {super.key, required this.location, required this.ipAddress});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  Controller? controller;
  Color buttonColor = Colors.blue.shade100;
  Timer? _timer;
  String messValue = "OFF";
  String? ipAddress;
  String? location;
  bool isPressedLeft = false;
  bool isPressedRight = false;
  bool isPressedGas = false;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void changeMessage() {
    setState(() {
      if (isSwitched) {
        messValue = "ON";
      } else {
        messValue = "OFF";
      }
    });
  }

  void handleOnPressed(BuildContext context, direction, command) {
    log('succes: $direction');

    handleApiRequest(false, context, direction);
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 150), () {
      handleApiRequest(true, context, command);
      log('succes: $command');
    });
  }

  Future<void> handleApiRequest(bool showAlert, context, path) async {
    log('succes: $path');
    try {
      Controller result = await Controller.getApi(path);
      setState(() {
        controller = result;
      });
      log('succes: $path');
    } catch (e) {
      if (showAlert) {
        setState(() {
          isPressedGas = false;
          isPressedLeft = false;
          isPressedRight = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              // height: 350,
              // width: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  Lottie.asset('assets/icons/connection lost.json',
                      width: 200, height: 200),
                  // Text('Failed to load data: $e'),
                  Text(
                    'Disconnect !!!',
                    style: GoogleFonts.firaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/jumpToControllerPage');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Colors.blue.shade300,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 25,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Back home',
                                style: GoogleFonts.firaSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ConnectionProgressPage(
                                id: widget.ipAddress,
                                iconSize: 290,
                                potrait: false,
                              ), // Kirim parameter id
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.grey.shade500,
                        ),
                        child: const Icon(
                          Icons.refresh_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
      log('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, '/jumpToControllerPage');
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, // This sets the color for the text and icon
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Water Drone Patrol Controller",
              style: GoogleFonts.firaSans(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(width: 1, color: Colors.white))),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_sharp,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.location,
                        style: GoogleFonts.firaSans(
                            fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/ip-address.png',
                        width: 23,
                        height: 23,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.ipAddress,
                        style: GoogleFonts.firaSans(
                            fontSize: 17, color: Colors.white),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(93, 174, 255, 1.0),
        shadowColor: Colors.black54,
        elevation: 20,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isPressedLeft = true;
                          });
                          handleApiRequest(true, context, 'left');
                        },
                        onLongPressUp: () {
                          setState(() {
                            isPressedLeft = false;
                          });
                          handleApiRequest(true, context, 'idle');
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            handleOnPressed(context, 'left', 'idle');
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) {
                                  if (isPressedLeft) {
                                    return buttonColor;
                                  } else if (!isPressedLeft) {
                                    return Colors.white;
                                  }
                                  return null;
                                },
                              ),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.blue.shade100.withOpacity(0.5))),
                          child: Image.asset(
                            'assets/icons/arrow-left.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            isPressedRight = true;
                          });
                          handleApiRequest(true, context, 'right');
                        },
                        onLongPressUp: () {
                          setState(() {
                            isPressedRight = false;
                          });
                          handleApiRequest(true, context, 'idle');
                        },
                        child: ElevatedButton(
                            onPressed: () {
                              handleOnPressed(context, 'right', 'idle');
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (isPressedRight) {
                                      return buttonColor;
                                    } else if (!isPressedRight) {
                                      return Colors.white;
                                    }
                                    return null;
                                  },
                                ),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.blue.shade100.withOpacity(0.5))),
                            child: Image.asset(
                              'assets/icons/arrow-right.png',
                              width: 80,
                              height: 80,
                            )),
                      ),
                    ],
                  ),

                  Container(
                    width: 240,
                    // height: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(131, 187, 222, 251),
                      borderRadius:
                          BorderRadius.circular(15), // Radius sudut 15
                    ),
                    child: SwitchListTile(
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Detection ',
                              style: GoogleFonts.firaSans(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: messValue,
                              style: GoogleFonts.firaSans(
                                fontWeight: FontWeight.bold,
                                color: isSwitched ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          changeMessage();
                        });
                        log('$isSwitched');
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                  // Space between rows
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        isPressedGas = true;
                      });
                      handleApiRequest(true, context, 'gas');
                    },
                    onLongPressUp: () {
                      setState(() {
                        isPressedGas = false;
                      });
                      handleApiRequest(true, context, 'nogas');
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        handleOnPressed(context, "gas", "nogas");
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(25)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (isPressedGas) {
                                return buttonColor;
                              } else if (!isPressedGas) {
                                return Colors.white;
                              }
                              return null;
                            },
                          ),
                          overlayColor: MaterialStateProperty.all(
                              Colors.blue.shade100.withOpacity(0.5))),
                      // style: ElevatedButton.styleFrom(
                      //     padding: const EdgeInsets.all(25)),
                      child: Image.asset(
                        'assets/icons/pedal.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
