import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/classes/Points.dart' as pt;
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class Points extends StatefulWidget {
  Points();

  @override
  State<StatefulWidget> createState() {
    return new PointsState();
  }
}

class PointsState extends State<Points> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  String _descrionDonation = "1";
  String _descrionEnter = "0";
  Map colors;
  String _userId;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    _itemPoint = List();
    _itemWidget = List();
    colors = th.theme().color[themeIndex];
    _userId = _shared.get("userId");
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
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('points')),
        ),
        backgroundColor: colors["color2"],
        body: SmartRefresher(
          enablePullDown: true,
//          enablePullUp: true,
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
          /*  footer: CustomFooter(
            builder: (BuildContext context,LoadStatus mode){
              Widget body ;
              if(mode==LoadStatus.idle){
                body =  Text("pull up load");
              }
              else if(mode==LoadStatus.loading){
                body =  Text('loading');
              }
              else if(mode == LoadStatus.failed){
                body = Text("Load Failed!Click retry!");
              }
              else if(mode == LoadStatus.canLoading){
                body = Text("release to load more");
              }
              else{
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),*/
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: _itemPoint.length == 0
              ? !_refreshController.isRefresh
                  ? Center(
                      child: Text(AppLocalizations.of(context).tr('no_data'),
                          style:
                              TextStyle(color: colors["color4"], fontSize: 17)),
                    )
                  : Container()
              : ListView.builder(
                  itemCount: _itemWidget.length,
                  itemBuilder: (BuildContext context, index) {
                    return _itemWidget[index];
                  }),
        ),
      ),
    );
  }

  List<pt.Points> _itemPoint;
  List<Widget> _itemWidget;

  Widget widgetPoint(pt.Points pt, context) {
    return Container(
        color: theme.cardColor,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: ListTile(
          leading: SvgPicture.asset(
            "assets/icon/money.svg",
            width: 42,
          ),
          title: Text(pt.year != null
              ? AppLocalizations.of(context).plural('pointT', pt.amount)
              : pt.description == _descrionDonation
                  ? AppLocalizations.of(context).tr('because_donation')
                  : AppLocalizations.of(context).tr('enter_application')),
          subtitle: Text(pt.year != null
              ? pt.year.toString()
              : pt.dateOdObtaining.day.toString() +
                  '-' +
                  pt.dateOdObtaining.month.toString() +
                  '-' +
                  pt.dateOdObtaining.year.toString() +
                  '       ' +
                  AppLocalizations.of(context).plural('point', pt.amount)),
          onTap: () {
            if (pt.year == null && pt.idDonation != null) {
              _shared.set("idDonation", pt.idDonation);
              Navigator.of(context).pushNamed('/viewRequest');
            }
          },
        ));
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
      _itemWidget.clear();
      _itemPoint.clear();
    });
    //get point from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    List item = await (db.getPoints(_userId));
    for (int i = 0; i < item.length; i++) {
      if (mounted)
        setState(() {
          pt.Points points = pt.Points.fromJson(item[i]);
          _itemPoint.add(points);
          _itemWidget.add(widgetPoint(points, context));
        });
    }
    //await Future.delayed(Duration(milliseconds: 3000));
    // if failed,use refreshFailed()
//    setState(() {
//      createElement(context);
//    });
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

//test in application
/*createElement(context) {
    addItem();
    addWidgetPoints(context);
  }

  addItem() {
    _itemPoint.clear();

    pt.Points points = pt.Points();
    points.description = "0";
    points.dateOdObtaining = DateTime(2019, 12, 25);
    points.amount = 100;
    _itemPoint.add(points);

    pt.Points points2 = pt.Points();
    points2.description = "1";
    points2.dateOdObtaining = DateTime(2019, 12, 25);
    points2.amount = 1;
    _itemPoint.add(points2);

    pt.Points points1 = pt.Points();
    points1.year = 2018;
    points1.amount = 415;
    _itemPoint.add(points1);
  }

  addWidgetPoints(context) {
    _itemWidget.clear();
    for (int i = 0; i < _itemPoint.length; i++) {
      _itemWidget.add(widgetPoint(_itemPoint[i], context));
    }
  }*/
}
