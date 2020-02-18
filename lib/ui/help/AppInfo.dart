import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:package_info/package_info.dart';

class AppInfos extends StatefulWidget {
  AppInfos();

  @override
  State<StatefulWidget> createState() {
    return new AppInfoState();
  }
}

class AppInfoState extends State<AppInfos> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  int themeIndex;
  ThemeData theme;
  Map colors;

  @override
  void initState() {
    super.initState();
    theme = _shared.get("theme");
    themeIndex = _shared.get("themeIndex");
    lang = _shared.get("lang");
    colors = th.theme().color[themeIndex];
  }

  String version = "";

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    getPageckage();
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        backgroundColor: colors["color2"],
        body: Center(
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Center(
                child: Text(AppLocalizations.of(context).tr('appName'),
                    style: TextStyle(color: colors["color4"], fontSize: 20)),
              ),
              Center(
                child: Text(version,
                    style: TextStyle(color: colors["color1"], fontSize: 17)),
              ),
              Center(
                child: SvgPicture.asset(
                  themeIndex == 0
                      ? "assets/icon/logo_original.svg"
                      : "assets/icon/logo_white.svg",
                  width: 450,
                ),
              ),
              Center(
                child: Text(AppLocalizations.of(context).tr('descriptionApp'),
                    style: TextStyle(color: colors["color1"], fontSize: 17)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getPageckage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (mounted)
      setState(() {
        version = "v " + packageInfo.version;
      });
  }
}
