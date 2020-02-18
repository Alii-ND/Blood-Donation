import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import 'package:life_saver/ui/ForgetPassword.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "../theme.dart" as th;

class Initial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InitialState();
  }
}

class InitialState extends State<Initial> {
  var data, theme;
  GlobalState _shared = GlobalState.instance;
  bool connection = true;

  @override
  void initState() {
    super.initState();
    data = _shared.get("data");
    theme = _shared.get("data");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkConnection();
    });
  }

  SharedPreferences sharedP;

  Future<int> sharedPreferences() async {
    sharedP = await SharedPreferences.getInstance();
  }

  getLanguage() {
    return ui.window.locale.languageCode;
  }

  int themeIndex;
  String lang = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Color.fromRGBO(239, 71, 70, 1.0),
        child: Stack(
          children: <Widget>[
            Center(
              child: GestureDetector(
                child: SvgPicture.asset(
                  "assets/icon/logo_white.svg",
                  width: 450,
                ),
                //  Image.asset("assets/icon/logo_white.png")
              ),
            ),
            connection
                ? Center()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 2.0,
                      animation: true,
                      percent: 1 - _start * 0.2,
                      center: new Text(
                        (_start).toString(),
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      footer: new Text(
                        AppLocalizations.of(context).tr('connecting'),
                        style:
                            new TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  getData(context) {
    sharedPreferences().whenComplete(() async {
      bool qDarkmodeEnable;
      try {
        var qdarkMode = MediaQuery.of(context).platformBrightness;
        if (qdarkMode == Brightness.dark) {
          qDarkmodeEnable = true;
        } else {
          qDarkmodeEnable = false;
        }
//      print('mode .....................................');
//      print(qDarkmodeEnable);

        int x1 = sharedP.getInt('theme') ?? 0;
        if (x1 == 0) {
          if (!qDarkmodeEnable) {
            themeIndex = 0;
          } else {
            themeIndex = 1;
          }
        } else {
          themeIndex = x1 - 1;
        }

        String x = sharedP.getString('lang') ?? "d";
        if (x == "d" || x == null) {
          lang = getLanguage();
        } else {
          lang = x;
        }

//      print(
//          '------------------------------------------------------------------------------------------------');
//      print('$lang    $themeIndex');

        if (lang == "ar") {
          data.changeLocale(Locale("ar", "LB"));
        } else if (lang == "fr") {
          data.changeLocale(Locale("fr", "FR"));
        } else {
          data.changeLocale(Locale("en", "US"));
        }
        theme = th.theme().themes[themeIndex];
        _shared.set("theme", theme);
        _shared.set("themeIndex", themeIndex);
        _shared.set("themeD", x1);
        _shared.set("lang", lang);
        _shared.set("langD", x);
        //print("themeIndex $themeIndex ,themeD $x1, lang $lang, LANGD $x");
        _shared.set("sharedPreferences", sharedP);
        bool can = false;
        String userId = sharedP.get('userId');
        Map json;

        DatabaseHandlerMysql db = DatabaseHandlerMysql();
        if (userId != null) {
          String password = sharedP.get('password');

          json = await (db.checkId(userId));
          if (json[db.userPassword] == password) {
            can = true;
          } else {
            can = false;
            sharedP.remove("userId");
            sharedP.remove("password");
          }
        } else {
          can = false;
        }
        //Future.delayed(Duration(seconds: 2));
//        _shared.set('bloodType', 'O+');
//        _shared.set('userId', "NOON_TECH");
//        _shared.set('point', 25);

        //change navigation bar color
        if (themeIndex == 1)
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor:
                (theme as ThemeData).cardColor, // navigation bar color
            //   statusBarColor: Colors.pink, // status bar color
            // systemNavigationBarIconBrightness: Brightness.light,
            // systemNavigationBarDividerColor:th.theme().color[themeIndex]["color4"],
          ));

        if (can) {
          bool addPoint=await db.checkPoints(userId);
          if (addPoint) {
         
            CupertinoAlertDialog alt = CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).tr('bonus')),
              content: Text(AppLocalizations.of(context).tr('one_point_added')),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context).tr('ok')),
                  onPressed: () {
                    _shared.set('bloodType', json[db.userBloodType]);
                    _shared.set('userId', userId);
                    _shared.set(
                        'point',
                        json[db.pointAmount] == null
                            ? 1
                            : (int.parse(json[db.pointAmount]) + 1));
                    _shared.set('canDonation',
                        json[db.canDonation] == '1' ? true : false);
                    _shared.set(
                        'nextDonation',
                        json[db.canDonation] == '1'
                            ? ''
                            : json[db.canDonation]);
                    // Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (Route<dynamic> route) => false);
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
          } else {
            _shared.set('bloodType', json[db.userBloodType]);
            _shared.set('userId', userId);
            _shared.set('point',
                json[db.pointAmount] == null ? 0 : json[db.pointAmount]);
            _shared.set(
                'canDonation', json[db.canDonation] == '1' ? true : false);
            _shared.set('nextDonation',
                json[db.canDonation] == '1' ? '' : json[db.canDonation]);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (Route<dynamic> route) => false);
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
        }
//        Navigator.pushNamedAndRemoveUntil(
//            context, '/home', (Route<dynamic> route) => false);
      } on Exception catch (_) {}
    });
  }

  checkConnection() async {
    if (await InternetConnection().checkConn()) {
      connection = true;
      getData(context);
    } else {
      setState(() {
        connection = false;
      });
      startTimer();
    }
  }

  Timer _timer;
  int _start = 5;

  void startTimer() {
    //  print('1');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _start = 5;
            checkConnection();
          } else {
            setState(() {
              _start = _start - 1;
            });
          }
        },
      ),
    );
  }
}
