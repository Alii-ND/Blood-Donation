import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../main.dart';

List<Requests> _listRequesterDonation = List();
List<Widget> _listWidgetRequesterDonation = List();

class Donation extends StatefulWidget {
  bool refresh;

  Donation(this.refresh, {Key key}) : super(key: key);

  DonationState donationState;

  changeRefresh(bool _ref) {
    refresh = _ref;
  }

  clear() {
    _listRequesterDonation.clear();
    _listWidgetRequesterDonation.clear();
  }

  @override
  State<StatefulWidget> createState() {
    donationState = new DonationState(refresh);
    return donationState;
  }
}

class DonationState extends State<Donation> {
  bool refresh;

  DonationState(this.refresh);

  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  Map colors;
  String _userId;

  RefreshController _refreshControllerDonation;

  @override
  void initState() {
    super.initState();
    _refreshControllerDonation = RefreshController(initialRefresh: refresh);
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    return SmartRefresher(
      enablePullDown: true,
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
      controller: _refreshControllerDonation,
      onRefresh: () {
        _onRefreshNotification(context);
      },
      child: _listWidgetRequesterDonation.length == 0
          ? !_refreshControllerDonation.isRefresh
              ? Center(
                  child: Text(AppLocalizations.of(context).tr('no_data'),
                      style: TextStyle(color: colors["color4"], fontSize: 17)),
                )
              : Container()
          : ListView.builder(
              itemCount: _listWidgetRequesterDonation.length,
              itemBuilder: (BuildContext context, index) {
                return _listWidgetRequesterDonation[index];
              }),
    );
  }

  void _onRefreshNotification(context) async {
    InternetConnection internetConnection = InternetConnection();
    if (!await internetConnection.checkConn()) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
          (Route<dynamic> route) => false);
      return;
    }
    setState(() {
      _listWidgetRequesterDonation.clear();
      _listRequesterDonation.clear();
    });

    //get donation from database
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    String blood =
        _shared.get('bloodSelected') == AppLocalizations.of(context).tr('any')
            ? 'any'
            : _shared.get('bloodSelected');
    List item = await (db.getRequestByBloodType(_userId, blood));
    for (int i = 0; i < item.length; i++) {
      if (mounted)
        setState(() {
          Requests requests = Requests.fromJson(item[i]);
          _listRequesterDonation.add(requests);
          _listWidgetRequesterDonation.add(
              requestWidget.requestWidget(_listRequesterDonation[i], context,_shared));
        });
    }
    if (mounted) setState(() {});
//    _refreshControllerDonation.refreshCompleted();
//
//
//
//    await Future.delayed(Duration(milliseconds: 500));
//
//
//    setState(() {
//      createRequeterDonation(context);
//
//    });

    _refreshControllerDonation.refreshCompleted();
  }

  ///Test data
  createRequeterDonation(context) {
    addRequestsDonation();
    addListWidgetRequestDonation(context);
  }

  addListWidgetRequestDonation(context) {
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    _listWidgetRequesterDonation.clear();
    for (int i = 0; i < _listRequesterDonation.length; i++) {
      _listWidgetRequesterDonation
          .add(requestWidget.requestWidget(_listRequesterDonation[i], context,_shared));
    }
  }

  addRequestsDonation() {
    _listRequesterDonation.clear();

    Requests requests = Requests();
    requests.urgency = 'Low'.toLowerCase();
    requests.statusRequest = 'finished'.toLowerCase();
    requests.publishDate = DateTime(2019, 12, 24, 13, 10);
    requests.unitsNb = 4;
    requests.bloodType = 'O+';
    requests.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests2 = Requests();
    requests2.urgency = 'Low'.toLowerCase();
    requests2.statusRequest = 'posted'.toLowerCase();
    requests2.publishDate = DateTime(2019, 12, 22, 23, 12);
    requests2.unitsNb = 3;
    requests2.bloodType = 'AB+';
    requests2.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests3 = Requests();
    requests3.urgency = 'hight'.toLowerCase();
    requests3.statusRequest = 'posted'.toLowerCase();
    requests3.publishDate = DateTime(2019, 12, 25, 8, 10);
    requests3.unitsNb = 2;
    requests3.bloodType = 'ANY';
    requests3.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    _listRequesterDonation.add(requests);
    _listRequesterDonation.add(requests2);
    _listRequesterDonation.add(requests3);
  }

  @override
  void dispose() {
    _refreshControllerDonation.dispose();
    super.dispose();
  }
}
