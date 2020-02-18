import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class ViewRequests extends StatefulWidget {
  ViewRequests();

  @override
  State<StatefulWidget> createState() {
    return new ViewRequestsState();
  }
}

class ViewRequestsState extends State<ViewRequests> {
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
  bool canDoantion;
  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    _widget = Map();
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");
    canDoantion = _shared.get("canDonation");
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
                                                    .plural(
                                                        'unit',
                                                        r.unitsNb -
                                                            r.unitsDonated),
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
                                    r.patientName == null ||
                                            !r.patientVisibility
                                        ? Container()
                                        : SizedBox(
                                            height: _spaceSize,
                                          ),
                                    r.patientName == null ||
                                            !r.patientVisibility
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
                                    isPostedRequest()
                                        ? (isProcessingDonation() ||
                                                isCouldDonation() ||
                                                isDonatedDonation()
                                            ? _widget["dateAnswer"]
                                            : (isNotExists() ||
                                                        isCancelDonation()) &&
                                                    canDoantion
                                                ? _widget["dateForm"]
                                                : isCannotDonation()
                                                    ? _widget["cannot"]
                                                    : Container())
                                        : (isFinishedRequest()
                                            ? (isCancelDonation()
                                                ? _widget["canceled"]
                                                : isDonatedDonation() ||
                                                        isCouldDonation()
                                                    ? _widget["dateAnswer"]
                                                    : isNotComeDonation()
                                                        ? _widget["notCome"]
                                                        : isCannotDonation()
                                                            ? _widget["cannot"]
                                                            : Container())
                                            : Container()),
                                    SizedBox(
                                      height: _spaceSize,
                                    ),
                                    isPostedRequest()
                                        ? (isProcessingDonation() ||
                                                isCouldDonation() ||
                                                isDonatedDonation()
                                            ? _widget["dateReply"]
                                            : (isNotExists() ||
                                                        isCancelDonation()) &&
                                                    canDoantion
                                                ? _widget["save"]
                                                : Container())
                                        : (isFinishedRequest()
                                            ? isDonatedDonation() ||
                                                    isCouldDonation()
                                                ? _widget["dateReply"]
                                                : Container()
                                            : Container()),
                                    SizedBox(
                                      height: _spaceSize,
                                    ),
                                    isPostedRequest()
                                        ? (isProcessingDonation()
                                            ? _widget["cancel"]
                                            : isDonatedDonation() ||
                                                    isCouldDonation()
                                                ? _widget["thanks_donation"]
                                                : Container())
                                        : (isFinishedRequest()
                                            ? isDonatedDonation() ||
                                                    isCouldDonation()
                                                ? _widget["thanks_donation"]
                                                : Container()
                                            : Container()),
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
                                  isFinishedRequest()
                                      ? "assets/icon/finished.svg"
                                      : isWaitingRequest()
                                          ? "assets/icon/request_waiting.svg"
                                          : "assets/icon/waiting.svg",
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

  bool isFinishedRequest() {
    return r.statusRequest.toLowerCase() == 'finished';
  }

  bool isPostedRequest() {
    return r.statusRequest.toLowerCase() == 'posted';
  }

  bool isWaitingRequest() {
    return r.statusRequest.toLowerCase() == 'waiting';
  }

  bool isProcessingDonation() {
    return r.statusDonation.toLowerCase() == 'processing';
  }

  bool isDonatedDonation() {
    return r.statusDonation.toLowerCase() == 'donated';
  }

  bool isCancelDonation() {
    return r.statusDonation.toLowerCase() == 'cancel';
  }

  bool isCannotDonation() {
    return r.statusDonation.toLowerCase() == 'cannot';
  }

  bool isCouldDonation() {
    return r.statusDonation.toLowerCase() == 'couldnotreachattime';
  }

  bool isNotComeDonation() {
    return r.statusDonation.toLowerCase() == 'notcome';
  }

  bool isNotExists() {
    return (r.statusDonation == null || r.statusDonation.trim().isEmpty);
  }

  void saveDonation() async {
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
    DateTime d = DateTime.now();
    DateTime dt = DateTime(d.year, d.month, d.day,
        _time.text.split(':')[0] as int, _time.text.split(':')[1] as int);
    if (await db.setDonationSave(
        r.idRequester, _userId, d.toUtc(), dt.toUtc())) {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('saved'));
    } else {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('error'));
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

  void cancelDonation() async {
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

    if (await db.setDonationCancel(r.id)) {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('canceledd'));
    } else {
      pr.hide();
      showDialogs(AppLocalizations.of(context).tr('error'));
    }
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
      if (_shared.get('idDonation') == null) {
        data = await (db.getRequestDetails(_userId, _shared.get('idPost')));
      } else {
        data = await (db.getRequestDetailsById(_shared.get('idDonation')));
      }
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
        //initialValues(context);
      });
//
//    _refreshController.refreshCompleted();

    //   await Future.delayed(Duration(milliseconds: 100));
    // if failed,use refreshFailed()

//    r = Requests();
//    r.urgency = 'medium';
//    r.statusRequest = 'finished';
//    r.publishDate = DateTime(2019, 12, 24, 13, 10);
//    r.unitsNb = 4;
//    r.unitsDonated = 2;
//    r.hospitalName = "الشيخ راغب حرب";
//    r.bloodType = 'O+';
//    //r.description = 'asdasdasdwqe';
//    r.statusDonation = 'donated';
//    r.dateAnswerDonation = DateTime(2019, 12, 24, 14, 10);
//    r.dateReplyDonation = DateTime(2019, 12, 24, 14, 20);
//    // r.patientName = 'ali';
//    r.hospitalAddress =
//        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';
//    r.hospitalLatitude = 33.389495;
//    setState(() {
//      r.hospitalLongitude = 35.440402;
//      initialValues(context);
//    });

    _refreshController.refreshCompleted();
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
      "dateReply": Tooltip(
        message: AppLocalizations.of(context).tr('dateReply'),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icon/date_reply.svg",
              width: _iconSize,
            ),
            SizedBox(
              width: _spaceIcon,
            ),
            Flexible(
              child: Text(
                r.dateReplyDonation.day.toString() +
                    '-' +
                    r.dateReplyDonation.month.toString() +
                    '-' +
                    r.dateReplyDonation.year.toString() +
                    '    ' +
                    ((r.dateReplyDonation.hour > 12)
                        ? (-12 + r.dateReplyDonation.hour).toString()
                        : r.dateReplyDonation.hour.toString()) +
                    ':' +
                    (r.dateReplyDonation.minute < 10
                        ? "0" + r.dateReplyDonation.minute.toString()
                        : r.dateReplyDonation.minute.toString()) +
                    ' ' +
                    ((r.dateAnswerDonation.hour > 12)
                        ? AppLocalizations.of(context).tr('pm')
                        : AppLocalizations.of(context).tr('am')),
                style: TextStyle(
                  fontSize: _fontSize,
                  fontFamily: 'SFUIDisplay',
                ),
              ),
            ),
          ],
        ),
      ),
      "save": MaterialButton(
        onPressed: () {
          saveDonation();
        },
        //since this is only a UI app
        child: Text(
          AppLocalizations.of(context).tr('save'),
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
      "thanks_donation": Center(
          child: Tooltip(
        message: AppLocalizations.of(context).tr('thanks_for_donation'),
        child: SvgPicture.asset(
          "assets/icon/donated.svg",
          width: 150,
        ),
      )),
      "cancel": MaterialButton(
        onPressed: () {
          cancelDonation();
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
      "time_to_go": Tooltip(
        message: AppLocalizations.of(context).tr('time_to_go'),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icon/date_reply.svg",
              width: _iconSize,
            ),
            SizedBox(
              width: _spaceIcon,
            ),
            Flexible(
              child: Text(
                r.dateReplyDonation.day.toString() +
                    '-' +
                    r.dateReplyDonation.month.toString() +
                    '-' +
                    r.dateReplyDonation.year.toString() +
                    '    ' +
                    ((r.dateReplyDonation.hour > 12)
                        ? (-12 + r.dateReplyDonation.hour).toString()
                        : r.dateReplyDonation.hour.toString()) +
                    ':' +
                    (r.dateReplyDonation.minute < 10
                        ? "0" + r.dateReplyDonation.minute.toString()
                        : r.dateReplyDonation.minute.toString()) +
                    ' ' +
                    ((r.dateReplyDonation.hour > 12)
                        ? AppLocalizations.of(context).tr('pm')
                        : AppLocalizations.of(context).tr('am')),
                style: TextStyle(
                  fontSize: _fontSize,
                  fontFamily: 'SFUIDisplay',
                ),
              ),
            ),
          ],
        ),
      ),
      "dateForm": DateTimeField(
        readOnly: true,
        format: DateFormat("HH:mm"),
        controller: _time,
        autovalidate: _timeAutoValidation,
        validator: (arg) {
          if (_time.text == "") {
            return AppLocalizations.of(context).tr('required');
          }
          return null;
        },
        style: TextStyle(color: colors["color4"], fontFamily: 'SFUIDisplay'),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: AppLocalizations.of(context).tr('time_to_go'),
            prefixIcon: SvgPicture.asset(
              "assets/icon/time_arrive.svg",
              width: 12,
              color: colors["color4"],
            ),
            labelStyle: TextStyle(fontSize: 15)),
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
      "dateAnswer": Tooltip(
        message: AppLocalizations.of(context).tr('dateAnswer'),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              "assets/icon/date_answer.svg",
              width: _iconSize,
            ),
            SizedBox(
              width: _spaceIcon,
            ),
            Flexible(
              child: Text(
                r.dateAnswerDonation.day.toString() +
                    '-' +
                    r.dateAnswerDonation.month.toString() +
                    '-' +
                    r.dateAnswerDonation.year.toString() +
                    '    ' +
                    ((r.dateAnswerDonation.hour > 12)
                        ? (-12 + r.dateAnswerDonation.hour).toString()
                        : r.dateAnswerDonation.hour.toString()) +
                    ':' +
                    (r.dateAnswerDonation.minute < 10
                        ? "0" + r.dateAnswerDonation.minute.toString()
                        : r.dateAnswerDonation.minute.toString()) +
                    ' ' +
                    ((r.dateAnswerDonation.hour > 12)
                        ? AppLocalizations.of(context).tr('pm')
                        : AppLocalizations.of(context).tr('am')),
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
      "canceled": Center(
          child: Tooltip(
        message: AppLocalizations.of(context).tr('canceled'),
        child: SvgPicture.asset(
          "assets/icon/canceled.svg",
          width: 150,
        ),
      )),
      "notCome": Center(
          child: Tooltip(
        message: AppLocalizations.of(context).tr('notCome'),
        child: SvgPicture.asset(
          "assets/icon/canceled.svg",
          width: 150,
        ),
      )),
      "cannot": Center(
          child: Tooltip(
        message: AppLocalizations.of(context).tr('cannot'),
        child: SvgPicture.asset(
          "assets/icon/cannot.svg",
          width: 150,
        ),
      )),
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
