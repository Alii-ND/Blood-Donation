import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/classes/Points.dart' as pt;
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/ui/widgetDonation/OthersWidget.dart';
import 'package:life_saver/ui/widgetDonation/WidgetHospital.dart';
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../main.dart';
import 'widgetDonation/BloodType.dart';

class AddRequestDonation extends StatefulWidget {
  AddRequestDonation();

  @override
  State<StatefulWidget> createState() {
    return new AddRequestDonationState();
  }
}

class AddRequestDonationState extends State<AddRequestDonation> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  int _step = 1;
  Map colors;
  int pageNumber = 3;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");

    colors = th.theme().color[themeIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        changeWidget();
      });
    });
  }

  Widget body = Container();
  List<String> _title;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    _title = [
      AppLocalizations.of(context).tr('select_hospital'),
      AppLocalizations.of(context).tr('select_blood'),
      AppLocalizations.of(context).tr('other_information')
    ];

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('add_request')),
          ),
          backgroundColor: colors["color2"],
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        animation: true,
                        animationDuration: 500,
                        lineWidth: 15.0,
                        startAngle: _step == 1 ? 0 : (_step - 1) / pageNumber,
                        percent: _step / pageNumber,
                        center: new Text(
                          (_step).toString() +
                              ' ' +
                              AppLocalizations.of(context).tr('of') +
                              ' ' +
                              pageNumber.toString(),
                          style: new TextStyle(
                              fontSize: 20.0, color: colors["color4"]),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(_title[_step - 1],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SFUIDisplay',
                                      color: colors["color4"])),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  _step != pageNumber
                                      ? AppLocalizations.of(context)
                                              .tr('next') +
                                          ': ' +
                                          _title[_step]
                                      : '',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'SFUIDisplay',
                                      color: colors["color4"]),
                                ),
                              ))
                        ],
                      ),
                    )
                    /* ,
                    ),*/
                    /* Align(
                      alignment:
                          lang == "ar" ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: ,
                    )*/
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: body,
              ),
              Expanded(
                  flex: 0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 20, left: 20, top: 20, bottom: 20),
                          child: Opacity(
                            opacity: _step == 1 ? 0.0 : 1,
                            child: MaterialButton(
                              onPressed: _step == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        _step--;
                                        changeWidget();
                                      });
                                    },
                              //since this is only a UI app
                              child: Text(
                                AppLocalizations.of(context)
                                    .tr('back')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'SFUIDisplay',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: theme.primaryColor,
                              elevation: 0,
                              height: 50,
                              textColor: colors["color3"],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(
                            right: 20, left: 20, top: 20, bottom: 20),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (_step != pageNumber) {
                                if (_step == 1) {
                                  if (_shared.get('hospital_selected') ==
                                      null) {
                                    showDialogs(AppLocalizations.of(context)
                                        .tr('select_hospital_error'));
                                    return;
                                  }
                                }
                                _step++;
                                changeWidget();
                              } else {
                                if (othersWidget.getUnitNumber().isNotEmpty) {
                                  setState(() {
                                    saveInDatabase();
                                  });
                                }
                              }
                            });
                          },
                          //since this is only a UI app
                          child: Text(
                            _step != pageNumber
                                ? AppLocalizations.of(context)
                                    .tr('next')
                                    .toUpperCase()
                                : AppLocalizations.of(context)
                                    .tr('save')
                                    .toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: theme.primaryColor,
                          elevation: 0,
                          height: 50,
                          textColor: colors["color3"],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )),
                    ],
                  ))
            ],
          )),
    );
  }

  Widget widgetPoint(pt.Points pt, i, context) {
    return Container(
      color: theme.cardColor,
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
    );
  }

  BloodType bloodType;
  WidgetHospital hospital;
  OthersWidget othersWidget;

  changeWidget() {
    if (_step == 1) {
      if (hospital == null) {
        hospital = WidgetHospital(true);
      } else {
        hospital.changeRefresh(false);
      }

      body = hospital;
    } else if (_step == 2) {
      if (bloodType == null) {
        bloodType = BloodType();
      }
      body = bloodType;
    } else if (_step == 3) {
      if (othersWidget == null) {
        othersWidget = OthersWidget();
      }
      body = othersWidget;
    }
  }

  showDialogs(text) {
    CupertinoAlertDialog alt = CupertinoAlertDialog(
      title: Text(text),
      // content: Text('your message '),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context).tr('ok')),
          onPressed: () {
            if (text !=
                AppLocalizations.of(context).tr('select_hospital_error'))
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

  @override
  void dispose() {
    _shared.set('hospital_selected', null);
    super.dispose();
  }

  saveInDatabase() async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    ProgressDialog pr =
        AllSharedWidget(colors, theme).getProgressDialog(context);
    pr.show();
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Requests r = Requests();
    r.idHospital = (_shared.get('hospital_selected') as Hospital).idHospital;
    r.idRequester = _shared.get('userId');
    r.urgency = othersWidget.getUrgency() == 0
        ? 'Low'
        : othersWidget.getUrgency() == 1 ? 'Medium' : 'High';
    print(r.urgency);
    r.bloodType = bloodType.bloodIndex == 8
        ? 'AB-'
        : bloodType.bloodIndex == 0
            ? 'O+'
            : bloodType.bloodIndex == 1
                ? 'O-'
                : bloodType.bloodIndex == 2
                    ? 'A+'
                    : bloodType.bloodIndex == 3
                        ? 'A-'
                        : bloodType.bloodIndex == 4
                            ? 'B+'
                            : bloodType.bloodIndex == 5
                                ? 'B-'
                                : bloodType.bloodIndex == 6 ? 'AB+' : 'ANY';
    r.unitsNb = int.parse(othersWidget.getUnitNumber());
    r.patientName = othersWidget.getPatiantName();
    r.description = othersWidget.getDescription();

    if (await (db.setRequest(r.toJson()))) {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('saved'));
    } else {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('error'));
    }
    //  Navigator.of(context).pop();
  }
}
