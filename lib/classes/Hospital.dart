import 'package:life_saver/database/DatabaseHandlerMysql.dart';

class Hospital {
  Hospital();

  String _hospitalAddress;
  double _hospitalLatitude;
  double _hospitalLongitude;
  String _hospitalName;
  String _hospitalPhone;
  String _idHospital;

  bool _click = false;
  Hospital.fromJson(Map<String, dynamic> json) {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    _idHospital = json[db.hospitalId];
    _hospitalAddress = json[db.hospitalAddress];
    _hospitalPhone = json[db.hospitalPhoneNumber];
    _hospitalName = json[db.hospitalName];
    _hospitalLatitude = double.parse(json[db.hospitalLatitude]);
    _hospitalLongitude = double.parse(json[db.hospitalLongitude]);
  }

  String get hospitalAddress => _hospitalAddress;

  set hospitalAddress(String value) {
    _hospitalAddress = value;
  }

  double get hospitalLatitude => _hospitalLatitude;

  String get hospitalPhone => _hospitalPhone;

  set hospitalPhone(String value) {
    _hospitalPhone = value;
  }

  String get hospitalName => _hospitalName;

  set hospitalName(String value) {
    _hospitalName = value;
  }

  double get hospitalLongitude => _hospitalLongitude;

  set hospitalLongitude(double value) {
    _hospitalLongitude = value;
  }

  set hospitalLatitude(double value) {
    _hospitalLatitude = value;
  }

  String get idHospital => _idHospital;

  set idHospital(String value) {
    _idHospital = value;
  }

  bool get click => _click;

  set click(bool value) {
    _click = value;
  }
}
