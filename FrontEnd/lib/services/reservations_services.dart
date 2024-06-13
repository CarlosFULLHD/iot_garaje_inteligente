import 'dart:convert';
import 'dart:developer';

import 'package:smartpark/models/reservation_model.dart';
import 'package:smartpark/services/services.dart';
import 'package:smartpark/utils/globals.dart';

class ReservationServices{
  final Services services = Services();
  Future<bool> addReservation(
    ReservationModel reservation
  )async{
    final url = '${Globals.url}/parkings/reservations';
    final response = await services.postHttp(url, jsonEncode(reservation.toJson()), 0);
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}