import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/classes/Offer.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/ui/widgetDonation/WidgetHospital.dart';
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../main.dart';

class AddOfferDonation extends StatefulWidget {
  AddOfferDonation();

  @override
  State<StatefulWidget> createState() {
    return new AddOfferDonationState();
  }
}

class AddOfferDonationState extends State<AddOfferDonation> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  int _step = 1;
  Map colors;
  int pageNumber = 1;

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
    ];

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('add_offer')),
          ),
          backgroundColor: colors["color2"],
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(_title[_step - 1],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SFUIDisplay',
                                      color: colors["color4"])),
                            ),
                          ),
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
                flex: 6,
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
                              if (_step == 1) {
                                if (_shared.get('hospital_selected') == null) {
                                  showDialogs(AppLocalizations.of(context)
                                      .tr('select_hospital_error'));
                                  return;
                                }
                                setState(() {
                                  saveInDatabase(context);
                                });
                              }

                              changeWidget();
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

  WidgetHospital hospital;
  changeWidget() {
    if (hospital == null) {
      hospital = WidgetHospital(true);
    } else {
      hospital.changeRefresh(false);
    }

    body = hospital;
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

  saveInDatabase(context) async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }

    ProgressDialog pr =AllSharedWidget(colors, theme).getProgressDialog(context);
    pr.show();
    DatabaseHandlerMysql db = DatabaseHandlerMysql();

    Offer offer = Offer();
    offer.hospital.idHospital =
        (_shared.get('hospital_selected') as Hospital).idHospital;
    offer.idUser = _shared.get('userId');
  
    if (await (db.setOffer(offer.toJson()))) {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('saved'));
    } else {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('error'));
    }
    // Navigator.of(context).pop();
  }
}
