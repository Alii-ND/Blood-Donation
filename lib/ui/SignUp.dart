import 'dart:convert';
import 'dart:math' as Math;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:life_saver/classes/Pesron.dart';

import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/service/UserLocation.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignUp extends StatefulWidget {
  SignUp();

  /* SignUp(String lang, ThemeData theme, int themeInde) {
    this.lang = lang;
    this.theme = theme;
    themeIndex = themeInde;
  }*/

  @override
  State<StatefulWidget> createState() {
    return new SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _userName = new TextEditingController();
  TextEditingController _fullName = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _bloodG = new TextEditingController();
  TextEditingController _lastDonation = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();
  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _bloodGFocus = FocusNode();
  final FocusNode _lastDonationFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _repasswordFocus = FocusNode();

  bool _userNameAutoVal = false,
      _fullNameAutoVal = false,
      _passwordAutoVal = false,
      _emailAutoVal = false,
      _repasswordAutoVal = false,
      _phoneAutoVal = false,
      _dobAutoVal = false,
      _addressAutoVal = false,
      _bloodGroupAutoVal = false,
      _lastDonationAutoVal = false,
      _autoValidate = false;
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
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        controller: _userName,
                        autovalidate: _userNameAutoVal,
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
                              context, _userNameFocus, _fullNameFocus);
                        },
                        validator: (String arg) {
                          return validation(_userName, arg);
                        },
                        focusNode: _userNameFocus,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        child: TextFormField(
                          controller: _fullName,
                          autovalidate: _fullNameAutoVal,
                          style: TextStyle(
                              color: colors["color4"],
                              fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context).tr('fullName'),
                              prefixIcon: Icon(Icons.person_pin),
                              labelStyle: TextStyle(fontSize: 15)),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _fullNameFocus, _phoneFocus);
                          },
                          validator: (String arg) {
                            return validation(_fullName, arg);
                          },
                          focusNode: _fullNameFocus,
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _phone,
                        autovalidate: _phoneAutoVal,
                        validator: (String arg) {
                          return validation(_phone, arg);
                        },
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context).tr('phone'),
                            prefixIcon: Icon(Icons.phone),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _phoneFocus, _emailFocus);
                        },
                        focusNode: _phoneFocus,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Container(
                          child: TextFormField(
                            controller: _email,
                            autovalidate: _emailAutoVal,
                            validator: (String arg) {
                              return validation(_email, arg);
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: colors["color4"],
                                fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    AppLocalizations.of(context).tr('email'),
                                prefixIcon: Icon(Icons.email),
                                labelStyle: TextStyle(fontSize: 15)),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _emailFocus, _addressFocus);
                              getPlace(context);
                            },
                            focusNode: _emailFocus,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Container(
                        child: TextFormField(
                          onTap: () {
                            getPlace(context);
                          },
                          controller: _address,
                          autovalidate: _addressAutoVal,
                          readOnly: true,
                          style: TextStyle(
                              color: colors["color4"],
                              fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context).tr('address'),
                              prefixIcon: Icon(Icons.my_location),
                              labelStyle: TextStyle(fontSize: 15)),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _addressFocus, _bloodGFocus);
                            setState(() {
                              AllSharedWidget(colors, theme)
                                  .selectBloodGroup(context, bloodG: _bloodG);
                            });
                          },
                          validator: (String arg) {
                            return validation(_address, arg);
                          },
                          focusNode: _addressFocus,
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        autovalidate: _bloodGroupAutoVal,
                        controller: _bloodG,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context).tr('bloodG'),
                            prefixIcon: Icon(Icons.accessibility),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _bloodGFocus, _lastDonationFocus);
                        },
                        readOnly: true,
                        validator: (arg) {
                          return validation(_bloodG, arg);
                        },
                        focusNode: _bloodGFocus,
                        onTap: () {
                          setState(() {
                            AllSharedWidget(colors, theme)
                                .selectBloodGroup(context, bloodG: _bloodG);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                          child: DateTimeField(
                        readOnly: true,
                        format: DateFormat("yyyy-MM-dd"),
                        controller: _lastDonation,
                        autovalidate: _lastDonationAutoVal,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context).tr('lastDonation'),
                            prefixIcon: Icon(Icons.history),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _lastDonationFocus, _dobFocus);
                        },
                        focusNode: _lastDonationFocus,
                        onShowPicker:
                            (BuildContext context, DateTime currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                        },
                      )),
                    ),
                    Container(
                      child: DateTimeField(
                        readOnly: true,
                        format: DateFormat("yyyy-MM-dd"),
                        controller: _dob,
                        autovalidate: _dobAutoVal,
                        validator: (arg) {
                          return validation(_dob, arg);
                        },
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context).tr('dob'),
                            prefixIcon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(context, _dobFocus, _passwordFocus);
                        },
                        onShowPicker:
                            (BuildContext context, DateTime currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                        },
                        focusNode: _dobFocus,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        child: TextFormField(
                          controller: _password,
                          autovalidate: _passwordAutoVal,
                          obscureText: true,
                          style: TextStyle(
                              color: colors["color4"],
                              fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context).tr('password'),
                              prefixIcon: Icon(Icons.lock_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _passwordFocus, _repasswordFocus);
                          },
                          validator: (String arg) {
                            return validation(_password, arg);
                          },
                          focusNode: _passwordFocus,
                        ),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _repassword,
                        autovalidate: _repasswordAutoVal,
                        obscureText: true,
                        style: TextStyle(
                            color: colors["color4"], fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context).tr('re_password'),
                            prefixIcon: Icon(Icons.lock_open),
                            labelStyle: TextStyle(fontSize: 15)),
                        textInputAction: TextInputAction.done,
                        focusNode: _repasswordFocus,
                        validator: (String arg) {
                          return validation(_repassword, arg);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () {
                          signup();
                        },
                        //since this is only a UI app
                        child: Text(
                          AppLocalizations.of(context).tr('signUp'),
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
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Wrap(children: <Widget>[
                          Text(AppLocalizations.of(context).tr('registration1'),
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: colors["color4"],
                                fontSize: 15,
                              )),
                          GestureDetector(
                            child: Text(
                              AppLocalizations.of(context).tr('sign_in'),
                              style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                color: colors["color5"],
                                fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login', (Route<dynamic> route) => false);
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

  bool _userNameExists = false;

  validation(from, arg) {
    if (from == _userName) {
      if (_userName.text == "")
        return AppLocalizations.of(context).tr('required');
      else {
        if (arg.length < 6) {
          return AppLocalizations.of(context).tr('gt_6_char');
        } else if (validateUserName(_userName.text)) {
          return AppLocalizations.of(context).tr('userName_error');
        } else if (arg.length > 30) {
          return AppLocalizations.of(context).tr('lt_30_char');
        } else {
          if (_userNameExists) {
            _userNameExists = false;
            return AppLocalizations.of(context).tr('userName_already_exist');
          }
        }
      }
    } else if (from == _fullName) {
      if (_fullName.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _phone) {
      if (_phone.text == "")
        return AppLocalizations.of(context).tr('required');
      else
        try {
          var value = int.parse(_phone.text);
        } on FormatException {
          return AppLocalizations.of(context).tr('phone_error');
        }
    } else if (from == _email) {
      if (_email.text == "")
        return AppLocalizations.of(context).tr('required');
      else {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(_email.text))
          return AppLocalizations.of(context).tr('enter_valid_email');
      }
    } else if (from == _address) {
      if (_address.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _bloodG) {
      if (_bloodG.text == "")
        return AppLocalizations.of(context).tr('required');
    } else if (from == _dob) {
      if (_dob.text == "") return AppLocalizations.of(context).tr('required');
    } else if (from == _password) {
      if (_password.text == "")
        return AppLocalizations.of(context).tr('required');
      else {
        if (arg.length < 6) {
          return AppLocalizations.of(context).tr('gt_6_char');
        }
      }
    } else if (from == _repassword) {
      if (_repassword.text == "")
        return AppLocalizations.of(context).tr('required');
      else if (_repassword.text != _password.text)
        return AppLocalizations.of(context).tr('re_password_incorrect');
    }
    return null;
  }
Person person = Person();
  signup() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _userNameAutoVal = true;
        _fullNameAutoVal = true;
        _phoneAutoVal = true;
        _addressAutoVal = true;
        _bloodGroupAutoVal = true;
        _dobAutoVal = true;
        _passwordAutoVal = true;
        _repasswordAutoVal = true;
        _emailAutoVal = true;
        _autoValidate = true;
      });

      return;
    } else {
      ProgressDialog pr =
          AllSharedWidget(colors, theme).getProgressDialog(context);

      pr.show();
      DatabaseHandlerMysql db = DatabaseHandlerMysql();
      if (await db.checkUserName(_userName.text)) {
        setState(() {
          _userNameExists = true;
        });
      } else {
        
        person.id = _userName.text;
        person.name = _fullName.text;
        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        person.dob = dateFormat.parse(_dob.text);
        person.password =
            crypto.sha512.convert(utf8.encode(_password.text)).toString();
        person.lastDonation = _lastDonation.text == ""
            ? null
            : dateFormat.parse(_lastDonation.text);
        person.address = _address.text;
        person.bloodType = _bloodG.text;
        person.phone = _phone.text;
        person.email = _email.text;
        _shared.set("person", person);

        DatabaseHandlerMysql db = DatabaseHandlerMysql();
        String _verificationCode =
            ((Math.Random().nextDouble() * (100000 - 10000)).floor() + 10000)
                .toString();
        db.sendEmail_Email(_userName.text.trim(), _verificationCode, lang);
        _shared.set("vrcode", _verificationCode);
        pr.hide();
        Navigator.of(context).pushNamed('/verificationCode');
      }
      if (pr.isShowing()) pr.hide();
    }
  }

 
  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  bool validateUserName(String value) {
    Pattern pattern = '([A-Z]*[a-z]*_*)*';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  _showDialogAddress(context, locations) async {
    TextEditingController _edit_conroller = TextEditingController();
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: _edit_conroller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context).tr('address')),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text(AppLocalizations.of(context).tr('cancel')),
              onPressed: () {
                setState(() {
                  _address.text = "";
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(AppLocalizations.of(context).tr('ok')),
              onPressed: () {
                setState(() {
                  if (_edit_conroller.text == "") {
                    _address.text = "";
                  } else {
                    _address.text = _edit_conroller.text + ", " + locations;
                  }
                });
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  getPlace(BuildContext context) async {
    UserLocation currentLocation;
    Location location = Location();
    bool enabled = await location.serviceEnabled();
    if (!enabled) {
      //await location.requestPermission();
      await location.requestService().then((bool) {
        if (bool) {
          getPlace(context);
        } else {
          CupertinoAlertDialog alt = CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).tr('turn_on_location')),
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
      });
      print('please turn on location');
    } else {
      location.requestPermission().then((granted) async {
        if (granted) {
          ProgressDialog pr =
              AllSharedWidget(colors, theme).getProgressDialog(context);
          pr.show();
          try {
            var userLocation = await location.getLocation();
            currentLocation = UserLocation(
              latitude: userLocation.latitude,
              longitude: userLocation.longitude,
            );
          } catch (e) {
            print('Could not get the location: $e');
            currentLocation = null;
          }

          if (currentLocation != null) {
            pr.update(
              message: AppLocalizations.of(context).tr('getting_location'),
              progressWidget: Container(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()),
              progressTextStyle: TextStyle(
                  color: colors["color4"],
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: colors["color4"],
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600),
            );
            // print(currentLocation.longitude);
            // print(currentLocation.latitude);

            List<Placemark> placemarks = await Geolocator()
                .placemarkFromCoordinates(
                    currentLocation.latitude, currentLocation.longitude);
                    person.lat = currentLocation.latitude;
                    person.lont = currentLocation.longitude;
            if (placemarks != null && placemarks.isNotEmpty) {
              final Placemark pos = placemarks[0];
              if (pos.name == '' ||
                  pos.name == null ||
                  pos.name.toLowerCase() == 'unnamed road' ||
                  pos.name.toLowerCase() == 'unknoun') {
                pr.hide();
                _showDialogAddress(
                    context,
                    pos.subAdministrativeArea +
                        ', ' +
                        pos.administrativeArea +
                        ', ' +
                        pos.country);
              } else {
                pr.hide();
                setState(() {
                  _address.text = pos.name +
                      ', ' +
                      pos.subAdministrativeArea +
                      ', ' +
                      pos.administrativeArea +
                      ', ' +
                      pos.country;

                });
              }
            }
          }
        } else {
          CupertinoAlertDialog alt = CupertinoAlertDialog(
            title: Text(AppLocalizations.of(context).tr('permission_denied')),
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
      });
    }
  }
}
