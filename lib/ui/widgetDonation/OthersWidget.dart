import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;

TextEditingController _patientName = TextEditingController();
TextEditingController _description = TextEditingController();
TextEditingController _unitNumber = TextEditingController();
int _urgency = 1;

class OthersWidget extends StatefulWidget {
  OthersWidget();

  String getPatiantName() {
    return _patientName.text;
  }

  int getUrgency() {
    return _urgency;
  }

  String getDescription() {
    return _description.text;
  }

  String getUnitNumber() {
    return _unitNumber.text;
  }

  @override
  State<StatefulWidget> createState() {
    return new OthersWidgetState();
  }
}

class OthersWidgetState extends State<OthersWidget> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData _theme;
  int themeIndex;
  Map _colors;

  @override
  void initState() {
    super.initState();
    _theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    _colors = th.theme().color[themeIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*setState(() {});*/
    });
  }

  final FocusNode _unitNumberFoc = FocusNode();
  final FocusNode _descriptionFoc = FocusNode();
  final FocusNode _patientNameFoc = FocusNode();

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        backgroundColor: _colors["color2"],
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  child: TextFormField(
                    autovalidate: true,
                    validator: (arg) {
                      if (arg.length == 0 || arg == null) {
                        return AppLocalizations.of(context).tr('required');
                      } else {
                        try {
                          int d = int.parse(arg);
                          if (d < 1) {
                            return AppLocalizations.of(context)
                                .tr('number_must_gt_0');
                          }
                        } catch (_) {
                          return AppLocalizations.of(context).tr('must_number');
                        }
                      }
                      return null;
                    },
                    controller: _unitNumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: _colors["color4"], fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).tr('unit_number'),
                        prefixIcon: Icon(Icons.local_hospital),
                        labelStyle: TextStyle(fontSize: 15)),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (term) {},
                    focusNode: _unitNumberFoc,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).tr('urgencyTitle'),
                    style: TextStyle(
                        color: _colors["color4"], fontFamily: 'SFUIDisplay'),
                  ),
                  Row(
                    //direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _urgency = 0;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: 0,
                                    groupValue: _urgency,
                                    onChanged: (i) {
                                      setState(() {
                                        _urgency = i;
                                      });
                                    },
                                    activeColor: Colors.green,
                                  ),
                                  Text(AppLocalizations.of(context).tr('low')),
                                ],
                              ))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _urgency = 1;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: 1,
                                    groupValue: _urgency,
                                    onChanged: (i) {
                                      setState(() {
                                        _urgency = i;
                                      });
                                    },
                                    activeColor: Colors.amber,
                                  ),
                                  Text(AppLocalizations.of(context)
                                      .tr('medium')),
                                ],
                              ))),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _urgency = 2;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    value: 2,
                                    groupValue: _urgency,
                                    onChanged: (i) {
                                      setState(() {
                                        _urgency = i;
                                      });
                                    },
                                    activeColor: Colors.red,
                                  ),
                                  Text(AppLocalizations.of(context).tr('high')),
                                ],
                              )))
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  child: TextFormField(
                    controller: _patientName,
                    style: TextStyle(
                        color: _colors["color4"], fontFamily: 'SFUIDisplay'),
                    decoration: InputDecoration(
                        border:  OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context).tr('patientName'),
                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(fontSize: 15)),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {
                      _patientNameFoc.unfocus();
                      FocusScope.of(context).requestFocus(_descriptionFoc);
                    },
                    focusNode: _patientNameFoc,
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  controller: _description,
                  style: TextStyle(
                      color: _colors["color4"], fontFamily: 'SFUIDisplay'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context).tr('description'),
                      prefixIcon: Icon(Icons.description),
                      labelStyle: TextStyle(fontSize: 15)),
                  textInputAction: TextInputAction.done,
                  focusNode: _descriptionFoc,
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
