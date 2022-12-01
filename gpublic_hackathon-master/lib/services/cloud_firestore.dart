import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpublic/model/garbage.dart';



class FireStoreService {
  final String ?uid;


  FireStoreService({this.uid});
  // //
  // final CollectionReference userCollection =
  // FirebaseFirestore.instance.collection('seller');

  final CollectionReference gCollection =
  FirebaseFirestore.instance.collection('garbage');


  Future addGarbageDoc({required Garbage g}) async {
    print('insie the addProductDoc');
    // print(uid);

    try {
      return await gCollection.add(
        {
          'image':g.img,
          'time':g.time,
          'loc':GeoPoint(g.loc.latitude!,g.loc.longitude!),
          'name':g.name,
          'isCollected':g.isCollected,


        }
      ).then((value) async {
        await gCollection.doc(value.id).update(
            {"id": value.id.toString()});
        print(value.id.toString());
      });
    } catch (e) {
      print("error in garbageUpdate");
      print(e.toString());
    }


  }




}



