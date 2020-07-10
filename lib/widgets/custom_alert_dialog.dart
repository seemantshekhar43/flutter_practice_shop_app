import 'package:flutter/material.dart';


class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {Key key, @required this.actions, this.titleText, this.contentText})
      : super(key: key);

  final actions;
  final titleText;
  final contentText;
  static const kBackgroundColor = Color(0xffE1E2E1);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(
          buttonBarTheme:
          ButtonBarThemeData(alignment: MainAxisAlignment.spaceEvenly)),
      child: AlertDialog(
          backgroundColor: kBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(titleText),
          content: Text(
            contentText,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
          ),
          contentPadding: EdgeInsets.only(
            top: size.height * 0.035,
            bottom: size.height * 0.01,
          ),
          actions: actions),
    );
  }
}
