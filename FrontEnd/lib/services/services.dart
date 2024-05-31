import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:smartpark/utils/constants.dart';

class Services{
  var headerJson = <String, String>{
     'Accept': '*/*',
    // 'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  headerAccessToken() async {
    String? accessToken = '';//await _storage.read(key: 'accessToken');
    return <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
  }

  Future<bool> verifyInternet() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  Future postHttp(String url, body, int headerAccess) async {
    var header = headerAccess == 0? 
      headerJson: 
      await headerAccessToken();

    final verifyInternetGoogle = await verifyInternet();
    if (verifyInternetGoogle == true) {
      try {
        final resp = await http.post(Uri.parse(url), headers: header, body: body);
        return resp;
      } on TimeoutException catch (e) {
        print(e);
        return Constants.checkServer;
      } on SocketException catch (e) {
        print(e);
        return Constants.checkServer;
      } catch (e) {
        print(e);
        return Constants.checkServer;
      }
    } else {
      return Constants.checkInternet;
    }
  }

  Future getHttp(String url, int headerAccess) async {
    var header = headerAccess == 0? 
      headerJson: 
      await headerAccessToken();
    final verifyInternetGoogle = await verifyInternet();
    if (verifyInternetGoogle == true) {
      try {
        final resp = await http.get(Uri.parse(url), headers: header);
        return resp;
      } on TimeoutException catch (e) {
        print(e);
        return Constants.checkServer;
      } on SocketException catch (e) {
        print(e);
        return Constants.checkServer;
      } catch (e) {
        print(e);
        return Constants.checkServer;
      }
    } else {
      return Constants.checkInternet;
    }
  }

  Future putHttp(String url, body, int headerAccess) async {
    var header = headerAccess == 0? 
      headerJson: 
      await headerAccessToken();
    final verifyInternetGoogle = await verifyInternet();
    if (verifyInternetGoogle == true) {
      try {
        final resp = await http.put(Uri.parse(url), headers: header, body: body);
        return resp;
      } on TimeoutException catch (e) {
        print(e);
        return Constants.checkServer;
      } on SocketException catch (e) {
        print(e);
        return Constants.checkServer;
      } catch (e) {
        print(e);
        return Constants.checkServer;
      }
    } else {
      return Constants.checkInternet;
    }
  }

  Future deleteHttp(String url, int headerAccess) async {
    var header = headerAccess == 0? 
      headerJson: 
      await headerAccessToken();
    final verifyInternetGoogle = await verifyInternet();
    if (verifyInternetGoogle == true) {
      try {
        final resp = await http.delete(Uri.parse(url), headers: header);
        return resp;
      } on TimeoutException catch (e) {
        print(e);
        return Constants.checkServer;
      } on SocketException catch (e) {
        print(e);
        return Constants.checkServer;
      } catch (e) {
        print(e);
        return Constants.checkServer;
      }
    } else {
      return Constants.checkInternet;
    }
  }

  Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      // throw Exception(AuthTokenExpire);
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      // throw Exception(AuthTokenExpire);
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    return utf8.decode(base64Url.decode(output));
  }
}