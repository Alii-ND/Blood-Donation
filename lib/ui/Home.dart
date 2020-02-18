import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/classes/Pesron.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:shared_preferences/shared_preferences.dart';

import 'home/Donation.dart';
import 'home/Notification.dart' as nt;
import 'home/Settings.dart';

class Home extends StatefulWidget {
  Home();

  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String lang;
  int themeIndex;
  ThemeData theme;
  int langIndexSetting;
  GlobalState _shared = GlobalState.instance;
  Map colors;
  var background;
  int nindex = 1;
  static const int _donation = 0, _notification = 1, _settings = 2;
  var _donationBottomNavigation;
  var _notificationBottomNavigation;
  var _settingsBottomNavigation;
  Widget body;
  Person _person;

  @override
  void initState() {
    super.initState();
    _person = Person();
    _person.id = _shared.get('userId');
    _person.bloodType = _shared.get('bloodType');
    //print(_shared.get('point'));
    int x;
    try {
      x = _shared.get('point') as int;
    } catch (_) {
      x = int.parse(_shared.get('point'));
    }
    _person.point = x;
    _shared.set("bloodSelected", _person.bloodType);
    sharedPreferences = _shared.get("sharedPreferences");
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");

    colors = th.theme().color[themeIndex];
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        changeWidget(nindex, context);
        selectedButtom(nindex, context);
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  selectedButtom(int position, context) {
    if (position == _donation) {
      _donationBottomNavigation = Theme.of(context).primaryColor;
      _notificationBottomNavigation = colors["color1"];
      _settingsBottomNavigation = colors["color1"];
    } else if (position == _notification) {
      _donationBottomNavigation = colors["color1"];
      _notificationBottomNavigation = Theme.of(context).primaryColor;
      _settingsBottomNavigation = colors["color1"];
    } else if (position == _settings) {
      _donationBottomNavigation = colors["color1"];
      _notificationBottomNavigation = colors["color1"];
      _settingsBottomNavigation = Theme.of(context).primaryColor;
    }
  }

  Donation _donationWid;
  nt.Notification _notificationWid;
  Settings _settingsWid;

  changeWidget(int position, context) {
    if (position == _donation) {
      background = colors["color2"];
      if (_donationWid == null) {
        var key = new GlobalKey<ScaffoldState>();
        _donationWid = Donation(true, key: key);
      } else {
        _donationWid.changeRefresh(false);
      }
      body = _donationWid;
      //
    } else if (position == _notification) {
      if (_notificationWid == null) {
        _notificationWid = nt.Notification(true);
      } else {
        _notificationWid.changeRefresh(false);
      }
      background = colors["color2"];
      body = _notificationWid;
    } else if (position == _settings) {
      if (_settingsWid == null) {
        _settingsWid = Settings();
      }
      background = colors["color2"];
      body = _settingsWid;
    }
  }

  var data;

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('titleAppBar')),
          actions: <Widget>[
            nindex == _donation
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        selectBloodGroup(context, person: _person);
                      });
                    },
                    child: Center(
                      child: Text(
                        _person.bloodType,
                        style: TextStyle(
                          color: colors["color3"],
                        ),
                      ),
                    ))
                : Container(),
            nindex == _donation
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        selectBloodGroup(context, person: _person);
                      });
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colors["color3"],
                    ),
                  )
                : Container(),
            nindex != _settings
                ? FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/points');
                    },
                    icon: SvgPicture.asset(
                      "assets/icon/point.svg",
                      width: 24,
                    ),
                    label: Text(
                      _person.point.toString(),
                      style: TextStyle(color: colors["color3"]),
                    ))
                : Container()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nindex,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icon/add_location.svg",
                  color: _donationBottomNavigation,
                ),
                title: Text(AppLocalizations.of(context).tr('donation'))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.event_note,
                  color: _notificationBottomNavigation,
                ),
                title: Text(AppLocalizations.of(context).tr('myNotification'))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: _settingsBottomNavigation,
                ),
                title: Text(AppLocalizations.of(context).tr('settings')))
          ],
          onTap: (position) {
            nindex = position;
            setState(() {
              selectedButtom(nindex, context);
              changeWidget(nindex, context);
            });
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Theme.of(context).primaryColor,
          showSelectedLabels: true,
          showUnselectedLabels: false,
        ),
        body: body,
        backgroundColor: background,
        /*     floatingActionButton: nindex == _donation
            ? FloatingActionButton(
                backgroundColor: theme.primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/addRequestDonation');
                },
              )
            : null,*/
      ),
    );
  }

  selectBloodGroup(context,
      {TextEditingController bloodG = null, Person person = null}) {
    SimpleDialog simpleDialog = SimpleDialog(
      title: Text(AppLocalizations.of(context).tr('bloodG')),
      children: <Widget>[
        SimpleDialogOption(
            child: Text(AppLocalizations.of(context).tr('any')),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'O+';
                else if (person != null)
                  person.bloodType = AppLocalizations.of(context).tr('any');
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text('O+'),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = 'O+';
                else if (person != null) person.bloodType = 'O+';
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
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
                _shared.set("bloodSelected", _person.bloodType);
                _donationWid = null;
                changeWidget(nindex, context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text(AppLocalizations.of(context).tr('any')),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = AppLocalizations.of(context).tr('any');
                else if (person != null)
                  person.bloodType = AppLocalizations.of(context).tr('any');
                _shared.set("bloodSelected", "ANY");
                _donationWid = null;
                changeWidget(nindex, context);
                Navigator.of(context).pop();
              });
            }),
        SimpleDialogOption(
            child: Text(AppLocalizations.of(context).tr('all')),
            onPressed: () {
              setState(() {
                if (bloodG != null)
                  bloodG.text = AppLocalizations.of(context).tr('all');
                else if (person != null)
                  person.bloodType = AppLocalizations.of(context).tr('all');
                _shared.set("bloodSelected", "ALL");
                _donationWid = null;

                Navigator.of(context).pop();
                changeWidget(nindex, context);
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
}
