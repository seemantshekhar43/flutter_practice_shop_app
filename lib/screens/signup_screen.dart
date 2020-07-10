import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/background.dart';
import 'package:shopapp/widgets/custom_alert_dialog.dart';
import 'login_screen.dart';
import 'product_overview_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe1e2e1),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff431f47),
      ),
      body: Background(
        child: Padding(
          padding: EdgeInsets.only(
              top: 20.0, left: size.width * 0.1, right: size.width * 0.1),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _termsValue = false;
  bool _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void showAlertDialog(String message){
    final size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          contentText: message,
          actions: <Widget>[

            FlatButton(
              padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: size.width * 0.08),
              color: Color(0xff1B001B),
              onPressed: () {
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0),
              ),
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        barrierDismissible: false);

  }

  void signUp() async{
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    if (!_termsValue) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Check Privacy Policy to continue',
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      await Provider.of<Auth>(context, listen: false)
          .signUp(_authData['email'], _authData['password']);
      Navigator.of(context).pushNamed(LoginScreen.routeName);

    } on HttpException catch(error){
      var errorMessage  ='Failed to sign up';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'Email already exists';
      }else if(error.toString().contains('OPERATION_NOT_ALLOWED')){
        errorMessage = 'Sign Up disabled';
      }else if(error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')){
        errorMessage = 'Too many attempts, try later';
      }
      showAlertDialog(errorMessage);
    }
    catch(error){
      var errorMessage = 'An error occurred';
      showAlertDialog(errorMessage);
    }

    setState(() {
    _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Sign Up",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26.0),
            ),
            SizedBox(height: size.height * 0.05),
            InputWithLabel(
              textFormField: TextFormField(
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration:
                    InputDecoration(hintText: '', border: InputBorder.none),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email can\'t be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value;
                },
              ),
              label: 'Email',
              //hint: 'Enter Mobile',
            ),
            SizedBox(height: size.height * 0.04),
            InputWithLabel(
              label: 'Password',
              textFormField: TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration:
                    InputDecoration(hintText: '', border: InputBorder.none),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password can\'t be empty';
                  } else if (value.length < 8) {
                    return 'Password can\'t be less than 8 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),

              //hint: 'Enter Password',
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xff1B001B),
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.width * 0.01),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff1B001B), width: 3.0),
                  ),
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Color(0xffE1E2E1)),
                    child: Checkbox(
                      activeColor: Color(0xffE1E2E1),
                      checkColor: Color(0xff1B001B),
                      value: _termsValue,
                      onChanged: (_) {
                        setState(() {
                          _termsValue = !_termsValue;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                Expanded(
                    child: Text(
                  'By logging in, I accept the Privacy Policy and Terms of Services of Power2Create.',
                  style: TextStyle(fontSize: 15.0),
                )),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              child: Center(
                child: (_isLoading)
                    ? CircularProgressIndicator(
                        backgroundColor: Color(0xff1B001B),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: size.height * 0.06),
                          color: Color(0xff1B001B),
                          onPressed: () {
                            signUp();
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              'Need Assistance?',
              style: TextStyle(
                color: Color(0xff1B001B),
              ),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class InputWithLabel extends StatelessWidget {
  final label;
  final textFormField;

  InputWithLabel({@required this.label, @required this.textFormField});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Color(0xffE1E2E1),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.17),
                blurRadius: 10.0, // soften the shadow
                //extend the shadow
                offset: Offset(
                    0.0, // Move to right 10  horizontally
                    5.0),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: textFormField,
        )
      ],
    );
  }
}
