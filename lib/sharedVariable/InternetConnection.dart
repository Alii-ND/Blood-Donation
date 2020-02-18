import 'package:connectivity/connectivity.dart';

class  InternetConnection{
  InternetConnection();

  Future<bool> checkConn()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)
      return true;
    return false;
  }
}