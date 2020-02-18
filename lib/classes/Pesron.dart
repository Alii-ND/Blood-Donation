import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';

class Person {
  String _id;
  DateTime _dob;

  DateTime _lastDonation;
  String _name;
  String _password;
  String _phone;
  String _email;
  String _address;
  String _bloodType;
  String _health;
  int _point;
  double _lat;
  double _lont;

  Person();

  Person.fromJson(Map<String, dynamic> json) {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    _id = json[db.userId];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    _dob = dateFormat.parse(json[db.userDOB]);

    if (json[db.userLastDonatedate] != null)
      _lastDonation = dateFormat.parse(json[db.userLastDonatedate]);

    _name = json[db.userName];
    _password = json[db.userPassword];
    _phone = json[db.userPhoneNumber];
    _address = json[db.userAddress];
    _bloodType = json[db.userBloodType];
    _email = json[db.userEmail];
    _lat = double.parse(json[db.liveLocationLatitude]);
    _lont = double.parse(json[db.liveLocationLongitude]);
    _health = json[db.userHealth];
  }

  Map<String, dynamic> toJson() {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map<String, dynamic> json = Map();
    json[db.userId] = _id;
    json[db.userDOB] = _dob.toIso8601String();
    if (_lastDonation != null)
      json[db.userLastDonatedate] = _lastDonation.toIso8601String();
    json[db.userName] = _name;
    json[db.userPassword] = _password;
    json[db.userPhoneNumber] = _phone;
    json[db.userAddress] = _address;
    json[db.userBloodType] = _bloodType;
    json[db.userEmail] = _email;
    json[db.userHealth] = _health;
    json[db.liveLocationLatitude] = _lat;
    json[db.liveLocationLongitude] = _lont;
    return json;
  }

  String get bloodType => _bloodType;

  set bloodType(String value) {
    _bloodType = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get lastDonation => _lastDonation;

  set lastDonation(DateTime value) {
    _lastDonation = value;
  }

  DateTime get dob => _dob;

  set dob(DateTime value) {
    _dob = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get point => _point;

  set point(int value) {
    _point = value;
  }

  String get health => _health;

  set health(String value) {
    _health = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  double get lat => this._lat;

  set lat(double value) {
    this._lat = value;
  }

  double get lont => this._lont;

  set lont(double value) {
    this._lont = value;
  }
}
