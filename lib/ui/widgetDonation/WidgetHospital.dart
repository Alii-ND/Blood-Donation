import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:map_launcher/map_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../main.dart';

List<Hospital> _listItem = List();
List<Widget> _listWidget = List();

class WidgetHospital extends StatefulWidget {
  WidgetHospital(this.refresh);

  bool refresh;

  changeRefresh(bool _ref) {
    refresh = _ref;
  }

  @override
  State<StatefulWidget> createState() {
    return new WidgetHospitalState(refresh);
  }
}

class WidgetHospitalState extends State<WidgetHospital> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData _theme;
  int themeIndex;
  Map _colors;

  WidgetHospitalState(this.refresh);

  bool refresh;
  String _userId;
  @override
  void initState() {
    super.initState();
    _userId= _shared.get("userId");
    _theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    _colors = th.theme().color[themeIndex];
    _refreshController = RefreshController(initialRefresh: refresh);
    _listWidget.clear();
    addWidget();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /*setState(() {});*/
    });
  }

  Hospital selectedHospital;

  @override
  Widget build(BuildContext context) {
//    print((selectedHospital==null ?'null':selectedHospital.click));
    selectedHospital = _shared.get('hospital_selected');
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        backgroundColor: _colors["color2"],
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            complete: Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Icon(
                    Icons.check,
                    size: 24,
                    color: _colors["color4"],
                  ),
                  Text(
                    AppLocalizations.of(context).tr('refresh_completed'),
                    style: TextStyle(
                      color: _colors["color4"],
                    ),
                  ),
                ],
              ),
            ),
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: _listItem.length == 0
              ? !_refreshController.isRefresh
                  ? Center(
                      child: Text(AppLocalizations.of(context).tr('no_data'),
                          style: TextStyle(
                              color: _colors["color4"], fontSize: 17)),
                    )
                  : Container()
              : ListView.builder(
                  itemCount: _listWidget.length,
                  itemBuilder: (BuildContext context, index) {
                    return _listWidget[index];
                  }),
        ),
      ),
    );
  }

  createWidget(Hospital r) {
    return GestureDetector(
      onTap: () {
//        print('ssss');
        setState(() {
          if (selectedHospital == null) {
            selectedHospital = r;
            selectedHospital.click = true;
            _shared.set('hospital_selected', r);
          } else {
            selectedHospital.click = false;
            selectedHospital = r;
            selectedHospital.click = true;
            _shared.set('hospital_selected', r);
          }
          _listWidget.clear();
          addWidget();
        });
      },
      onLongPress: () {
        openMapsSheet(context, r);
      },
      child: Container(
        color: _theme.cardColor,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icon/hospital.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(r.hospitalName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'SFUIDisplay',
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icon/map.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(r.hospitalAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'SFUIDisplay',
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icon/hospital_phone.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(r.hospitalPhone,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'SFUIDisplay',
                                  )))
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  r.click
                      ? "assets/icon/radio_on.svg"
                      : "assets/icon/radio_off.svg",
                  color: Colors.blue,
                  width: 24,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  openMapsSheet(context, r) async {
    try {
      final title = r.hospitalName;
      final description = r.hospitalAddress;
      final coords = Coords(r.hospitalLatitude, r.hospitalLongitude);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  RefreshController _refreshController;

  void _onRefresh() async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    setState(() {
      _listItem.clear();
      _listWidget.clear();
      _shared.set('hospital_selected', null);
    });
    //get point from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    List item = await (db.getHospitals(_userId));
    for (int i = 0; i < item.length; i++) {
      setState(() {
        Hospital hospital = Hospital.fromJson(item[i]);
        _listItem.add(hospital);
        _listWidget.add(createWidget(hospital));
      });
    }
    setState(() {});
//    _refreshController.refreshCompleted();

    // monitor network fetch

    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
//    setState(() {
//      addItem();
//    });

    _refreshController.refreshCompleted();
  }

/*  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }*/

  addItem() {
    Hospital h1 = Hospital();
    h1.hospitalName = "asdasd";
    h1.hospitalPhone = "07405101";
    h1.hospitalLongitude = 36;
    h1.hospitalLatitude = 36;
    h1.hospitalAddress = "asdasd";

    Hospital h2 = Hospital();
    h2.hospitalName = "asdasd";
    h2.hospitalPhone = "07405101";
    h2.hospitalLongitude = 36;
    h2.hospitalLatitude = 36;
    h2.hospitalAddress = "asdasd";

    Hospital h3 = Hospital();
    h3.hospitalName = "asdasd";
    h3.hospitalPhone = "07405101";
    h3.hospitalLongitude = 36;
    h3.hospitalLatitude = 36;
    h3.hospitalAddress = "asdajjkfjfjkffgjjgjfgjsd";

    _listItem.add(h1);
    _listItem.add(h2);
    _listItem.add(h3);

    addWidget();
  }

  addWidget() {
    for (int i = 0; i < _listItem.length; i++) {
      _listWidget.add(createWidget(_listItem[i]));
    }
  }
}
