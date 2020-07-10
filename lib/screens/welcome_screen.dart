import 'package:flutter/material.dart';
import 'package:shopapp/screens/login_screen.dart';
import 'package:shopapp/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {

  static const routeName = '/welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Shop App", style:
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
                color: Colors.black
              ),),
            SizedBox(height: 48.0,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: (){
                              Navigator.pushNamed(context, SignUpScreen.routeName);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
