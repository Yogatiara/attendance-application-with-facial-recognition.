import 'package:face_recognition_application/api/fetching/auth_fetch.dart';
import 'package:face_recognition_application/api/model/error_model.dart';
import 'package:face_recognition_application/api/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:face_recognition_application/font/font_style.dart';

final formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  late Size mediaSize;
  bool isPasswordVisible = false;
  bool isLoading = false;
  bool isDisable = false;

  TextEditingController nimController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final FocusNode nimFocusNode = FocusNode();
  final FocusNode passFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    nimController.dispose();
    passController.dispose();
    nimFocusNode.dispose();
    passFocusNode.dispose();

    super.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    final nim = int.parse(nimController.text);
    final password = passController.text;

    final res = await Auth.login(nim, password);

    setState(() {
      isLoading = false;
    });

    if (res is UserModel) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message),
          backgroundColor:
              Colors.green, // Menambahkan warna merah pada SnackBar
        ),
      );
      setState(() {
        isDisable = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/attendance');
      });
    } else if (res is ErrorModel) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.detail),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    double screenWidth = mediaSize.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.redAccent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          children: [
            Positioned(top: 52, child: buildTop()),
            Positioned(
                bottom: -5,
                right: -3,
                left: -3,
                child: buildBottom(context, screenWidth))
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
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/icons_app/AttendMe.png',
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
            height: 10,
          ),
          Text("AttendMe",
              style: GoogleFonts.firaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 35,
                  letterSpacing: 1))
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context, double screenWidth) {
    return SizedBox(
        width: mediaSize.width,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                buildForm(screenWidth),
              ],
            ),
          ),
        ));
  }

  Widget buildForm(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FontStyle.buildText("Welcome", screenWidth / 15, Colors.redAccent),
        FontStyle.buildText("Please login before doing attendance",
            screenWidth / 25, Colors.black38),
        const SizedBox(
          height: 40,
        ),
        Text(
          "NIM",
          style: FontStyle.textStyle(
              screenWidth / 20, Colors.redAccent, FontWeight.w400),
        ),
        buildInputField(
            nimController, nimFocusNode, "Example: 1121....", false),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Password",
          style: FontStyle.textStyle(
              screenWidth / 20, Colors.redAccent, FontWeight.w400),
        ),
        buildInputField(
            passController, passFocusNode, "Enter your password", true),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                backgroundColor: Colors.transparent,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                "Forgot password",
                style: FontStyle.textStyle(
                    screenWidth / 25, Colors.redAccent, FontWeight.w700),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        buildLoginButton(screenWidth),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You don't have an account?",
              style: FontStyle.textStyle(
                  screenWidth / 25, Colors.black, FontWeight.w400),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                backgroundColor: Colors.transparent,
              ).copyWith(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                "Register",
                style: FontStyle.textStyle(
                    screenWidth / 23, Colors.redAccent, FontWeight.w700),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildInputField(TextEditingController controller, FocusNode focusNode,
      String hintText, bool isPassword) {
    return TextFormField(
      cursorColor: Colors.redAccent,
      controller: controller,
      focusNode: focusNode,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: isPassword
          ? TextInputType.visiblePassword
          : TextInputType.number, // Set keyboard type
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : const Icon(Icons.numbers, color: Colors.redAccent),
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  Widget buildLoginButton(double screenWidth) {
    return ElevatedButton(
      onPressed: isLoading || isDisable
          ? null
          : () async {
              if (nimController.text.isEmpty && passController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('NIM and password cannot be empty'),
                    backgroundColor: Colors.red[400],
                  ),
                );
              } else if (nimController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('NIM cannot be empty'),
                    backgroundColor: Colors.red[400],
                  ),
                );
              } else if (passController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Password  cannot be empty'),
                    backgroundColor: Colors.red[400],
                  ),
                );
              } else {
                loginUser();
              }
            },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 8,
        backgroundColor: Colors.redAccent,
        shadowColor: Colors.red,
        minimumSize: const Size.fromHeight(60),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isLoading || isDisable) {
            return Colors.redAccent; // Set color for disabled state
          }
          return Colors.redAccent;
        }),
        shadowColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isLoading || isDisable) {
              return Colors.red; // Set shadow color for disabled state
            }
            return Colors.red;
          },
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Login',
              style: FontStyle.textStyle(
                screenWidth / 20,
                Colors.white,
                FontWeight.w400,
              ),
            ),
    );
  }
}
