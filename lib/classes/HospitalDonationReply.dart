class HospitalDonationReply{
  HospitalDonationReply();

  int _id;
  String _statusDonation;
  DateTime _dateAnswerDonation;
  DateTime _dateReplyDonation;

  String get statusDonation => _statusDonation;

  set statusDonation(String value) {
    _statusDonation = value;
  }

  DateTime get dateAnswerDonation => _dateAnswerDonation;

  DateTime get dateReplyDonation => _dateReplyDonation;

  set dateReplyDonation(DateTime value) {
    _dateReplyDonation = value;
  }

  set dateAnswerDonation(DateTime value) {
    _dateAnswerDonation = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}