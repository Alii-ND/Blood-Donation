import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

List<Requests> _listRequester = List();
List<Widget> _listWidgetRequester = List();

class AddedRequests extends StatefulWidget {
  AddedRequests();

  @override
  State<StatefulWidget> createState() {
    return new AddedRequestsState();
  }
}

class AddedRequestsState extends State<AddedRequests> {
  bool refresh;

  AddedRequestsState();

  int themeIndex;
  ThemeData theme;
  GlobalState _shared = GlobalState.instance;
  Map colors;
  RefreshController _refreshControllerNotification;
  String _userId;

  @override
  void initState() {
    super.initState();
    themeIndex = _shared.get("themeIndex");
    colors = th.theme().color[themeIndex];
    theme = _shared.get("theme");
    _userId = _shared.get("userId");
    _refreshControllerNotification = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).tr('added_request')),
            ),
            backgroundColor: colors["color2"],
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
              controller: _refreshControllerNotification,
              onRefresh: () {
                _onRefreshNotification(context);
              },
              child: _listWidgetRequester.length == 0
                  ? !_refreshControllerNotification.isRefresh
                      ? Center(
                          child: Text(
                              AppLocalizations.of(context).tr('no_data'),
                              style: TextStyle(
                                  color: colors["color4"], fontSize: 17)),
                        )
                      : Container()
                  : ListView.builder(
                      itemCount: _listWidgetRequester.length,
                      itemBuilder: (BuildContext context, index) {
                        return _listWidgetRequester[index];
                      }),
            )));
  }

  //test data
  createRequeter(context) {
    addRequests();
    addListWidgetRequest(context);
  }

  addListWidgetRequest(context) {
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    for (int i = 0; i < _listRequester.length; i++) {
      setState(() {
        _listWidgetRequester
            .add(requestWidget.requestAddedWidget(_listRequester[i], context,_shared));
      });
    }
  }

  addRequests() {
    Requests requests = Requests();
    requests.urgency = 'Low'.toLowerCase();
    requests.statusRequest = 'finished'.toLowerCase();
    requests.publishDate = DateTime(2019, 12, 24, 13, 10);
    requests.unitsNb = 4;
    requests.unitsDonated = 4;
    requests.bloodType = 'O+';
    requests.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests1 = Requests();
    requests1.urgency = 'meduim'.toLowerCase();
    requests1.statusRequest = 'posted'.toLowerCase();
    requests1.publishDate = DateTime(2019, 12, 24, 12, 00);
    requests1.unitsNb = 1;
    requests1.unitsDonated = 0;
    requests1.bloodType = 'A+';
    requests1.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests2 = Requests();
    requests2.urgency = 'Low'.toLowerCase();
    requests2.statusRequest = 'waiting'.toLowerCase();
    requests2.publishDate = DateTime(2019, 12, 22, 23, 12);
    requests2.unitsNb = 3;
    requests2.unitsDonated = 0;
    requests2.bloodType = 'AB+';
    requests2.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests3 = Requests();
    requests3.urgency = 'hight'.toLowerCase();
    requests3.statusRequest = 'posted'.toLowerCase();
    requests3.publishDate = DateTime(2019, 12, 25, 8, 10);
    requests3.unitsNb = 2;
    requests3.unitsDonated = 0;
    requests3.bloodType = 'ANY';
    requests3.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    _listRequester.add(requests);
    _listRequester.add(requests1);
    _listRequester.add(requests2);
    _listRequester.add(requests3);
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
      _listWidgetRequester.clear();
      _listRequester.clear();
    });

//    get AddedRequest from database
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    List item = await (db.getAddRequestByMe(_userId));
    print(item);
    for (int i = 0; i < item.length; i++) {
      if (mounted)
        setState(() {
          Requests requests = Requests.fromJson(item[i]);
          _listRequester.add(requests);
          _listWidgetRequester
              .add(requestWidget.requestWidget(_listRequester[i], context,_shared));
        });
    }
   if (mounted) setState(() {});
    //  _refreshControllerNotification.refreshCompleted();

    //  await Future.delayed(Duration(milliseconds: 500));
//        if(mounted)
//    setState(() {
//      createRequeter(context);
//    });
    _refreshControllerNotification.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshControllerNotification.dispose();
    super.dispose();
  }
}
