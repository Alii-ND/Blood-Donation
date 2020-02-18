import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/classes/Requets.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/widget/AllSharedWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class History extends StatefulWidget {
  History();

  @override
  State<StatefulWidget> createState() {
    return new HistoryState();
  }
}

class HistoryState extends State<History> {
  String lang;
  ThemeData theme;
  int themeIndex;
  GlobalState _shared = GlobalState.instance;
  Map colors;
  String _userId;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");
    _listWidgetrequester = List();
    _listRequesters = List();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  List<Requests> _listRequesters;
  List<Widget> _listWidgetrequester;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('history')),
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
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: _listRequesters.length == 0
                ? !_refreshController.isRefresh
                    ? Center(
                        child: Text(AppLocalizations.of(context).tr('no_data'),
                            style: TextStyle(
                                color: colors["color4"], fontSize: 17)),
                      )
                    : Container()
                : ListView.builder(
                    itemCount: _listWidgetrequester.length,
                    itemBuilder: (BuildContext context, index) {
                      return _listWidgetrequester[index];
                    }),
          )),
    );
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
    setState(() {
      _listRequesters.clear();
      _listWidgetrequester.clear();
    });
    //get hisoty from database
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    List item = await (db.getRequestByMe(_userId));
    for (int i = 0; i < item.length; i++) {
      setState(() {
        Requests requests = Requests.fromJson(item[i]);
        _listRequesters.add(requests);
        _listWidgetrequester
            .add(requestWidget.requestWidget(_listRequesters[i], context,_shared));
      });
    }
    setState(() {});

    //await Future.delayed(Duration(milliseconds: 3000));
    // if failed,use refreshFailed()
//    if(mounted)
//    setState(() {
//      createRequeter(context);
//    });

    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  createRequeter(context) {
    addRequests();
    addListWidgetRequest(context);
  }

  addListWidgetRequest(context) {
    AllSharedWidget requestWidget = AllSharedWidget(colors, theme);
    _listWidgetrequester.clear();
    for (int i = 0; i < _listRequesters.length; i++) {
      _listWidgetrequester
          .add(requestWidget.requestWidget(_listRequesters[i], context,_shared));
    }
  }

  addRequests() {
    _listRequesters.clear();

    Requests requests = Requests();
    requests.urgency = 'Low'.toLowerCase();
    requests.statusRequest = 'finished'.toLowerCase();
    requests.publishDate = DateTime(2019, 12, 24, 13, 10);
    requests.unitsNb = 4;
    requests.bloodType = 'O+';
    requests.hospitalAddress =
        'Nabatiye askjldh alsjhdl;ajsh djklash dkljash lkajs hdkljash lkdj ahskl jdh.';

    Requests requests1 = Requests();
    requests1.urgency = 'meduim'.toLowerCase();
    requests1.statusRequest = 'posted'.toLowerCase();
    requests1.publishDate = DateTime(2019, 12, 24, 12, 00);
    requests1.unitsNb = 1;
    requests1.bloodType = 'A+';
    requests1.hospitalAddress =
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

    _listRequesters.add(requests);
    _listRequesters.add(requests1);
    _listRequesters.add(requests2);
    _listRequesters.add(requests3);
  }
}
