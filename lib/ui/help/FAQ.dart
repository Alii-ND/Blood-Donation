import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;
import 'package:tree_view/tree_view.dart';

class FAQs extends StatefulWidget {
  FAQs();

  @override
  State<StatefulWidget> createState() {
    return new FAQState();
  }
}

class FAQState extends State<FAQs> {
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
        backgroundColor: colors["color2"],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).tr('faq')),
        ),
        body: TreeView(
          parentList: [
            Parent(
              parent: Card(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  title: Text(
                      AppLocalizations.of(context).tr('icon').toUpperCase()),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: colors["color1"],
                  ),
                  leading: Icon(Icons.image),
                ),
                margin: EdgeInsets.all(0),
              ),
              childList: ChildList(
                children: <Widget>[
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)
                          .tr('waiting_respoce_form_hospital')),
                      leading: SvgPicture.asset(
                        "assets/icon/request_waiting.svg",
                        width: 32,
                        color: colors["color4"],
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('waiting_donation')),
                      leading: SvgPicture.asset(
                        "assets/icon/waiting.svg",
                        color: colors["color4"],
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('finish_donation')),
                      leading: SvgPicture.asset(
                        "assets/icon/finished.svg",
                        color: colors["color4"],
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).plural('urgency', 0)),
                      leading: SvgPicture.asset(
                        "assets/icon/circle.svg",
                        color: Colors.green,
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).plural('urgency', 1)),
                      leading: SvgPicture.asset(
                        "assets/icon/circle.svg",
                        color: Colors.amber,
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).plural('urgency', 2)),
                      leading: SvgPicture.asset(
                        "assets/icon/circle.svg",
                        color: Colors.red,
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('offer_cancel')),
                      leading: SvgPicture.asset(
                        "assets/icon/offer_cancel.svg",
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('offer_processing')),
                      leading: SvgPicture.asset(
                        "assets/icon/offer_accept.svg",
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('offer_done')),
                      leading: SvgPicture.asset(
                        "assets/icon/offer_done.svg",
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          AppLocalizations.of(context).tr('offer_waiting')),
                      leading: SvgPicture.asset(
                        "assets/icon/offer_waiting.svg",
                        width: 32,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
