import 'package:intl/intl.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';

class Points {
  int _id;
  String _idUser;
  DateTime _dateOdObtaining;
  String _description;
  int _amount;
  int _year;
  int _idDonation;
  Points();

  Points.fromJson(Map<String, dynamic> json) {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    _id = json[db.pointId];
    _idUser = json[db.userId];
    if (json[db.pointAmount] != null && json[db.pointAmount] != "")
      _amount = int.parse(json[db.pointAmount]);
    else if (json[db.pointsArchiveAmount] != "")
      _amount = int.parse(json[db.pointsArchiveAmount]);
    if (json[db.pointsArchiveYear] != null && json[db.pointsArchiveYear] != "")
      _year = int.parse(json[db.pointsArchiveYear]);
    else
      _year = null;
    if (json[db.pointDateOfObtaining] != null &&
        json[db.pointDateOfObtaining] != "") {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      _dateOdObtaining = dateFormat.parse(json[db.pointDateOfObtaining]);
    }
    print(_dateOdObtaining);
    _description = json[db.pointDescription];

    _idDonation = json[db.replyId];
  }
  Map<String, dynamic> toJson() {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map<String, dynamic> json = Map();
    _idUser = json[db.userId];
    _amount = json[db.pointAmount];
    _dateOdObtaining = json[db.pointDateOfObtaining];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    _dateOdObtaining = dateFormat.parse(json[db.userDOB]).toLocal();
    _description = json[db.pointDescription];
  }

  int get year => _year;

  set year(int value) {
    _year = value;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  DateTime get dateOdObtaining => _dateOdObtaining;

  set dateOdObtaining(DateTime value) {
    _dateOdObtaining = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get idDonation => _idDonation;

  set idDonation(int value) {
    _idDonation = value;
  }
}
