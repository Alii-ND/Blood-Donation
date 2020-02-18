import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import "package:life_saver/theme.dart" as th;

class Help extends StatefulWidget {
  Help();

  @override
  State<StatefulWidget> createState() {
    return new HelpState();
  }
}

class HelpState extends State<Help> {
  GlobalState _shared = GlobalState.instance;
  String lang;
  int themeIndex;
  ThemeData theme;
  Map colors;
  List<dynamic> item;

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

    item = [
      ListTile(
        title: Text(AppLocalizations.of(context).tr('faq')),
        leading: Icon(Icons.help_outline,color: colors["color5"],),
        onTap: () {Navigator.of(context).pushNamed('/faq');},
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('contact_us')),
        subtitle: Text(AppLocalizations.of(context).tr('question_need_help')),
        leading: Icon(Icons.group,color: colors["color5"]),
        onTap: () async {
          final Email email = Email(
            body: '',
            subject: AppLocalizations.of(context).tr('question_and_help'),
            recipients: ['noontech.nt@gmail.com'],
            isHTML: false,
          );

          await FlutterEmailSender.send(email);
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('terms')),
        leading: Icon(Icons.description,color: colors["color5"]),
        onTap: () {
          Navigator.of(context).pushNamed('/termes');
        },
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).tr('app_info')),
        leading: Icon(Icons.info_outline,color: colors["color5"]),
        onTap: () {
          Navigator.of(context).pushNamed('/appInfo');
        },
      )
    ];

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          backgroundColor: colors["color2"],
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('help')),
          ),
          body: ListView.builder(
            itemCount: item.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                color: Theme.of(context).cardColor,
                child: item[index],
                margin: EdgeInsets.all(0),
              );
            },
          )),
    );
  }
}
