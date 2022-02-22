import 'package:flutter/material.dart';
import 'package:secret_diary_two/screens/home_screen.dart';
import '../services/auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  var confirmPasswordTextController = TextEditingController();
  var isLogin = false;

  void _validate(BuildContext context) async {
    var em = emailTextController.text.isEmpty;
    var ps = passwordTextController.text.isEmpty;
    var cp = confirmPasswordTextController.text.isEmpty;
    if (isLogin && !em && !ps) {
      await Auth().loginWithEmail(
          emailTextController.text, passwordTextController.text);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else if (!isLogin &&
        !em &&
        !ps &&
        !cp &&
        passwordTextController.text == confirmPasswordTextController.text) {
      await Auth().signInWithEmail(
          emailTextController.text, passwordTextController.text);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Container(
            height: 380,
            width: 300,
            child: Card(
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Secret Diary',
                    style: TextStyle(fontSize: 23),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(labelText: 'Enter email...'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: TextField(
                      controller: passwordTextController,
                      decoration: InputDecoration(labelText: 'Enter password'),
                    ),
                  ),
                  if (!isLogin)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: TextField(
                        controller: confirmPasswordTextController,
                        decoration:
                            InputDecoration(labelText: 'Confirm password'),
                      ),
                    ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child:
                          Text(isLogin ? 'SignUp Instead' : 'Login Instead')),
                  TextButton(
                      onPressed: () {
                        _validate(context);
                      },
                      child: Text(isLogin ? 'Login' : 'Sign Up'))
                ],
              ),
            ),
          ),
        ));
  }
}
