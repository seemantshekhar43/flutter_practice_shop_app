import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(

        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,

            child: Image.asset(
              "assets/images/ellipse_bg3.png",
              height: size.height * 0.32,
              fit: BoxFit.fill,
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,

            child: Image.asset(
              "assets/images/ellipse_bg2.png",
              height: size.height * 0.29,
              fit: BoxFit.fill,
            ),
          ),


          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/ellipse_bg1.png",
             fit: BoxFit.cover,
                height: size.height*0.10,
            ),
          ),
          Positioned(
            bottom: 0,
            left: size.width * 0.12,
            child: Image.asset(
              "assets/images/ellipse_bg4.png",
              fit: BoxFit.cover,
              height: size.height*0.18,
            ),
          ),
          child,
        ],
      ),
    );
  }
}