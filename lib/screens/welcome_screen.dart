import 'package:chats_io/screens/login_screen.dart';
import 'package:chats_io/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chats_io/SelectButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomescreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    animation =
        ColorTween(begin: Colors.yellow, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      //print(animation.value);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
                wColor: Colors.lightBlueAccent,
                onpressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                Text1: 'Log In'),
            RoundButton(
                wColor: Colors.blueAccent,
                onpressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                Text1: 'Register'),
          ],
        ),
      ),
    );
  }
}
