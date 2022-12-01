

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gdriver/model/garbage.dart';
import 'package:gdriver/model/stats.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class FireStoreService {
  final String ?uid;

  //sid is student id
  FireStoreService({this.uid});

  final CollectionReference garbageCollection =
  FirebaseFirestore.instance.collection('garbage');

  final DocumentReference statsDoc =
  FirebaseFirestore.instance.collection('stats').doc('statDoc');


  // DocumentSnapshot ?lastDocument;
  // int documentLimitPerFetch = 6;
  // bool hasMore = true;

  Future<List<Garbage>> getGrabage() async {
   List<Garbage> ? garbageList =List<Garbage>.empty(growable: true);

    try {
      QuerySnapshot querySnapshot;
      print('insie the get products INfo');

          querySnapshot = await garbageCollection.where("isCollected", isEqualTo: false).orderBy("time").get();


      print('hi1');
      print(querySnapshot.size);


      final allDta = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        GeoPoint temp=data['loc'];

        Garbage g=Garbage(location:LatLng(temp.latitude,temp.longitude), id:data['id'],
            isExcess: data['isExcess']==null ? false:data['isExcess']  , imgUrl: data['image'], time: data['time']);

garbageList.add(g);
      }
      ).toList();
      print('insie the get products INfo2');
      print(garbageList.length);
    } catch (e) {
      print("error in getPRoduct");
      print(e.toString());
    }

    //
    // print(products.toString());
    return garbageList;
  }

Future<Stats> getStats() async{
try {
  final doc = await FirebaseFirestore.instance.collection('stats').doc(
      'statDoc').get();
  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
  print(data['totalCollected']);
  return Stats(tcExcess: data['tcExcess'],
      tCollected: data['totalCollected'],
      tcRecycle: data['tcRecycle'],
      tRequested: data['totalRequest']);

}catch(e){

  print("error inside get stats");
  print(e.toString());
  return Stats(tcExcess: 0, tCollected: 0, tcRecycle: 0, tRequested: 0);
}
}

  Future<void> updateExcess(String id) async{
    try {
      print('inside update marker');
      print(id);
      final result = await garbageCollection.doc(id).update({

        "isExcess":true
      });

      final result2= await statsDoc.update({

        'tcExcess':FieldValue.increment(1)
      });

    }catch(e){

      print("error inside update excess");
      print(e.toString());

    }
  }

  Future<void> updateCollected(String id) async{
    try {
      final result = await garbageCollection.doc(id).update({

        "isCollected":true
      });

      final result2= await statsDoc.update({

        'totalCollected':FieldValue.increment(1)
      });

    }catch(e){

      print("error inside update excess");
      print(e.toString());

    }
  }

}


