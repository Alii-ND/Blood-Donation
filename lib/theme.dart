import 'dart:ui';

import 'package:flutter/material.dart';

class theme {
  var themes = [
    //ligth mode
    ThemeData(

        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(239, 71, 70, 1.0),
        primaryColorDark: Colors.green,
        cardColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        dialogTheme: DialogTheme(backgroundColor: Colors.white),
        primaryTextTheme: new TextTheme(
          display1: new TextStyle(color: Colors.green),
          display2: new TextStyle(color: Colors.white),
          title: TextStyle(color: Colors.white),
        ),
        fontFamily: 'SFUIDisplay',
    )

    ,

    //dark mode
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color.fromRGBO(239, 71, 70, 1.0),
      primaryColorDark: Color.fromRGBO(239, 71, 70, 1.0),
      cardColor: Color.fromRGBO(48, 48, 48, 1.0),
      dialogBackgroundColor: Color.fromRGBO(48, 48, 48, 1.0),
      dialogTheme:
          DialogTheme(backgroundColor: Color.fromRGBO(48, 48, 48, 1.0)),
      primaryTextTheme: new TextTheme(
        display1: new TextStyle(color: Colors.green),
        display2: new TextStyle(color: Colors.black),
        title: TextStyle(color: Colors.white),
      ),
      fontFamily: 'SFUIDisplay',

    ),
  ];

  var color = [
    //ligth mode
    {
      "color1": Colors.grey, //icon default color
      "color2": Colors.grey[100], //for background
      "color3": Colors.white, //for Text color
      "color4": Colors.black, //for Text color
      "color5": Color(0xffff2d55) ,
      "color6":Color.fromRGBO(239, 71, 70, 1.0)//for Text color
    },
    //dark mode
    {
      "color1": Colors.grey, //icon default color
      "color2": Colors.black, //for background
      "color3": Colors.white, //for Text color
      "color4": Colors.white, //for Text color
      "color5": Color(0xffff2d55),
      "color6":Color.fromRGBO(239, 71, 70, 1.0)//for Text color
    }
  ];
}
