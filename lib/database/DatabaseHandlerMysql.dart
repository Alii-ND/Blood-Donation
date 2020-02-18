import 'dart:convert';

import 'package:http/http.dart' as http;

class DatabaseHandlerMysql {
  DatabaseHandlerMysql();

  static String _url = "http://cmgme.com/LifeSaver/LifeSaverDB/";
  static Map<String, String> header = {"Content-Type": "application/json"};

  //charest = UTF-8
  String canDonation = "canDonation";

//Phrases from returned data

  String notFound = "Not found!";
  String error = "Error";
  String inserted = "Data inserted successfully";
  String errorInsert = "Error inserting Data";
  String update = "Data Updated successfully";
  String errorUpdate = "Error Updating Data";

/*-----------------------------------------------------------------------------------------------*/

//Tables

/*set  =  get*/

//Users
  String userId = "userId";
  String userName = "userName";
  String userEmail = "userEmail";
  String userDOB = "userDOB";
  String userPassword = "userPassword";
  String userBloodType = "userBloodType";
  String userPhoneNumber = "userPhoneNumber";
  String userAddress = "userAddress";
  String userLastDonatedate = "userLastDonatedate";
  String userStatus = "userStatus";
/* 1 -> Active, 0 -> Blocked*/
  String userHealth = "userHealth";

//Hospitals
  String hospitalId = "hospitalId";
  String hospitalName = "hospitalName";
  String hospitalEmail = "hospitalEmail";
  String hospitalPassword = "hospitalPassword";
  String hospitalPhoneNumber = "hospitalPhoneNumber";
  String hospitalStatus = "hospitalStatus";
/* 0 -> Unverified, 1 -> Active, 2 -> banned, 3 -> Deleted*/
  String hospitalAddress = "hospitalAddress";
  String hospitalLatitude = "hospitalLatitude";
  String hospitalLongitude = "hospitalLongitude";

//Points
  String pointId = "pointId";
  String pointDateOfObtaining = "pointsDateOfObtaining";
  String pointDescription = "pointsDescription";
/* 0 -> daily point, 1 -> donation points, 2 -> Feast points, 3 -> share points*/
  String pointAmount = "pointsAmount";

//PointsArchive
  String pointsArchiveId = "pointsArchiveId";
  String pointsArchiveYear = "pointsArchiveYear";
  String pointsArchiveAmount = "pointsArchiveAmount";

//Requests
  String requestId = "requestId";
  String requestBloodType = "requestBloodType";
  String requestPublishDate = "requestPublishDate";
  String requestStatus = "requestStatus";
  String requestUnitsNumber = "requestUnitsNumber";
  String requestPatientName = "requestPatientName";
  String requestUrgency = "requestUrgency";
  String requestDescription = "requestDescription";
  String requestPatientNameVisibility = "requestPatientNameVisibility";
  String requestDonatedUnits = "requestDonatedUnits";

//HospitalDonationReply
  String replyId = "replyId";
  String replyStatus = "replyStatus";
  String replyDate = "replyDate";
  String replyDateAnswer = "replyDateAnswer";

//UserDonationOffer
  String offerId = "offerId";
  String offerStatus = "offerStatus";
  String offerDate = "offerDate";

//LiveLocation
  String liveLocationLatitude = "liveLocationLatitude";
  String liveLocationLongitude = "liveLocationLongitude";

//Settings
  String userOrHostpitalId = "userOrHospitalId";
  String settingsZone = "settingsZone";
  String settingsLanguage = "settingsLanguage";

  Future<Map<String, dynamic>> checkId(String idU) async {
    String url = _url + "Select/13_SelectUserIfEXISTSOnLogin.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return Map();
    } catch (_) {
      return Map();
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getUser(String idU) async {
    String url = _url + "Select/1_SelectUser.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return Map();
    } catch (_) {
      return Map();
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getRequestDetails(String idU, int idP) async {
    String url = _url + "Select/12_SelectAllRequestDetails.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    map[requestId] = idP;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return Map();
    } catch (_) {
      return Map();
    }
    return json.decode(response.body);
  }

  Future<List> getRequestByMe(String idU) async {
    String url = _url + "Select/16_SelectUserRequestsReply.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<List> getAddRequestByMe(String idU) async {
    String url = _url + "Select/37_NoName.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<List> getRequestByRange(String idU) async {
    String url = _url + "Select/15_SelectRequestsWithSameBloodTypeOfUser.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<List> getRequestByBloodType(String idU, String bloodType) async {
    String url;
    if (bloodType.toLowerCase() == "any")
      url = _url + "Select/11_SelectRequestsInZone.php";
    else
      url = _url + "Select/33_SelectRequestsUsingBloodType.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    map[requestBloodType] = bloodType;
    print(map);
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<List> getPoints(String idU) async {
    String url = _url + "Select/20_SelectAllPoints.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getRequestDetailsById(String idD) async {
    String url = _url + "Select/5_SelectRequests.php";
    Map<String, dynamic> map = Map();
    map[replyId] = idD;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return Map();
    } catch (_) {
      return Map();
    }
    return json.decode(response.body);
  }

  Future<List> getOffers(String idU) async {
    String url =
        _url + "Select/18_SelectUserDonationOffersAndHospitalsDetails.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    return json.decode(response.body);
  }

  Future<bool> setOffer(Map<String, dynamic> data) async {
    String url = _url + "Insert/7_InsertUserDonationOffer.php";
    var body = jsonEncode(data);
    print(data);
    http.Response response = await http.post(url, headers: header, body: body);
    print(response);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;
    return response.body.trim().toLowerCase() == inserted.toLowerCase()
        ? true
        : false;
  }

  Future<bool> setRequest(Map<String, dynamic> data) async {
    String url = _url + "Insert/5_InsertRequests.php";
    var body = jsonEncode(data);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;
    return response.body.trim().toLowerCase() == inserted.toLowerCase() &&
            response != null
        ? true
        : false;
  }

  setSetting(Map<String, dynamic> data) async {
    String url = _url + "Update/9_UpdateSettings.php";
    var body = jsonEncode(data);
    await http.post(url, headers: header, body: body);
  }

  Future<bool> setUser(Map<String, dynamic> data) async {
    String url = _url + "Insert/1_InsertUser.php";
    var body = jsonEncode(data);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;
    return response.body.trim() == "1" ? true : false;
  }

  Future<bool> checkUserName(String idU) async {
    String url = _url + "Functions/2_TestUserNameIfExists.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim() == "1" ? true : false;
  }

  sendEmail(String idU, String verificationCode, String lang) async {
    String url = _url + "sendMail/index.php";
    Map<String, dynamic> map = Map();
    map['userName'] = idU;
    map['verificationCode'] = verificationCode;
    map['lang'] = lang;
    var body = jsonEncode(map);
    await http.post(url, headers: header, body: body);
  }

  sendEmail_Email(String idU, String verificationCode, String lang) async {
    String url = _url + "sendMail/index.php";
    Map<String, dynamic> map = Map();
    map['email'] = idU;
    map['verificationCode'] = verificationCode;
    map['lang'] = lang;
    var body = jsonEncode(map);
    await http.post(url, headers: header, body: body);
  }

  Future<bool> updatePassword(String idU, String passwordU) async {
    String url = _url + "Update/14_UpdatePassword.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    map[userPassword] = passwordU;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim().toLowerCase() == update.toLowerCase()
        ? true
        : false;
  }

  Future<bool> updateUsers(Map<String, Object> data) async {
    String url = _url + "Update/1_UsersUpdate.php";

    var body = jsonEncode(data);
    http.Response response = await http.post(url, headers: header, body: body);

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim().toLowerCase() == update.toLowerCase()
        ? true
        : false;
  }

  Future<bool> cancelOffer(int idO) async {
    String url = _url + "Update/10_SetOfferStatusCanceled.php";
    Map<String, dynamic> map = Map();
    map[offerId] = idO;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim().toLowerCase() == update.toLowerCase()
        ? true
        : false;
  }

  Future<List> getHospitals(String idU) async {
    String url = _url + "Select/19_SelectAllHospitals.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return List();
    } catch (_) {
      return List();
    }
    //print(response.body);
    return json.decode(response.body);
  }

  Future<int> getNotificationIndex(String idU) async {
    String url = _url + "Select/9_SelectSettings.php";
    Map<String, dynamic> map = Map();
    map[userId] = idU;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    try {
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json.decode(response.body) == null) return 0;
    } catch (_) {
      return 0;
    }
    Map<String, dynamic> data = jsonDecode(response.body);

    return int.parse(data[settingsZone]);
  }

  void cancelAddedRequest(int id) async {
    String url = _url + "Update/11_UpdateRequestStatus.php";
    Map<String, dynamic> map = Map();
    map[requestId] = id;
    map[requestStatus] = 'delete';
    var body = jsonEncode(map);
    await http.post(url, headers: header, body: body);
  }

  Future<bool> setDonationSave(String id, String userId,
      DateTime dateAnswerDonation1, DateTime dateReplyDonation1) async {
    String url = _url + "Insert/6_InsertHospitalDonationReply.php";
    Map<String, dynamic> map = Map();
    map[requestId] = id;
    map[userId] = userId;
    map[replyDateAnswer] = dateAnswerDonation1;
    map[replyDate] = dateReplyDonation1;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim().toLowerCase() == inserted.toLowerCase()
        ? true
        : false;
  }

  Future<bool> setDonationCancel(int id) async {
    String url = _url + "Update/15_UpdateReplySatuts.php";
    Map<String, dynamic> map = Map();
    map[requestId] = id;
    var body = jsonEncode(map);

    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim().toLowerCase() == update.toLowerCase()
        ? true
        : false;
  }

  Future<bool> checkPoints(String idu) async {
    String url = _url + "Functions/1_CanGetDailyCoin.php";
    Map<String, dynamic> map = Map();
    map[userId] = idu;
    var body = jsonEncode(map);
    http.Response response = await http.post(url, headers: header, body: body);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        response.body == null) return false;

    return response.body.trim() == "1" ? true : false;
  }
}
