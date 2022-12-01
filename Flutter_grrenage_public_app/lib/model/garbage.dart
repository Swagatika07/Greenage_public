import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Garbage{
  String img;
  String name;
  LocationData loc;
  Timestamp time;
  bool isCollected;

  Garbage({required this.img,required this.name,required this.loc,required this.time,this.isCollected=false});



}