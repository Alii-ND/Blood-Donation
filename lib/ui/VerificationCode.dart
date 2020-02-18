import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Pesron.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:math' as Math;

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class VerificationCode extends StatefulWidget {
  VerificationCode();

  @override
  State<StatefulWidget> createState() {
    return new VerificationCodeState();
  }
}

class VerificationCodeState extends State<VerificationCode>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  /// this [StreamController] will take input of which function should be called
  String lang;
  ThemeData theme;
  bool hasError = false;
  String currentText = "";
  GlobalState _shared = GlobalState.instance;
  int themeIndex;
  Map colors;
  Person person;
  String verificationCode;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    person = _shared.get("person");
    verificationCode = _shared.get("vrcode");
    verificationCode = "12345";
    print(person.email);
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];

    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: 150.0, end: 200.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        animationController.reverse();
      else if (status == AnimationStatus.dismissed)
        animationController.forward();
    });
    animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int time_inter = 1;
  Timer _timer;
  int _start = 60;
  String _time = "";
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        key: scaffoldKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  width: 250,
                  height: 250,
                  child: LogoAnimation(
                    animation: animation,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    AppLocalizations.of(context).tr('emailVerification'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                        text:
                            AppLocalizations.of(context).tr('enter_code_send'),
                        children: [
                          TextSpan(
                              text: person.email,
                              style: TextStyle(
                                  color: colors["color4"],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                        style:
                            TextStyle(color: colors["color1"], fontSize: 15)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    length: 5,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.underline,
                    textInputType: TextInputType.numberWithOptions(),
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    textStyle: TextStyle(color: colors["color4"], fontSize: 20),
                    backgroundColor: theme.cardColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  // error showing widget
                  child: Text(
                    hasError
                        ? AppLocalizations.of(context)
                            .tr('errorVerificationCode')
                        : "",
                    style: TextStyle(color: colors["color5"], fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _start == 0
                    ? Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  AppLocalizations.of(context).tr('notReceive'),
                              style: TextStyle(
                                  color: colors["color1"], fontSize: 15),
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)
                                        .tr('resend'),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (_start == 0) {
                                          send_email();
                                          setState(() {
                                            _start = 60 * time_inter;
                                          });
                                          startTimer();
                                        }
                                      },
                                    style: TextStyle(
                                        color: colors["color5"],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                              ]),
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_start == 0) {
                              send_email();
                              setState(() {
                                _start = 60 * time_inter;
                              });
                              startTimer();
                            }
                          },
                          child: Text(_time),
                        ),
                      ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      onPressed: () async {
                        // conditions for validating
                        if (currentText.length != 5 ||
                            currentText != verificationCode) {
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            hasError = false;
                          });
                          DatabaseHandlerMysql db = DatabaseHandlerMysql();
                          Map<String, dynamic> data = person.toJson();
                          data[db.settingsLanguage] = lang;
                          data[db.settingsZone] = 10;
                          if (await db.setUser(data)) {
                            SharedPreferences sharedPreferences = _shared
                                .get("sharedPreferences") as SharedPreferences;
                            sharedPreferences.setString("userId", person.id);
                            sharedPreferences.setString(
                                "password", person.password);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => MyApp()),
                                (Route<dynamic> route) => false);
                          } else {
                            CupertinoAlertDialog alt = CupertinoAlertDialog(
                              title: Text(AppLocalizations.of(context)
                                  .tr('userName_already_exist')),
                              // content: Text('your message '),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text(
                                      AppLocalizations.of(context).tr('ok')),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                            showDialog(
                              context: context,
                              builder: (a) {
                                return Theme(
                                  data: theme,
                                  child: alt,
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context).tr('verify').toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: colors["color5"],
                    borderRadius: BorderRadius.circular(5),
                    /*  boxShadow: [
                        BoxShadow(
                            color: (colors["color5"] as MaterialColor).shade200,
                            offset: Offset(1, -2),
                            blurRadius: 5),
                        BoxShadow(
                            color: colors["color5"].shade200,
                            offset: Offset(-1, 2),
                            blurRadius: 5)
                      ]*/
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    //  print('1');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted)
          _timer.cancel();
        else
          setState(
            () {
              if (_start < 1) {
                timer.cancel();
                _time = AppLocalizations.of(context).tr('resend_sms');
                time_inter = time_inter + 1;
              } else {
                _time = AppLocalizations.of(context).tr('time_to_send') +
                    ' $_start ' +
                    AppLocalizations.of(context).tr('second');
                _start = _start - 1;
                //  print(_start);
              }
            },
          );
      },
    );
  }

  send_email() async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    verificationCode =
        ((Math.Random().nextDouble() * (100000 - 10000)).floor() + 10000)
            .toString();
    db.sendEmail_Email(person.email, verificationCode, lang);
  }
}

class LogoAnimation extends AnimatedWidget {
  LogoAnimation({Key key, Animation animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Center(
        child: Container(
            width: animation.value as double,
            height: animation.value as double,
            child: Image.asset(
              'assets/icon/logo_original.png',
            )));
  }
}
