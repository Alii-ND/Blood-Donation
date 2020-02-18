import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:life_saver/service/LocationService.dart';
import 'package:life_saver/service/UserLocation.dart';
import 'package:life_saver/sharedVariable/GlobalState.dart';
import 'package:life_saver/ui/AddOfferDonation.dart';
import 'package:life_saver/ui/AddRequestDonation.dart';
import 'package:life_saver/ui/AddedRequests.dart';
import 'package:life_saver/ui/Help.dart';
import 'package:life_saver/ui/VerificationCode.dart';
import 'package:life_saver/ui/ViewAddedRequests.dart';
import 'package:life_saver/ui/ViewOffer.dart';
import 'package:life_saver/ui/help/AppInfo.dart';
import 'package:life_saver/ui/help/FAQ.dart';
import 'package:life_saver/ui/help/Termes.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import "theme.dart" as th;
import 'ui/ForgetPassword.dart';
import 'ui/History.dart';
import 'ui/Home.dart';
import 'ui/Login.dart';
import 'ui/Points.dart';
import 'ui/Profile.dart';
import 'ui/SignUp.dart';
import 'ui/ViewRequests.dart';
import 'ui/Wait.dart';
import 'package:flutter/foundation.dart'
show debugDefaultTargetPlatformOverride;// for desktop embedder
void main() {
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;// for desktop embedder
  }
  runApp(EasyLocalization(
    child: MyApp(),
  ));
}

//Home pages
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // ignore: missing_return

  GlobalState _shared = GlobalState.instance;
  var data, theme;

  @override
  void initState() {
    super.initState();
    theme = th.theme().themes[0];
    _shared.set("theme", theme);
  }

  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    _shared.set("data", data);
    theme = _shared.get('theme');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return EasyLocalizationProvider(
        data: data,
        child: RefreshConfiguration(
            headerBuilder: () => WaterDropHeader(),
            // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
            //footerBuilder:  () => ClassicFooter(),        // Configure default bottom indicator
            headerTriggerDistance: 80.0,
            // header trigger refresh trigger distance
            //  springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // custom spring back animate,the props meaning see the flutter api
            maxOverScrollExtent: 100,
            //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
            maxUnderScrollExtent: 0,
            // Maximum dragging range at the bottom
            enableScrollWhenRefreshCompleted: true,
            //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
            enableLoadingWhenFailed: true,
            //In the case of load failure, users can still trigger more loads by gesture pull-up.
            hideFooterWhenNotFull: false,
            // Disable pull-up to load more functionality when Viewport is less than one screen
            enableBallisticLoad: true,
            // trigger load more by BallisticScrollActivity
            child: StreamProvider<UserLocation>(
                create: (context) => LocationService().locationStream,
                child: MaterialApp(
                  title: 'Blood Donation',
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    //app-specific localization
                    EasylocaLizationDelegate(
                        locale: data.locale, path: 'resources/langs'),
                  ],
                  routes: <String, WidgetBuilder>{
                    '/login': (BuildContext context) => Login(),
                    //Login Page
                    '/home': (BuildContext context) => Home(),
                    //Home Page
                    '/signup': (BuildContext context) => SignUp(),
                    //SignUp Page
                    '/points': (BuildContext context) => Points(),
                    //Points page\
                    '/history': (BuildContext context) => History(),
                    //History page
                    '/profile': (BuildContext context) => Profile(),
                    //profile page
                    '/forgetPassword': (BuildContext context) =>
                        ForgetPassword(),
                    //forget password page
                    '/viewrequests': (BuildContext context) => ViewRequests(),
                    '/addRequestDonation': (BuildContext context) =>
                        AddRequestDonation(),
                    '/addOfferDonation': (BuildContext context) =>
                        AddOfferDonation(),
                    '/viewOffer': (BuildContext context) => ViewOffer(),
                    '/addedRequest': (BuildContext context) => AddedRequests(),
                    '/ViewAddedRequest': (BuildContext context) =>
                        ViewAddedRequests(),
                    '/help': (BuildContext context) => Help(),
                    '/termes':(BuildContext context) => Terms(),
                    '/appInfo':(BuildContext context) => AppInfos(),
                    '/faq':(BuildContext context) => FAQs(),
                    '/verificationCode' :(BuildContext context) =>VerificationCode()
                  },
                  supportedLocales: [
                    Locale('en', 'US'),
                    Locale('fr', 'FR'),
                    Locale('ar', 'LB')
                  ],
                  locale: data.savedLocale,
                  theme: theme,
                  home: Initial(),
                ))));

/*  setState(() {});
    print('asd');
   Center(
          child: Icon(Icons.cloud_download),*/ /*
*/
  }
}
