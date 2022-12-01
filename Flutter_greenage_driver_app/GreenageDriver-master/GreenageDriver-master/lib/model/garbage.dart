import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Garbage {

  LatLng location;
  bool isCollected=false;
  bool isExcess;
  String id;
  String imgUrl;
  Timestamp time;

  Garbage({required this.location,required this.id ,required this.isExcess, required this.imgUrl,required this.time});

}