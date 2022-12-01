import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class StorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;





  Future<String>? uploadPic(XFile pic) async {
    print("---upload pic start---");
String lurl="";

        print("----------inside upload pic-----");
        try {
          Reference _reference = _storage
              .ref()
              .child("gabageUser"+"/"+DateTime.now().toString());

          await _reference
              .putData(
            await pic.readAsBytes(),
          )
              .whenComplete(() async {
            await _reference.getDownloadURL().then((value) {
              lurl=value;
              print(value);
            });
          });
          print("----------upload done-----");
          // await FireStoreService(uid: selectedPic.uploaderId)
          //     .createUploadPicRecord(selectedPic);
        } catch (e) {
          print("---error occured uploadpic---");
          print(e);
        }




    return lurl;
  }

//   Future<String> uploadThumbPic(Uint8List list) async {
//
// String picLink="";
//
//     var result = await FlutterImageCompress.compressWithList(
//       list,
//       minHeight: 131,
//       minWidth: 200,
//       quality: 96,
//     );
//
//     print("---upload pic start---");
//
//
//     print("----------inside upload pic-----");
//     try {
//
//       // print(lpic.toString());
//       Reference _reference = _storage
//           .ref()
//           .child(sellerId + "/" + DateTime.now().toString());
//
//       await _reference
//           .putData(
//           result
//       )
//           .whenComplete(() async {
//         await _reference.getDownloadURL().then((value) {
//
//           print(value);
//           picLink= value;
//         });
//       });
//       print("----------upload done-----");
//       // await FireStoreService(uid: selectedPic.uploaderId)
//       //     .createUploadPicRecord(selectedPic);
//     } catch (e) {
//       print("---error occured uploadpic---");
//       print(e);
//     }
//
// return picLink;
//
//   }
//

}