import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:map_launcher/map_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class ViewAddedRequests extends StatefulWidget {
  ViewAddedRequests();

  @override
  State<StatefulWidget> createState() {
    return new ViewAddedRequestsState();
  }
}

class ViewAddedRequestsState extends State<ViewAddedRequests> {
  String lang;
  ThemeData theme;
  int themeIndex;
  GlobalState _shared = GlobalState.instance;
  Map colors;
  Requests r;
  TextEditingController _time = new TextEditingController();
  bool _timeAutoValidation = false;
  String _userId;
  Map<String, Widget> _widget;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    _widget = Map();
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  double _spaceSize = 20;
  double _spaceIcon = 10;
  double _iconSize = 32;
  double _fontSize = 17;

  bool refresh = true;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('viewRequest')),
          ),
          backgroundColor: colors["color2"],
          body: SmartRefresher(
            enablePullDown: refresh,
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
            child: r == null
                ? Container()
                : Container(
                    color: theme.cardColor,
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Stack(
                          children: <Widget>[
                            ListView(
                              children: <Widget>[
                                Tooltip(
                                  message: AppLocalizations.of(context)
                                      .tr('hospitalName'),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        "assets/icon/hospital.svg",
                                        width: _iconSize,
                                      ),
                                      SizedBox(
                                        width: _spaceIcon,
                                      ),
                                      Flexible(
                                          child: Text(r.hospitalName,
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: _fontSize + 3,
                                                fontFamily: 'SFUIDisplay',
                                              )))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: _spaceSize,
                                ),
                                Column(
                                  children: <Widget>[
                                    Tooltip(
                                      message: AppLocalizations.of(context)
                                          .tr('location'),
                                      child: GestureDetector(
                                        onTap: () {
                                          openMapsSheet(context);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              "assets/icon/map_location.svg",
                                              width: _iconSize,
                                            ),
                                            SizedBox(
                                              width: _spaceIcon,
                                            ),
                                            Flexible(
                                                child: Text(r.hospitalAddress,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: _fontSize + 3,
                                                      fontFamily: 'SFUIDisplay',
                                                    )))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: _spaceSize,
                                    ),
                                    Tooltip(
                                      message: AppLocalizations.of(context)
                                          .tr('bloodG'),
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "assets/icon/blood.svg",
                                            width: _iconSize,
                                          ),
                                          SizedBox(
                                            width: _spaceIcon,
                                          ),
                                          Flexible(
                                              child: Text(
                                            (r.bloodType.toLowerCase() ==
                                                        "ANY".toLowerCase()
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .tr('any')
                                                    : r.bloodType) +
                                                '       ' +
                                                AppLocalizations.of(context)
                                                    .plural('unit', r.unitsNb),
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: _fontSize + 3,
                                              fontFamily: 'SFUIDisplay',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _spaceSize,
                                    ),
                                    Tooltip(
                                      message: AppLocalizations.of(context)
                                          .tr('publishDate'),
                                      child: Row(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            "assets/icon/calendar.svg",
                                            width: _iconSize,
                                          ),
                                          SizedBox(
                                            width: _spaceIcon,
                                          ),
                                          Flexible(
                                            child: Text(
                                              r.publishDate.day.toString() +
                                                  '-' +
                                                  r.publishDate.month
                                                      .toString() +
                                                  '-' +
                                                  r.publishDate.year
                                                      .toString() +
                                                  '    ' +
                                                  ((r.publishDate.hour > 12)
                                                      ? (-12 +
                                                              r.publishDate
                                                                  .hour)
                                                          .toString()
                                                      : r.publishDate.hour
                                                          .toString()) +
                                                  ':' +
                                                  (r.publishDate.minute < 10
                                                      ? "0" +
                                                          r.publishDate.minute
                                                              .toString()
                                                      : r.publishDate.minute
                                                          .toString()) +
                                                  ' ' +
                                                  ((r.publishDate.hour > 12)
                                                      ? AppLocalizations.of(
                                                              context)
                                                          .tr('pm')
                                                      : AppLocalizations.of(
                                                              context)
                                                          .tr('am')),
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: _fontSize,
                                                fontFamily: 'SFUIDisplay',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    r.patientName == null
                                        ? Container()
                                        : SizedBox(
                                            height: _spaceSize,
                                          ),
                                    r.patientName == null
                                        ? Container()
                                        : Tooltip(
                                            message:
                                                AppLocalizations.of(context)
                                                    .tr('patientName'),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  "assets/icon/patient.svg",
                                                  width: _iconSize,
                                                ),
                                                SizedBox(
                                                  width: _spaceIcon,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    r.patientName,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: _fontSize,
                                                      fontFamily: 'SFUIDisplay',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    r.description == null
                                        ? Container()
                                        : SizedBox(
                                            height: _spaceSize,
                                          ),
                                    r.description == null
                                        ? Container()
                                        : Tooltip(
                                            message:
                                                AppLocalizations.of(context)
                                                    .tr('description'),
                                            child: Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  "assets/icon/description.svg",
                                                  width: _iconSize,
                                                ),
                                                SizedBox(
                                                  width: _spaceIcon,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    r.description,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: _fontSize,
                                                      fontFamily: 'SFUIDisplay',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: _spaceSize * 3,
                                    ),
                                    isWaiting()
                                        ? _widget["cancel"]
                                        : _widget["donated_unit"],
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: (lang == "ar")
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Tooltip(
                                message: AppLocalizations.of(context).plural(
                                  'urgency',
                                  r.urgency == 'low'
                                      ? 2
                                      : r.urgency == 'medium' ? 1 : 0,
                                ),
                                child: SvgPicture.asset(
                                  "assets/icon/circle.svg",
                                  width: 16,
                                  color: r.urgency == 'low'
                                      ? Colors.red
                                      : r.urgency == 'meduim'
                                          ? Colors.amber
                                          : Colors.green,
                                ),
                              ),
                            ),
                            Align(
                              alignment: (lang == "ar")
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                              child: Tooltip(
                                message:
                                    AppLocalizations.of(context).tr('status'),
                                child: SvgPicture.asset(
                                  isFinished()
                                      ? "assets/icon/waiting.svg"
                                      : isWaiting()
                                          ? "assets/icon/request_waiting.svg"
                                          : "assets/icon/finished.svg",
                                  width: 42,
                                  color: colors["color4"],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          )),
    );
  }

/* Widget requestWidget(Requests r, context) {
    return ;
  }*/
  openMapsSheet(context) async {
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

  bool isDonated() {
    return r.statusDonation == 'donated';
  }

  bool isProcessing() {
    return r.statusDonation == 'processing';
  }

  bool isFinished() {
    return r.statusRequest == 'finished';
  }

  bool isWaiting() {
    return r.statusRequest == 'waiting';
  }

  void cancelRequest() async{
     InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    //get data from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    db.cancelAddedRequest(r.id);
    Navigator.of(context).pop();
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
    //get data from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map data;
    try {
      data = await (db.getRequestDetails(_userId, _shared.get('idPost')));
    } catch (_) {
      if (!await internetConnection.checkConn()) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            (Route<dynamic> route) => false);
        return;
      }
    }
    if (data == null) Navigator.of(context).pop();
    if (mounted)
      setState(() {
        r = Requests.fromJson(data);
        initialValues(context);
      });
//
//    _refreshController.refreshCompleted();

    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

//    r = Requests();
//    r.urgency = 'Low';
//    r.statusRequest = 'posted';
//    r.publishDate = DateTime(2019, 12, 24, 13, 10);
//    r.unitsNb = 4;
//    r.unitsDonated = 0;
//    r.hospitalName = "الشيخ راغب حرب";
//    r.bloodType = 'O+';
//    r.description = 'asdasdasdwqe';
//    r.statusDonation = 'donated';
//    r.dateAnswerDonation = DateTime(2019, 12, 24, 14, 10);
//    r.dateReplyDonation = DateTime(2019, 12, 24, 14, 20);
//    r.patientName = 'ali';
//    r.hospitalAddress =
//        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';
//    r.hospitalLatitude = 33.389495;
//
//    r.hospitalLongitude = 35.440402;
//    setState(() {
//      initialValues(context);
//    });

    _refreshController.refreshCompleted();
    if (mounted)
      setState(() {
        refresh = false;
      });
  }

  @override
  void dispose() {
    _shared.set('idPost', null);
    _shared.set('idDonation', null);
    _refreshController.dispose();
    super.dispose();
  }

  initialValues(BuildContext context) {
    _widget = {
      "cancel": MaterialButton(
        onPressed: () {
          cancelRequest();
        },
        //since this is only a UI app
        child: Text(
          AppLocalizations.of(context).tr('cancel').toUpperCase(),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      "donated_unit": Tooltip(
        message: AppLocalizations.of(context).tr('donatedUnit'),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icon/blood_donation.svg",
              width: _iconSize,
            ),
            SizedBox(
              width: _spaceIcon,
            ),
            Flexible(
              child: Text(
                AppLocalizations.of(context).plural('donatedUnits',
                    r.unitsDonated == null ? 0 : r.unitsDonated),
                softWrap: true,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontFamily: 'SFUIDisplay',
                ),
              ),
            ),
          ],
        ),
      )
    };
  }

/* openMapsSheet(context) async {
    try {
      final title = "";
      final description = "";
      final coords = Coords(r.hospitalLatitude, r.hospitalLongitude);
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps);
      List<Widget> widget = List();
      for (var map in availableMaps) {
        widget.add(ListTile(
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
        ));
      }
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: ListView.builder(
                  itemCount: widget.length,
                  itemBuilder: (BuildContext context, index) {
                    return widget[index];
                  }));
        },
      );
    } catch (e) {
      print(e);
    }
  }*/
}
