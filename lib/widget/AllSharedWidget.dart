import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/classes/Pesron.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AllSharedWidget {
  Map _colors;
  ThemeData _theme;

  AllSharedWidget(this._colors, this._theme);

  Widget requestWidget(Requests r, context, GlobalState _share) {
    return GestureDetector(
      onTap: () {
        if (r.idRequester == null || r.idRequester.isEmpty) {
          _share.set('idPost', r.id);
        } else {
          _share.set('idDonation', r.idRequester);
        }
        Navigator.of(context).pushNamed('/viewrequests');
      },
      child: Container(
        color: _theme.cardColor,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 9,
                  child: Column(
                    children: <Widget>[
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
                            "assets/icon/blood_donation.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                            (r.bloodType.toLowerCase() == "ANY".toLowerCase()
                                    ? AppLocalizations.of(context).tr('any')
                                    : r.bloodType) +
                                '       ' +
                                AppLocalizations.of(context)
                                    .plural('unit', r.unitsNb - r.unitsDonated),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icon/calendar.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                                  r.publishDate.day.toString() +
                                      '-' +
                                      r.publishDate.month.toString() +
                                      '-' +
                                      r.publishDate.year.toString() +
                                      '    ' +
                                      ((r.publishDate.hour > 12)
                                          ? (-12 + r.publishDate.hour)
                                              .toString()
                                          : r.publishDate.hour.toString()) +
                                      ':' +
                                      (r.publishDate.minute < 10
                                          ? "0" +
                                              r.publishDate.minute.toString()
                                          : r.publishDate.minute.toString()) +
                                      ' ' +
                                      ((r.publishDate.hour > 12)
                                          ? AppLocalizations.of(context)
                                              .tr('pm')
                                          : AppLocalizations.of(context)
                                              .tr('am')),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay',
                                  ))),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icon/circle.svg",
                      width: 10,
                      color: r.urgency == 'low'
                          ? Colors.green
                          : r.urgency == 'meduim' ? Colors.amber : Colors.red,
                    ),
                    SizedBox(
                      height: 62,
                    ),
                    SvgPicture.asset(
                      r.statusRequest == 'posted'
                          ? "assets/icon/waiting.svg"
                          : r.statusRequest == 'waiting'
                              ? "assets/icon/request_waiting.svg"
                              : "assets/icon/finished.svg",
                      width: 16,
                      color: _colors["color4"],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget requestAddedWidget(Requests r, context, Global) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/ViewAddedRequest');
      },
      child: Container(
        color: _theme.cardColor,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 9,
                  child: Column(
                    children: <Widget>[
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
                            "assets/icon/blood_donation.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                            (r.bloodType.toLowerCase() == "ANY".toLowerCase()
                                    ? AppLocalizations.of(context).tr('any')
                                    : r.bloodType) +
                                '       ' +
                                AppLocalizations.of(context)
                                    .plural('unit', r.unitsNb - r.unitsDonated),
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            "assets/icon/calendar.svg",
                            width: 24,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                                  r.publishDate.day.toString() +
                                      '-' +
                                      r.publishDate.month.toString() +
                                      '-' +
                                      r.publishDate.year.toString() +
                                      '    ' +
                                      ((r.publishDate.hour > 12)
                                          ? (-12 + r.publishDate.hour)
                                              .toString()
                                          : r.publishDate.hour.toString()) +
                                      ':' +
                                      (r.publishDate.minute < 10
                                          ? "0" +
                                              r.publishDate.minute.toString()
                                          : r.publishDate.minute.toString()) +
                                      ' ' +
                                      ((r.publishDate.hour > 12)
                                          ? AppLocalizations.of(context)
                                              .tr('pm')
                                          : AppLocalizations.of(context)
                                              .tr('am')),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay',
                                  ))),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/icon/circle.svg",
                      width: 10,
                      color: r.urgency == 'low'
                          ? Colors.green
                          : r.urgency == 'meduim' ? Colors.amber : Colors.red,
                    ),
                    SizedBox(
                      height: 62,
                    ),
                    SvgPicture.asset(
                      r.statusRequest == 'posted'
                          ? "assets/icon/waiting.svg"
                          : r.statusRequest == 'waiting'
                              ? "assets/icon/request_waiting.svg"
                              : "assets/icon/finished.svg",
                      width: 16,
                      color: _colors["color4"],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: avoid_init_to_null
  selectBloodGroup(context,
      {TextEditingController bloodG = null, Person person = null}) {
    SimpleDialog simpleDialog = SimpleDialog(
      title: Text(AppLocalizations.of(context).tr('bloodG')),
      children: <Widget>[
        SimpleDialogOption(
            child: Text('O+'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'O+';
              else if (person != null) person.bloodType = 'O+';

              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('O-'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'O-';
              else if (person != null) person.bloodType = 'O-';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('A+'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'A+';
              else if (person != null) person.bloodType = 'A+';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('A-'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'A-';
              else if (person != null) person.bloodType = 'A-';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('B+'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'B+';
              else if (person != null) person.bloodType = 'B+';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('B-'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'B-';
              else if (person != null) person.bloodType = 'B-';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('AB+'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'AB+';
              else if (person != null) person.bloodType = 'AB+';
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: Text('AB-'),
            onPressed: () {
              if (bloodG != null)
                bloodG.text = 'AB-';
              else if (person != null) person.bloodType = 'AB-';
              Navigator.of(context).pop();
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

  ProgressDialog getProgressDialog(context) {
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: AppLocalizations.of(context).tr('please_wait'),
        borderRadius: 10.0,
        backgroundColor: _colors["color2"],
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: _colors["color4"],
            fontSize: 13.0,
            fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: _colors["color4"],
            fontSize: 19.0,
            fontWeight: FontWeight.w600));
    return pr;
  }
}
