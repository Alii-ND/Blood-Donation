import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:life_saver/classes/Pesron.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/service/UserLocation.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  Profile();

  @override
  State<StatefulWidget> createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {
  GlobalState _shared = GlobalState.instance;
  Map colors;
  String lang;
  ThemeData theme;
  int themeIndex;
  Person _person;
  List<Widget> item = List();
  String _userId;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");
  }

  bool refreshed = true;
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          key: scaffold,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('profile')),
          ),
          body: SmartRefresher(
            enablePullDown: refreshed,
            header: WaterDropHeader(
              complete: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      size: 24,
                      color: colors["color4"],
                    ),
                    Text(
                      AppLocalizations.of(context).tr('refresh_completed'),
                      style: TextStyle(
                        color: colors["color4"],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: _person == null
                ? !_refreshController.isRefresh
                    ? Center(
                        child: Text(AppLocalizations.of(context).tr('no_data'),
                            style: TextStyle(
                                color: colors["color4"], fontSize: 17)),
                      )
                    : Container()
                : ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        color: Theme.of(context).cardColor,
                        child: item[index],
                        margin: EdgeInsets.all(0),
                      );
                    },
                  ),
          )),
    );
  }

  init(context) {
    item = [
      Center(
        child: Icon(
          Icons.account_circle,
          color: colors["color1"],
          size: 150,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('userName')),
        /*   trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),*/
        subtitle: Text(_userId),
        leading: Icon(
          CupertinoIcons.person_solid,
          size: 36,
          color: theme.primaryColor,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('fullName')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.name),
        leading: Icon(
          CupertinoIcons.person,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          _showDialogFullName(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('dob')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.dob.day.toString() +
            '-' +
            _person.dob.month.toString() +
            '-' +
            _person.dob.year.toString()),
        leading: Icon(
          Icons.event_note,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          _selectDate(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('bloodG')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.bloodType),
        leading: Icon(
          Icons.accessibility,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          setState(() {
            selectBloodGroup(context, person: _person);
          });
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('phone')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.phone),
        leading: Icon(
          Icons.phone,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          _showDialogPhone(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('email')),
        subtitle: Text(_person.email),
        leading: Icon(
          Icons.email,
          size: 36,
          color: theme.primaryColor,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('address')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.address),
        leading: Icon(
          Icons.gps_fixed,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          getPlace(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('lastDonation')),
        subtitle: Text(_person.lastDonation ?? '-'),
        leading: Icon(
          Icons.history,
          size: 36,
          color: theme.primaryColor,
        ),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('health')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text(_person.health == null ? '' : _person.health),
        leading: Icon(
          Icons.healing,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          _showDialogHealth(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('new_password')),
        trailing: Icon(
          CupertinoIcons.pen,
          size: 20,
          color: colors["color1"],
        ),
        subtitle: Text('*******'),
        leading: Icon(
          CupertinoIcons.padlock_solid,
          size: 36,
          color: theme.primaryColor,
        ),
        onTap: () {
          _showDialogPassword(context);
        },
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: MaterialButton(
            onPressed: () async {
              ProgressDialog pr =
                  AllSharedWidget(colors, theme).getProgressDialog(context);

              pr.show();
              DatabaseHandlerMysql db = DatabaseHandlerMysql();
              _person.id = _userId;
              if (await db.updateUsers(_person.toJson())) {
                pr.hide();
                CupertinoAlertDialog alt = CupertinoAlertDialog(
                  title: Text(AppLocalizations.of(context).tr('saved')),
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
              } else {
                pr.hide();
                CupertinoAlertDialog alt = CupertinoAlertDialog(
                  title: Text(AppLocalizations.of(context).tr('error')),
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
            },
            //since this is only a UI app
            child: Text(
              AppLocalizations.of(context).tr('save').toUpperCase(),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      )
    ];
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _person.dob,
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));
    if (picked != null && picked != _person.dob) {
      setState(() {
        _person.dob = picked;
      });
      init(context);
    }
  }

  _showDialogFullName(context) async {
    TextEditingController _edit_conroller = TextEditingController();
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _edit_conroller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: AppLocalizations.of(context).tr('fullName')),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    if (_edit_conroller.text == "") {
                      scaffold.currentState.showSnackBar(new SnackBar(
                        content:
                            Text(AppLocalizations.of(context).tr('not_empty')),
                      ));
                    } else {
                      _person.name = _edit_conroller.text;
                      init(context);
                    }
                    Navigator.pop(context);
                  });
                })
          ],
        ),
      ),
    );
  }

  _showDialogHealth(context) async {
    TextEditingController _edit_conroller = TextEditingController();
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _edit_conroller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText:
                          AppLocalizations.of(context).tr('description')),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    if (_edit_conroller.text == "") {
                      scaffold.currentState.showSnackBar(new SnackBar(
                        content:
                            Text(AppLocalizations.of(context).tr('not_empty')),
                      ));
                    } else {
                      _person.health = _edit_conroller.text;
                      init(context);
                    }
                    Navigator.pop(context);
                  });
                })
          ],
        ),
      ),
    );
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
                  // _person.address = "";
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(AppLocalizations.of(context).tr('ok')),
              onPressed: () {
                setState(() {
                  if (_edit_conroller.text == "") {
                    // _person.address = "";
                  } else {
                    _person.address = _edit_conroller.text + ", " + locations;
                  }
                });
                init(context);

                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  _showDialogPassword(context) async {
    TextEditingController _edit_conroller = TextEditingController();
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _edit_conroller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: AppLocalizations.of(context).tr('password')),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    if (_edit_conroller.text == "") {
                      scaffold.currentState.showSnackBar(new SnackBar(
                        content:
                            Text(AppLocalizations.of(context).tr('not_empty')),
                      ));
                    } else if (_edit_conroller.text.length < 6) {
                      scaffold.currentState.showSnackBar(new SnackBar(
                        content:
                            Text(AppLocalizations.of(context).tr('gt_6_char')),
                      ));
                    } else {
                      _person.password = crypto.sha512
                          .convert(utf8.encode(_edit_conroller.text))
                          .toString();
                      init(context);
                    }
                    Navigator.pop(context);
                  });
                })
          ],
        ),
      ),
    );
  }

  _showDialogPhone(context) async {
    TextEditingController _edit_conroller = TextEditingController();
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: _edit_conroller,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: AppLocalizations.of(context).tr('phone')),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    if (_edit_conroller.text == "") {
                      scaffold.currentState.showSnackBar(new SnackBar(
                        content:
                            Text(AppLocalizations.of(context).tr('not_empty')),
                      ));
                    } else {
                      try {
                        var value = int.parse(_edit_conroller.text);
                      } on FormatException {
                        scaffold.currentState.showSnackBar(new SnackBar(
                          content: Text(
                              AppLocalizations.of(context).tr('phone_error')),
                        ));
                        return;
                      }

                      _person.phone = _edit_conroller.text;
                      init(context);
                    }
                  });
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  selectBloodGroup(context,
      {TextEditingController bloodG = null, Person person = null}) {
    SimpleDialog simpleDialog = SimpleDialog(
      title: Text(AppLocalizations.of(context).tr('bloodG')),
      children: <Widget>[
        SimpleDialogOption(
            child: Text('O+'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'O+';
                else if (person != null) person.bloodType = 'O+';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('O-'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'O-';
                else if (person != null) person.bloodType = 'O-';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('A+'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'A+';
                else if (person != null) person.bloodType = 'A+';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('A-'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'A-';
                else if (person != null) person.bloodType = 'A-';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('B+'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'B+';
                else if (person != null) person.bloodType = 'B+';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('B-'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'B-';
                else if (person != null) person.bloodType = 'B-';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('AB+'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'AB+';
                else if (person != null) person.bloodType = 'AB+';
                init(context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('AB-'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'AB-';
                else if (person != null) person.bloodType = 'AB-';
                init(context);
                Navigator.of(context).pop();
              });
            }),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return simpleDialog;
        });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    //get point from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map data = await (db.getUser(_userId));
    if (data == null) Navigator.of(context).pop();
    setState(() {
      _person = Person.fromJson(data);
      init(context);
    });

    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
//    setState(() {
//      _person = Person();
//      _person.id = _userId;
//      _person.name = 'Ali nd';
//      _person.phone = '+96171873440';
//      _person.address = 'Kherbet selem';
//      _person.bloodType = 'O+';
//      _person.id = 'Ali_ND';
//      _person.health='';
//      _person.dob = DateTime(1998, 11, 15);
//      init(context);
//    });

    _refreshController.refreshCompleted();
    setState(() {
      refreshed = false;
    });
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
          return;
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
            print(currentLocation.longitude);
            print(currentLocation.latitude);

            List<Placemark> placemarks = await Geolocator()
                .placemarkFromCoordinates(
                    currentLocation.latitude, currentLocation.longitude);
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
                  _person.address = pos.name +
                      ', ' +
                      pos.subAdministrativeArea +
                      ', ' +
                      pos.administrativeArea +
                      ', ' +
                      pos.country;
                });
                init(context);
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

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        // padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
