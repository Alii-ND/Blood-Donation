import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:tree_view/tree_view.dart';
class Terms extends StatefulWidget {
  Terms();

  @override
  State<StatefulWidget> createState() {
    return new TermsState();
  }
}

class TermsState extends State<Terms> {
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

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('termes')),
        ),
        body: Center(
          child:Text(AppLocalizations.of(context).tr('termesDetails'))
        ),
      ),
    );
  }
}
