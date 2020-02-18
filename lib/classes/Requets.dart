import 'dart:core';

import 'package:intl/intl.dart';
import 'package:life_saver/classes/Hospital.dart';
import 'package:life_saver/database/DatabaseHandlerMysql.dart';

import 'HospitalDonationReply.dart';

class Requests {
  Requests() {
    _hospital = Hospital();
    _hospitalDonationReply = HospitalDonationReply();
  }

  int _id;

  String _idRequester;

  String _bloodType;
  DateTime _publishDate;
  String _statusRequest;
  int _unitsNb;
  int _unitsDonated = 0;
  String _patientName;
  String _urgency;
  String _description;
  bool _patientVisibility;
  Hospital _hospital;

  HospitalDonationReply _hospitalDonationReply;

  Requests.fromJson(Map<String, dynamic> json) {
    _hospital = Hospital();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm");
    _hospitalDonationReply = HospitalDonationReply();
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    if (json[db.requestId] != null)
      try {
        _id = int.parse(json[db.requestId]);
      } catch (_) {
        _id = json[db.requestId] as int;
      }
    _idRequester = json[db.userId];

    _bloodType = json[db.requestBloodType];
    if (json[db.requestPublishDate] != null)
      _publishDate = dateFormat.parse(json[db.requestPublishDate]).toLocal();
    _statusRequest = json[db.requestStatus];
    if (json[db.requestUnitsNumber] != null)
      _unitsNb = int.parse(json[db.requestUnitsNumber]);
    if (json[db.requestDonatedUnits] != null)
      _unitsDonated = int.parse(json[db.requestDonatedUnits]);
    _patientName = json[db.requestPatientName] == null
        ? null
        : json[db.requestPatientName].toString().isEmpty
            ? null
            : json[db.requestPatientName];
    _urgency = json[db.requestUrgency];
    _description = json[db.requestDescription] == null
        ? null
        : json[db.requestDescription].toString().isEmpty
            ? null
            : json[db.requestDescription];
    _patientVisibility =
        json[db.requestPatientNameVisibility] == "1" ? true : false;

    //hospital
    _hospital.idHospital = json[db.hospitalId];
    _hospital.hospitalAddress = json[db.hospitalAddress];
    _hospital.hospitalLatitude = double.parse(json[db.hospitalLatitude]);
    _hospital.hospitalLongitude = double.parse(json[db.hospitalLongitude]);
    _hospital.hospitalName = json[db.hospitalName];
    _hospital.hospitalPhone = json[db.hospitalPhoneNumber];

    //donation
    if (json[db.replyId] != null)
      _hospitalDonationReply.id = int.parse(json[db.replyId]);
    if (json[db.replyDate] != null)
      _hospitalDonationReply.dateReplyDonation =
          dateFormat.parse(json[db.replyDate]).toLocal();
    if (json[db.replyDateAnswer] != null)
      _hospitalDonationReply.dateAnswerDonation =
          dateFormat.parse(json[db.replyDateAnswer]).toLocal();
    _hospitalDonationReply.statusDonation =
        (json[db.replyStatus] == null ? '' : json[db.replyStatus] == null);
  }

  Map<String, dynamic> toJson() {
    DatabaseHandlerMysql db = DatabaseHandlerMysql();
    Map<String, dynamic> data = Map();
    data[db.hospitalId] = idHospital;
    data[db.userId] = _idRequester;
    data[db.requestBloodType] = bloodType;
    data[db.requestUnitsNumber] = unitsNb;
    data[db.requestPatientName] = patientName;
    data[db.requestUrgency] = urgency[0].toUpperCase() + urgency.substring(1);
    data[db.requestDescription] = description;
    data[db.requestDonatedUnits] = 0;
    data[db.requestPatientNameVisibility] = patientName != null ? 1 : 0;
    return data;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get idRequester => _idRequester;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get urgency => _urgency.toLowerCase();

  set urgency(String value) {
    _urgency = value;
  }

  String get patientName => _patientName;

  set patientName(String value) {
    _patientName = value;
  }

  int get unitsNb => _unitsNb;

  set unitsNb(int value) {
    _unitsNb = value;
  }

  String get statusRequest => _statusRequest.toLowerCase();

  set statusRequest(String value) {
    _statusRequest = value;
  }

  DateTime get publishDate => _publishDate;

  set publishDate(DateTime value) {
    _publishDate = value;
  }

  String get bloodType => _bloodType;

  set bloodType(String value) {
    _bloodType = value;
  }

  String get idHospital => _hospital.idHospital;

  set idHospital(String value) {
    _hospital.idHospital = value;
  }

  set idRequester(String value) {
    _idRequester = value;
  }

  String get hospitalAddress => _hospital.hospitalAddress;

  set hospitalAddress(String value) {
    _hospital.hospitalAddress = value;
  }

  String get hospitalPhone => _hospital.hospitalPhone;

  set hospitalPhone(String value) {
    _hospital.hospitalPhone = value;
  }

  String get hospitalName => _hospital.hospitalName;

  set hospitalName(String value) {
    _hospital.hospitalName = value;
  }

  double get hospitalLongitude => _hospital.hospitalLongitude;

  set hospitalLongitude(double value) {
    _hospital.hospitalLongitude = value;
  }

  double get hospitalLatitude => _hospital.hospitalLatitude;

  set hospitalLatitude(double value) {
    _hospital.hospitalLatitude = value;
  }

  String get statusDonation => _hospitalDonationReply.statusDonation == null
      ? null
      : _hospitalDonationReply.statusDonation.toLowerCase();

  set statusDonation(String value) {
    _hospitalDonationReply.statusDonation = value;
  }

  DateTime get dateReplyDonation => _hospitalDonationReply.dateReplyDonation;

  set dateReplyDonation(DateTime value) {
    _hospitalDonationReply.dateReplyDonation = value;
  }

  DateTime get dateAnswerDonation => _hospitalDonationReply.dateAnswerDonation;

  set dateAnswerDonation(DateTime value) {
    _hospitalDonationReply.dateAnswerDonation = value;
  }

  bool get patientVisibility => _patientVisibility;

  set patientVisibility(bool value) {
    _patientVisibility = value;
  }

  int get unitsDonated => _unitsDonated;

  set unitsDonated(int value) {
    _unitsDonated = value;
  }
}
