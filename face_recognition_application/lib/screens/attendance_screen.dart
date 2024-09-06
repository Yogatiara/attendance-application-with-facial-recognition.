import 'package:face_recognition_application/font/font_style.dart';
import 'package:face_recognition_application/provider/date_time_provider.dart';
import 'package:face_recognition_application/provider/recognition_provider.dart';
import 'package:face_recognition_application/provider/slide_action_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DateTimeProvider()),
        ChangeNotifierProvider(
          create: (context) => RecognitionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SlideActionProvider(),
        )
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  FontStyle.buildText(
                      "Welcome", screenWidth / 20, Colors.black54),
                  FontStyle.buildText(
                      "Student", screenWidth / 17, Colors.redAccent),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 32),
              child: FontStyle.buildText(
                  "Today's status", screenWidth / 18, Colors.black),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 15),
              height: 85,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Consumer<DateTimeProvider>(
                builder: (BuildContext context,
                        DateTimeProvider dateTimeProvider, _) =>
                    Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FontStyle.buildText(
                            "Check in", screenWidth / 20, Colors.black54),
                        FontStyle.buildText(
                            dateTimeProvider.chekInTime?.split(" ")[0] ??
                                "--/--",
                            screenWidth / 20,
                            Colors.black54)
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FontStyle.buildText(
                            "Check out", screenWidth / 20, Colors.black54),
                        FontStyle.buildText(
                            dateTimeProvider.chekOutTime?.split(" ")[0] ??
                                "--/--",
                            screenWidth / 20,
                            Colors.black54)
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Consumer<DateTimeProvider>(
                builder: (BuildContext context,
                        DateTimeProvider dateTimeProvider, _) =>
                    RichText(
                        text: TextSpan(
                            text: dateTimeProvider.formattedDate?.split(" ")[0],
                            style: FontStyle.textStyle(screenWidth / 25,
                                Colors.redAccent, FontWeight.w500),
                            children: [
                      TextSpan(
                          text:
                              " ${dateTimeProvider.formattedDate?.split(" ")[1]} ${dateTimeProvider.formattedDate?.split(" ")[2]}",
                          style: FontStyle.textStyle(
                              screenWidth / 25, Colors.black, FontWeight.w500))
                    ])),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Consumer<DateTimeProvider>(
                  builder: (BuildContext context,
                          DateTimeProvider dateTimeProvider, _) =>
                      FontStyle.buildText(
                          dateTimeProvider.formattedTime.toString(),
                          screenWidth / 20,
                          Colors.black54),
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: screenWidth / 1.2,
              child: Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> _key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<RecognitionProvider>(
                      builder: (BuildContext context,
                              RecognitionProvider recognitionProvider, _) =>
                          Consumer<SlideActionProvider>(
                        builder: (BuildContext context,
                                SlideActionProvider slideActionProvider, _) =>
                            Consumer<DateTimeProvider>(
                          builder: (BuildContext context,
                                  DateTimeProvider dateTimeProvider, _) =>
                              SlideAction(
                            text: slideActionProvider.text,
                            textStyle: FontStyle.textStyle(screenWidth / 20,
                                Colors.redAccent, FontWeight.w500),
                            outerColor: Colors.white,
                            innerColor: Colors.redAccent,
                            key: _key,
                            onSubmit: () async {
                              print(dateTimeProvider.formattedTime.toString());
                              // Future.delayed(
                              //   Duration(seconds: 1),
                              //   () => _key.currentState!.reset(),
                              // );

                              // if (recognitionProvider.person?.name == null ||
                              //     recognitionProvider.person?.name ==
                              //         "unknown") {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text(
                              //           "Please take your face picture again"),
                              //     ),
                              //   );
                              // } else {
                              //   QuerySnapshot snap = await FirebaseFirestore
                              //       .instance
                              //       .collection("student")
                              //       .where(
                              //           'id') // sesuaikan userId dengan id pengguna
                              //       .get();

                              //   if (snap.docs.isNotEmpty) {
                              //     // Mendapatkan document ID
                              //     String docId = snap.docs[0].id;

                              //     // Update field checkIn dan checkOut

                              //     if (slideActionProvider.text ==
                              //         "Slide to check in") {
                              //       await FirebaseFirestore.instance
                              //           .collection("student")
                              //           .doc(docId)
                              //           .update({
                              //         "checkIn": dateTimeProvider.formattedTime
                              //             .toString(),
                              //         // "checkOut":
                              //         //     dateTimeProvider.formattedTime.toString()
                              //       });
                              //       slideActionProvider.setText =
                              //           "Slide to check out";
                              //       dateTimeProvider.setChekInTime =
                              //           dateTimeProvider.formattedTime
                              //               .toString();
                              //     } else if (slideActionProvider.text ==
                              //         "Slide to check out") {
                              //       await FirebaseFirestore.instance
                              //           .collection("student")
                              //           .doc(docId)
                              //           .update({
                              //         "checkOut": dateTimeProvider.formattedTime
                              //             .toString(),
                              //         // "checkOut":
                              //         //     dateTimeProvider.formattedTime.toString()
                              //       });
                              //       slideActionProvider.setText =
                              //           "Slide to check in";
                              //       dateTimeProvider.setChekoutTime =
                              //           dateTimeProvider.formattedTime
                              //               .toString();
                              //     }
                              //   } else {
                              //     print(
                              //         "User dengan ID tersebut tidak ditemukan");
                              //   }

                              //   print(snap.docs[0].id);
                              // }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Consumer<RecognitionProvider>(
                      builder: (BuildContext context,
                          RecognitionProvider recognitionProvider, _) {
                        return recognitionProvider.photoFile == null
                            ? Container(
                                width: 300,
                                height: 300,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/face-scan.png"))),
                              )
                            : Container(
                                width: 300,
                                height: 300,
                                child: Image.file(
                                  recognitionProvider.photoFile!,
                                  fit: BoxFit.fitHeight,
                                ),
                              );
                      },
                    ),
                    // Consumer<RecognitionProvider>(
                    //   builder: (BuildContext contetx,
                    //           RecognitionProvider recognitionProvider, _) =>
                    //       recognitionProvider.person?.name == null &&
                    //               recognitionProvider.person?.nim == null
                    //           ? Container(
                    //               padding: const EdgeInsets.symmetric(
                    //                   vertical: 15, horizontal: 20),
                    //               decoration: const BoxDecoration(
                    //                   color: Colors.white,
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                         color: Colors.black12,
                    //                         blurRadius: 10,
                    //                         offset: Offset(2, 2))
                    //                   ],
                    //                   borderRadius:
                    //                       BorderRadius.all(Radius.circular(20))),
                    //               child: Text(
                    //                 "Please take a picture of your face!!",
                    //                 style: FontStyle.textStyle(
                    //                     15, Colors.black54, FontWeight.w500),
                    //               ),
                    //             )
                    //           : Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 RichText(
                    //                     text: TextSpan(
                    //                         text: "Name : ",
                    //                         style: FontStyle.textStyle(
                    //                             screenWidth / 25,
                    //                             Colors.black,
                    //                             FontWeight.w500),
                    //                         children: [
                    //                       TextSpan(
                    //                           text: recognitionProvider
                    //                                   .person?.name ??
                    //                               "----",
                    //                           style: FontStyle.textStyle(
                    //                               screenWidth / 25,
                    //                               Colors.black54,
                    //                               FontWeight.w500))
                    //                     ])),
                    //                 const SizedBox(
                    //                   width: 20,
                    //                 ),
                    //                 RichText(
                    //                     text: TextSpan(
                    //                         text: "NIM : ",
                    //                         style: FontStyle.textStyle(
                    //                             screenWidth / 25,
                    //                             Colors.black,
                    //                             FontWeight.w500),
                    //                         children: [
                    //                       TextSpan(
                    //                           text: (recognitionProvider
                    //                                           .person?.nim
                    //                                           .toString() ==
                    //                                       "0"
                    //                                   ? "unknown"
                    //                                   : recognitionProvider
                    //                                       .person?.nim
                    //                                       .toString()) ??
                    //                               "----",
                    //                           style: FontStyle.textStyle(
                    //                               screenWidth / 25,
                    //                               Colors.black54,
                    //                               FontWeight.w500))
                    //                     ]))
                    //               ],
                    //             ),
                    // ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Consumer<RecognitionProvider>(
                        builder: (BuildContext context,
                                RecognitionProvider recognitionProvider, _) =>
                            TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      const CircleBorder()),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                                onPressed: () {
                                  recognitionProvider.recognition();
                                },
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Colors.redAccent,
                                )),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
