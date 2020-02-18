import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;

class BloodType extends StatefulWidget {
  int _bloodIndex = 8;

  BloodType();

  int get bloodIndex => _bloodIndex;

  set bloodIndex(int value) {
    _bloodIndex = value;
  }

  @override
  State<StatefulWidget> createState() {
    return new BloodTypeState(this._bloodIndex, this);
  }
}

class BloodTypeState extends State<BloodType> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  Map colors;
  int indexBlood;
  BloodType bloodT;

  BloodTypeState(this.indexBlood, this.bloodT);

  int oP = 0, oN = 1, aP = 2, aN = 3, bP = 4, bN = 5, abP = 6, abN = 7, any = 8;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
          backgroundColor: colors["color2"],
          body: ListView(

            children: <Widget>[
              RadioListTile(

                title: Text(AppLocalizations.of(context).tr('any')),
               /* secondary: SvgPicture.asset(
                  "assets/icon/blood_any.svg",
                  width: 32,
                ),*/
                groupValue: indexBlood,
                value: any,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('O+'),
                groupValue: indexBlood,
                value: oP,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('O-'),
                groupValue: indexBlood,
                value: oN,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('A+'),
                groupValue: indexBlood,
                value: aP,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('A-'),
                groupValue: indexBlood,
                value: aN,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('B+'),
                groupValue: indexBlood,
                value: bP,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('B-'),
                groupValue: indexBlood,
                value: bN,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('AB+'),
                groupValue: indexBlood,
                value: abP,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
              RadioListTile(
                title: Text('AB-'),
                groupValue: indexBlood,
                value: abN,
                onChanged: (val) {
                  _handlerBloodType(val, context);
                },
              ),
            ],
          ),
        ));
  }

  _handlerBloodType(val, BuildContext context) {
    setState(() {
      indexBlood = val;
      bloodT.bloodIndex = indexBlood;
    });
  }
}
