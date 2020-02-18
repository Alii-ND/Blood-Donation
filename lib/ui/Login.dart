import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Login extends StatefulWidget {
  Login();

  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  int themeIndex;
  ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    _reelUserName = "n";
    // _reelPassword=generateMd5("n");
    var byte = utf8.encode("n");
    var d = crypto.sha512.convert(byte);
    _reelPassword = d.toString();
    //  _reelPassword = new DBCrypt().hashpw("n", DBCrypt().gensalt());
/*    print(_reelPassword);
    _reelPassword =
        "\$2y\$10\$pT.unkZSCWA0A4MMZR74tOqGX3qTXS3ii4jpeFMgpZPCDRHCtVf0u";
    print(_reelPassword);*/
  }

  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _userNameAutoVal = false, _passwordAutoVal = false;
  String _reelUserName, _reelPassword;

  Map colors;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          body: SafeArea(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(23),
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset(
                      "assets/icon/logo_original.svg",
                      width: 300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Container(
                      child: TextFormField(
                        autovalidate: _userNameAutoVal,
                        validator: (arg) {
                          return validation(_userName, arg);
                        },
                        controller: _userName,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context).tr('userName'),
                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _userNameFocus, _passwordFocus);
                        },
                        focusNode: _userNameFocus,
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      autovalidate: _passwordAutoVal,
                      validator: (arg) {
                        return validation(_password, arg);
                      },
                      style: TextStyle(
                          color: colors["color4"], fontFamily: 'SFUIDisplay'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context).tr('password'),
                          prefixIcon: Icon(Icons.lock_outline),
                          labelStyle: TextStyle(fontSize: 15)),
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocus,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () {
                        signin();
                      },
                      //since this is only a UI app
                      child: Text(
                        AppLocalizations.of(context).tr('login'),
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: colors["color5"],
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: colors["color3"],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                        child: GestureDetector(
                      child: Text(
                        AppLocalizations.of(context).tr('forget_password'),
                        style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/forgetPassword');
                      },
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Wrap(children: <Widget>[
                        Text(AppLocalizations.of(context).tr('registration'),
                            style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              color: colors["color4"],
                              fontSize: 15,
                            )),
                        GestureDetector(
                          child: Text(
                            AppLocalizations.of(context).tr('sign_up'),
                            style: TextStyle(
                              fontFamily: 'SFUIDisplay',
                              color: colors["color5"],
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/signup', (Route<dynamic> route) => false);
                          },
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        top: true,
        bottom: true,
        left: true,
        right: true,
      )),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  validation(from, arg) {
    if (from == _userName) {
      if (_userName.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _password) {
      if (_password.text == "")
        return AppLocalizations.of(context).tr('required');
    }
    return null;
  }

  signin() async {
    setState(() {
      _passwordAutoVal = true;
      _userNameAutoVal = true;
    });

    if (_userName.text.trim().isEmpty || _password.text.trim().isEmpty) {
    } else {
      ProgressDialog pr =
          AllSharedWidget(colors, theme).getProgressDialog(context);

      pr.show();
      InternetConnection internetConnection = InternetConnection();
      if (!await internetConnection.checkConn()) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            (Route<dynamic> route) => false);
        return;
      }
      DatabaseHandlerMysql db = DatabaseHandlerMysql();
      Map json = await (db.checkId(_userName.text.trim()));
      _reelUserName = _userName.text.trim();
      _reelPassword = json[db.userPassword];
      if (_reelUserName == null || _reelPassword == null) {
        pr.hide();
        CupertinoAlertDialog alt = CupertinoAlertDialog(
          title: Text(
              AppLocalizations.of(context).tr('email_or_password_incorrect')),
          // content: Text('your message '),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context).tr('ok')),
              onPressed: () {
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
      } else if (_reelUserName == _userName.text.trim() &&
          // _reelPassword == _password.text) {
          _reelPassword ==
              crypto.sha512.convert(utf8.encode(_password.text)).toString()) {
        pr.hide();
        if (await db.checkPoints(_reelUserName)) {
          CupertinoAlertDialog alt = CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).tr('bonus')),
            content: Text(AppLocalizations.of(context).tr('one_point_added')),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  _shared.set('bloodType', json[db.userBloodType]);
                  _shared.set('userId', _reelUserName);
                  _shared.set(
                      'point',
                      json[db.pointAmount] == null
                          ? 1
                          : int.parse(json[db.pointAmount]) + 1);
                  _shared.set('canDonation',
                      json[db.canDonation] == '1' ? true : false);
                  _shared.set('nextDonation',
                      json[db.canDonation] == '1' ? '' : json[db.canDonation]);
                  (_shared.get('sharedPreferences') as SharedPreferences)
                      .setString('userId', _reelUserName);
                  (_shared.get('sharedPreferences') as SharedPreferences)
                      .setString('password', _reelPassword);
                  //Navigator.of(context).pop();
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
          _shared.set('userId', _reelUserName);
          _shared.set(
              'point', json[db.pointAmount] == null ? 0 : json[db.pointAmount]);
          _shared.set(
              'canDonation', json[db.canDonation] == '1' ? true : false);
          _shared.set('nextDonation',
              json[db.canDonation] == '1' ? 'now' : json[db.canDonation]);
          (_shared.get('sharedPreferences') as SharedPreferences)
              .setString('userId', _reelUserName);
          (_shared.get('sharedPreferences') as SharedPreferences)
              .setString('password', _reelPassword);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      } else {
        pr.hide();
        CupertinoAlertDialog alt = CupertinoAlertDialog(
          title: Text(
              AppLocalizations.of(context).tr('email_or_password_incorrect')),
          // content: Text('your message '),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context).tr('ok')),
              onPressed: () {
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
  }

/*  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }*/
}
