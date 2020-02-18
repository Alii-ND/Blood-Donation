import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;

import 'package:crypto/crypto.dart' as crypto;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../main.dart';
class ForgetPassword extends StatefulWidget {
  ForgetPassword();

  @override
  State<StatefulWidget> createState() {
    return new ForgetPasswordState();
  }
}

int themeIndex;
String lang;
ThemeData theme;

class ForgetPasswordState extends State<ForgetPassword> {
  GlobalState _shared = GlobalState.instance;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  int time_inter = 1;
  Timer _timer;
  int _start = 60;
  String _time = "";

  int index = 0;
  TextEditingController _textField = TextEditingController();
  TextEditingController _userName = TextEditingController();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _textFieldFocus = FocusNode();
  bool _textFieldAutoVal = false;
  String _verificationCode = "n";
  TextEditingController _password = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _repasswordFocus = FocusNode();
  bool _userNameAutoVal = false;
  bool _passwordAutoVal = false,
      _repasswordAutoVal = false,
      _enabledUserName = true,
      _enabledVerficationCode = true;

  Map colors;

  var pass;

  var confpass;
  String _next;
  var verificationC;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    if (_enabledUserName) {
      verificationC = Padding(
        padding: EdgeInsets.all(0),
      );
      _next = AppLocalizations.of(context).tr('next');
      pass = Container();
      confpass = Padding(
        padding: EdgeInsets.all(0),
      );
    } else if (_enabledVerficationCode) {
      _next = AppLocalizations.of(context).tr('next');
      verificationC = Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          child: TextFormField(
            autovalidate: _textFieldAutoVal,
            validator: (arg) {
              return validation(_textField, arg);
            },
            enabled: _enabledVerficationCode,
            controller: _textField,
            style:
                TextStyle(color: colors["color4"], fontFamily: 'SFUIDisplay'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).tr('verification_code'),
                prefixIcon: Icon(Icons.vpn_key),
                labelStyle: TextStyle(fontSize: 15)),
            focusNode: _textFieldFocus,
            textInputAction: TextInputAction.done,
          ),
        ),
      );
      pass = Container();
      confpass = Padding(
        padding: EdgeInsets.all(0),
      );
    } else {
      _next = AppLocalizations.of(context).tr('ok');

      verificationC = Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          child: TextFormField(
            autovalidate: _textFieldAutoVal,
            validator: (arg) {
              return validation(_textField, arg);
            },
            enabled: _enabledVerficationCode,
            controller: _textField,
            style:
                TextStyle(color: colors["color4"], fontFamily: 'SFUIDisplay'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).tr('verification_code'),
                prefixIcon: Icon(Icons.vpn_key),
                labelStyle: TextStyle(fontSize: 15)),
            focusNode: _textFieldFocus,
            textInputAction: TextInputAction.done,
          ),
        ),
      );
      pass = Container(
        child: TextFormField(
          controller: _password,
          autovalidate: _passwordAutoVal,
          obscureText: true,
          style: TextStyle(color: colors["color4"], fontFamily: 'SFUIDisplay'),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context).tr('password'),
              prefixIcon: Icon(Icons.lock_outline),
              labelStyle: TextStyle(fontSize: 15)),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _passwordFocus, _repasswordFocus);
          },
          validator: (String arg) {
            return validation(_password, arg);
          },
          focusNode: _passwordFocus,
        ),
      );

      confpass = Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          child: TextFormField(
            controller: _repassword,
            autovalidate: _repasswordAutoVal,
            obscureText: true,
            style:
                TextStyle(color: colors["color4"], fontFamily: 'SFUIDisplay'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context).tr('re_password'),
                prefixIcon: Icon(Icons.lock_open),
                labelStyle: TextStyle(fontSize: 15)),
            textInputAction: TextInputAction.done,
            focusNode: _repasswordFocus,
            validator: (String arg) {
              return validation(_repassword, arg);
            },
          ),
        ),
      );
    }

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(23),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    autovalidate: _userNameAutoVal,
                    validator: (arg) {
                      return validation(_userName, arg);
                    },
                    enabled: _enabledUserName,
                    controller: _userName,
                    style: TextStyle(
                        color: colors["color4"], fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context).tr('userName'),
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(fontSize: 15)),
                    textInputAction: TextInputAction.done,
                    focusNode: _userNameFocus,
                  ),
                ),
                verificationC,
                pass,
                confpass,
                Padding(
                  padding: EdgeInsets.all(23),
                  child: Center(
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context).tr('back'),
                                style: TextStyle(
                                  fontFamily: 'SFUIDisplay',
                                  color: colors["color4"],
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Text(
                              _next,
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: colors["color5"],
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              nextFunction();
                            },
                          ))
                    ]),
                  ),
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
                      )
              ],
            ),
          ),
        ),
      ),
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
    } else if (from == _textField) {
      if (_textField.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _password) {
      if (_password.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _repassword) {
      if (_repassword.text == "")
        return AppLocalizations.of(context).tr('required');
      else if (arg.length < 6)
        return AppLocalizations.of(context).tr('gt_6_char');
      else if (_repassword.text != _password.text)
        return AppLocalizations.of(context).tr('re_password_incorrect');
    }
    return null;
  }

  /* int i;
  time_to_send_sms() async{
    var thread = new Thread(() async {
      i = 60 * time_inter;
      for (i; i > 0; i--) {
        setState(() {
          _time = AppLocalizations.of(context).tr('time_to_send') +
              ' $i ' +
              AppLocalizations.of(context).tr('second');
          print(_time);
        });
//        sleep(Duration(seconds: 1));
      }
//      setState(() {
//        _time = AppLocalizations.of(context).tr('resend_sms');
//        time_inter++;
//      });
    });
     thread.start();
  }*/

  void startTimer() {
    //  print('1');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            //_time = AppLocalizations.of(context).tr('resend_sms');
            time_inter = time_inter + 1;
          } else {
            _time = AppLocalizations.of(context).tr('time_to_send') +
                ' $_start ' +
                AppLocalizations.of(context).tr('second');
            _start = _start - 1;
            //  print(_start);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void nextFunction() async {
    if (_enabledUserName) {
      print('aasdasdasd');
      if (_userName.text.trim()=="") {
        setState(() {
          _userNameAutoVal = true;
        });
      } else {
        DatabaseHandlerMysql db = DatabaseHandlerMysql();
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

        if (await db.checkUserName(_userName.text.trim())) {
          pr.dismiss();
          send_email();
          if (mounted)
            setState(() {
              //  _time = AppLocalizations.of(context).tr('time_to_send') +
              //  ' $_start ' + AppLocalizations.of(context).tr('second');
              startTimer();
              _enabledUserName = false;
              _enabledVerficationCode = true;
            });
        } else {
          pr.dismiss();
          CupertinoAlertDialog alt = CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).tr('email_incorrect')),
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
        if (pr.isShowing()) pr.dismiss();
      }
    } else if (_enabledVerficationCode) {
      _textFieldAutoVal = true;
      if (_textField.text == _verificationCode) {
        setState(() {
          _enabledVerficationCode = false;
          _timer.cancel();
          _time = "";
        });
      } else {
        CupertinoAlertDialog alt = CupertinoAlertDialog(
          title: Text(
              AppLocalizations.of(context).tr('invalid_verification_code')),
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
    } else {
      setState(() {
        _passwordAutoVal = true;
        _repasswordAutoVal = true;
      });

      if (_repassword.text == _password.text &&
          _repassword.text.trim().isNotEmpty) {
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
        bool save = false;
        if (await db.updatePassword(_userName.text.trim(),
            crypto.sha512.convert(utf8.encode(_password.text)).toString())) {
          save = true;
        } else {
          save = false;
        }
        pr.hide();
        CupertinoAlertDialog alt = CupertinoAlertDialog(
          title: Text(save
              ? AppLocalizations.of(context).tr('saved')
              : AppLocalizations.of(context).tr('error')),
          // content: Text('your message '),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context).tr('ok')),
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
    if (mounted) setState(() {});
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
    _verificationCode =
        ((Math.Random().nextDouble() * (100000 - 10000)).floor() + 10000)
            .toString();
    db.sendEmail(_userName.text.trim(), _verificationCode, lang);
  }
}
