import 'package:intl/intl.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';

class Offer {
  int _id;
  String _idUser;
  Hospital _hospital;
  String _status;

  Offer() {
    _hospital = Hospital();
  }

  Offer.fromJson(Map<String, dynamic> json) {
    _hospital = Hospital();
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    _id = int.parse(json[db.offerId]);
    _idUser = json[db.userId];
    _hospital.idHospital = json[db.hospitalId];
    _hospital.hospitalAddress = json[db.hospitalAddress];
    _hospital.hospitalName = json[db.hospitalName];
    _hospital.hospitalPhone = json[db.hospitalPhoneNumber];
    _hospital.hospitalLatitude = double.parse(json[db.hospitalLatitude]);
    _hospital.hospitalLongitude = double.parse(json[db.hospitalLongitude]);
    _status = json[db.offerStatus];
  }

  Map<String, dynamic> toJson() {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map<String, dynamic> json = Map();
    json[db.userId] = _idUser;
    json[db.hospitalId] = _hospital.idHospital;
    json[db.offerStatus] = _status;
    return json;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  Hospital get hospital => _hospital;

  set hospital(Hospital value) {
    _hospital = value;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
