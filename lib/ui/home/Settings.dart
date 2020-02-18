import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class Settings extends StatefulWidget {
  Settings();

  @override
  State<StatefulWidget> createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  int themeIndexSetting, notificationIndexSetting = 0;
  int langIndexSetting;
  SharedPreferences sharedPreferences;

  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  Map colors;
  String _userId;
  String _nextDonation;
  List<dynamic> item;

  @override
  void initState() {
    super.initState();
    sharedPreferences = _shared.get("sharedPreferences");
    _nextDonation = '';
    var s = _shared.get("langD");
    if (s == "d") {
      langIndexSetting = 0;
    } else if (s == "en") {
      langIndexSetting = 1;
    } else if (s == "fr") {
      langIndexSetting = 2;
    } else if (s == "ar") {
      langIndexSetting = 3;
    } else {
      langIndexSetting = 0;
    }

    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    themeIndexSetting = _shared.get("themeD");
    _userId = _shared.get("userId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _nextDonation = _shared.get("canDonation") == true
            ? _shared.get('nextDonation')
            : AppLocalizations.of(context).tr('now');
        initVal();
      });
    });
  }

  double spaceSettings = 20;

  init(context) {
    item = [
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/profile');
        },
        child: SizedBox(
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      color: colors["color1"],
                      size: 80,
                    ),
                  )),
              Expanded(
                flex: 6,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            _userId,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              AppLocalizations.of(context).tr('next_donation') +
                                  _nextDonation,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                              )),
                        ))
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: colors["color1"],
                  size: 15,
                ),
              ),
            ],
          ),
          height: 90,
        ),
      ),
      Container(
        color: colors["color2"],
        height: spaceSettings,
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('add_offer')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/add_offer.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/addOfferDonation');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('add_request')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/add_request.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/addRequestDonation');
        },
      ),
      Container(
        color: colors["color2"],
        height: spaceSettings,
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('request')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/request.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/addedRequest');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('offer')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/offer.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/viewOffer');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('history')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/history.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/history');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('points')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/coins.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/points');
        },
      ),
      Container(
        color: colors["color2"],
        height: spaceSettings,
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('notification')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/notification.svg",
          width: 32,
        ),
        onTap: () {
          _displayDialogNotification(context);
        },
      ),
      Container(
        color: colors["color2"],
        height: spaceSettings,
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('language')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/language.svg",
          width: 32,
        ),
        onTap: () {
          _displayDialogLang(context);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('theme')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/theme.svg",
          width: 32,
        ),
        onTap: () {
          _displayDialogTheme(context);
        },
      ),
      Container(
        color: colors["color2"],
        height: spaceSettings,
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('help')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/help.svg",
          width: 32,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/help');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('tell_a_friend')),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: colors["color1"],
        ),
        leading: SvgPicture.asset(
          "assets/icon/tell_a_friend.svg",
          width: 32,
        ),
        onTap: () {
          Share.text(AppLocalizations.of(context).tr('tell_a_friend'),
              AppLocalizations.of(context).tr('shareLink'), 'text/plain');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('logout')),
        leading: SvgPicture.asset(
          "assets/icon/logout.svg",
          width: 32,
        ),
        onTap: () {
          (_shared.get("sharedPreferences") as SharedPreferences)
              .remove("userId");
          (_shared.get("sharedPreferences") as SharedPreferences)
              .remove("password");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        },
      ),
    ];
  }

  var data;

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    init(context);
    return ListView.builder(
      itemCount: item.length,
      itemBuilder: (BuildContext context, index) {
        return Card(
          color: Theme.of(context).cardColor,
          child: item[index],
          margin: EdgeInsets.all(0),
        );
      },
    );
  }

  _displayDialogLang(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).tr('language')),
            content: Wrap(
              children: <Widget>[
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('default')),
                  groupValue: langIndexSetting,
                  value: 0,
                  onChanged: (val) {
                    _handlerSettinsLang(val, context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('english')),
                  groupValue: langIndexSetting,
                  value: 1,
                  onChanged: (val) {
                    _handlerSettinsLang(val, context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('french')),
                  groupValue: langIndexSetting,
                  value: 2,
                  onChanged: (val) {
                    _handlerSettinsLang(val, context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('arabic')),
                  groupValue: langIndexSetting,
                  value: 3,
                  onChanged: (val) {
                    _handlerSettinsLang(val, context);
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    print(langIndexSetting);
                    if (langIndexSetting == 0) {
                      _shared.set("lang", getLanguage());
                      _shared.set("langD", "d");
                      sharedPreferences.setString("lang", "d");
                    } else if (langIndexSetting == 1) {
                      _shared.set("lang", "en");
                      _shared.set("langD", "en");
                      sharedPreferences.setString("lang", "en");
                    } else if (langIndexSetting == 2) {
                      _shared.set("lang", "fr");
                      _shared.set("langD", "fr");
                      sharedPreferences.setString("lang", "fr");
                    } else if (langIndexSetting == 3) {
                      _shared.set("lang", "ar");
                      _shared.set("langD", "ar");
                      sharedPreferences.setString("lang", "ar");
                    }
                    saveInDatabase();
                    initVal();
                    if (lang == "ar") {
                      data.changeLocale(Locale("ar", "LB"));
                    } else if (lang == "fr") {
                      data.changeLocale(Locale("fr", "FR"));
                    } else {
                      data.changeLocale(Locale("en", "US"));
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  setState(() {
                    var s = _shared.get("langD");
                    if (s == "d") {
                      langIndexSetting = 0;
                    } else if (s == "en") {
                      langIndexSetting = 1;
                    } else if (s == "fr") {
                      langIndexSetting = 2;
                    } else if (s == "ar") {
                      langIndexSetting = 3;
                    } else {
                      langIndexSetting = 0;
                    }
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayDialogTheme(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).tr('theme')),
            content: Wrap(
              children: <Widget>[
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('default')),
                  groupValue: themeIndexSetting,
                  value: 0,
                  onChanged: (val) {
                    _handlerSettinsTheme(val, context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('light')),
                  groupValue: themeIndexSetting,
                  value: 1,
                  onChanged: (val) {
                    _handlerSettinsTheme(val, context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context).tr('dark')),
                  groupValue: themeIndexSetting,
                  value: 2,
                  onChanged: (val) {
                    _handlerSettinsTheme(val, context);
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  setState(() {
                    if (themeIndexSetting == 0) {
                      _shared.set("themeIndex", getDarkMode() == true ? 1 : 0);
                      _shared.set("themeD", 0);
                      sharedPreferences.setInt("theme", 0);
                    } else if (themeIndexSetting == 1) {
                      _shared.set("themeIndex", 0);
                      _shared.set("themeD", 1);
                      sharedPreferences.setInt("theme", 1);
                    } else if (themeIndexSetting == 2) {
                      _shared.set("themeIndex", 1);
                      _shared.set("themeD", 2);
                      sharedPreferences.setInt("theme", 2);
                    } else {
                      _shared.set("themeIndex", getDarkMode() == true ? 2 : 1);
                      _shared.set("themeD", 0);
                      sharedPreferences.setInt("theme", 0);
                    }
                    _shared.set("theme", th.theme().themes[themeIndex]);
                    initVal();
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()),
                      (Route<dynamic> route) => false);
                },
              ),
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  setState(() {
                    themeIndexSetting = _shared.get("themeD");
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayDialogNotification(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).tr('range')),
            content: Wrap(
              children: <Widget>[
                RadioListTile(
                  title: Text('10 ' + AppLocalizations.of(context).tr('km')),
                  groupValue: notificationIndexSetting,
                  value: 0,
                  onChanged: (val) {
                    _handlerSettinsNotification(val, context);
                  },
                ),
                RadioListTile(
                  title: Text('30 ' + AppLocalizations.of(context).tr('km')),
                  groupValue: notificationIndexSetting,
                  value: 1,
                  onChanged: (val) {
                    _handlerSettinsNotification(val, context);
                  },
                ),
                RadioListTile(
                  title: Text('50 ' + AppLocalizations.of(context).tr('km')),
                  groupValue: notificationIndexSetting,
                  value: 2,
                  onChanged: (val) {
                    _handlerSettinsNotification(val, context);
                  },
                ),
                RadioListTile(
                  title: Text('100 ' + AppLocalizations.of(context).tr('km')),
                  groupValue: notificationIndexSetting,
                  value: 3,
                  onChanged: (val) {
                    _handlerSettinsNotification(val, context);
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('ok')),
                onPressed: () {
                  saveInDatabase();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text(AppLocalizations.of(context).tr('cancel')),
                onPressed: () {
                  getIndexNotification();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _handlerSettinsNotification(val, context) {
    setState(() {
      notificationIndexSetting = val;
      Navigator.of(context).pop();
      _displayDialogNotification(context);
    });
  }

  _handlerSettinsLang(val, context) {
    setState(() {
      langIndexSetting = val;
      Navigator.of(context).pop();
      _displayDialogLang(context);
    });
  }

  _handlerSettinsTheme(val, context) {
    setState(() {
      themeIndexSetting = val;
      Navigator.of(context).pop();
      _displayDialogTheme(context);
    });
  }

  getLanguage() {
    return ui.window.locale.languageCode;
  }

  getDarkMode() {
    var qdarkMode = MediaQuery.of(context).platformBrightness;
    if (qdarkMode == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  initVal() {
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];

    getIndexNotification();
  }

  saveInDatabase() {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map<String, Object> json = Map();
    json[db.userId] = _userId;
    json[db.settingsLanguage] = lang;
    int x = notificationIndexSetting;
    json[db.settingsZone] =
        x == 0 ? 10 : x == 1 ? 30 : x == 2 ? 50 : x == 3 ? 100 : 10;
    db.setSetting(json);
  }

  getIndexNotification() async {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    notificationIndexSetting = 0;
    int x = await db.getNotificationIndex(_userId);
    setState(() {
      notificationIndexSetting =
          x == 10 ? 0 : x == 30 ? 1 : x == 50 ? 2 : x == 100 ? 3 : 0;
    });
  }
}
