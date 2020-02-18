import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/classes/Offer.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/sharedVariable/InternetConnection.dart';
import "package:life_saver/theme.dart" as th;
import 'package:life_saver/ui/widgetDonation/WidgetHospital.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../main.dart';

class ViewOffer extends StatefulWidget {
  ViewOffer();

  @override
  State<StatefulWidget> createState() {
    return new ViewOfferState();
  }
}

class ViewOfferState extends State<ViewOffer> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  ThemeData theme;
  int themeIndex;
  int _step = 1;
  Map colors;
  int pageNumber = 1;
  String _userId;
  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _userId = _shared.get("userId");
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");

    colors = th.theme().color[themeIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        changeWidget();
      });
    });
  }

  //GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Widget body = Container();
  List<String> _title;

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    _title = [
      AppLocalizations.of(context).tr('select_hospital'),
    ];

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        key: scaffold,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('added_offer')),
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
          child: _listItem.length == 0
              ? !_refreshController.isRefresh
                  ? Center(
                      child: Text(AppLocalizations.of(context).tr('no_data'),
                          style:
                              TextStyle(color: colors["color4"], fontSize: 17)),
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  WidgetHospital hospital;

  changeWidget() {
    if (hospital == null) {
      hospital = WidgetHospital(true);
    } else {
      hospital.changeRefresh(false);
    }

    body = hospital;
  }

  showDialogs(text) {
    CupertinoAlertDialog alt = CupertinoAlertDialog(
      title: Text(text),
      // content: Text('your message '),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(AppLocalizations.of(context).tr('ok')),
          onPressed: () {
            if (text !=
                AppLocalizations.of(context).tr('select_hospital_error'))
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

  List<Offer> _listItem = List();
  List<Widget> _listWidget = List();

  @override
  void dispose() {
    _shared.set('hospital_selected', null);
    super.dispose();
  }

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
    });
    //get point from database
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    List item = await (db.getOffers(_userId));
    for (int i = 0; i < item.length; i++) {
      if (mounted)
        setState(() {
          Offer offer = Offer.fromJson(item[i]);
          _listItem.add(offer);
          _listWidget.add(createWidget(offer));
        });
    }
    setState(() {});
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
//    setState(() {
//      addItem();
//    });

    _refreshController.refreshCompleted();
  }

  ScaffoldFeatureController scaffoldFeatureController;

  createWidget(Offer r) {
    return GestureDetector(
      onTap: () {
        String text = r.status.toLowerCase() == 'waiting'
            ? AppLocalizations.of(context).tr('offer_waiting')
            : r.status.toLowerCase() == 'processing'
                ? AppLocalizations.of(context).tr('offer_processing')
                : r.status.toLowerCase() == 'done'
                    ? AppLocalizations.of(context).tr('offer_done')
                    : r.status.toLowerCase() == 'reject'
                        ? AppLocalizations.of(context).tr('offer_reject')
                        : AppLocalizations.of(context).tr('offer_cancel');
        try {
          if (scaffoldFeatureController != null)
            scaffoldFeatureController.close();
        } catch (_) {}
        scaffoldFeatureController =
            scaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: theme.cardColor,
          content: Text(text,
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'SFUIDisplay',
                  color: colors["color4"])),
          action: (text == AppLocalizations.of(context).tr('offer_waiting') ||
                  text == AppLocalizations.of(context).tr('offer_processing'))
              ? SnackBarAction(
                  onPressed: () async {
                    DatabaseHandlerMysql db = DatabaseHandlerMysql();
                    await db.cancelOffer(r.id);
                    setState(() {
                      scaffold = GlobalKey<ScaffoldState>();
                    });
                  },
                  label:
                      AppLocalizations.of(context).tr('cancel').toUpperCase(),
                )
              : null,
        ));
      },
      onLongPress: () {
        openMapsSheet(context, r.hospital);
      },
      child: Container(
        color: theme.cardColor,
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
                              child: Text(r.hospital.hospitalName,
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
                              child: Text(r.hospital.hospitalAddress,
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
                              child: Text(r.hospital.hospitalPhone==null?'':r.hospital.hospitalPhone,
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
                  r.status.toLowerCase() == 'waiting'
                      ? "assets/icon/offer_waiting.svg"
                      : r.status.toLowerCase() == 'processing'
                          ? "assets/icon/offer_accept.svg"
                          : r.status.toLowerCase() == 'done'
                              ? "assets/icon/offer_done.svg"
                              : "assets/icon/offer_cancel.svg",
                  width: 24,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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

    Offer o1 = Offer();
    Offer o2 = Offer();
    Offer o3 = Offer();
    Offer o4 = Offer();
    o1.hospital = h1;
    o2.hospital = h2;
    o3.hospital = h3;
    o4.hospital = h3;
    o1.status = 'done';
    o2.status = 'processing';
    o3.status = 'waiting';
    o4.status = 'canceled';
    _listItem.add(o1);
    _listItem.add(o2);
    _listItem.add(o3);
    _listItem.add(o4);
    addWidget();
  }

  addWidget() {
    for (int i = 0; i < _listItem.length; i++) {
      _listWidget.add(createWidget(_listItem[i]));
    }
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
}
