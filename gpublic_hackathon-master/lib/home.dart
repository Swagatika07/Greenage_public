import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpublic/model/garbage.dart';
import 'package:gpublic/services/cloud_firestore.dart';
import 'package:gpublic/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  bool flag=false;
  bool isSelected=false;
  final ImagePicker imagePicker = ImagePicker();
  XFile ? selectedImage;
  var loc;

  String selectedImageString ="https://2ea.co.uk/wp-content/uploads/Media/emerging-economies-adding-to-the-garbage-pile.jpg";
  //todo remove dummy


  Future _initLocationService() async {
    var location = Location();



    try {
      var _serviceEnabled = await location.serviceEnabled();
    } on PlatformException catch (err) {
      print("Platform exception calling serviceEnabled(): $err");
      // _serviceEnabled = false;

      // location service is still not created

      _initLocationService(); // re-invoke himself every time the error is catch, so until the location service setup is complete
    }



    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    loc = await location.getLocation();
    print('inside location init');
    flag=true;
    setState(() {

    });
    print("${loc.latitude} ${loc.longitude}");
  }



  @override
  void initState() {
    super.initState();
    _initLocationService();


  }
  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService=FireStoreService();
    StorageService storageService=StorageService();
    return Scaffold(

      appBar: AppBar(
      title: Text('garbage collection'),
      ),
      body:isSelected ? SingleChildScrollView(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height:50),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
        Center(
          child: Container(
      child: Image.file(File(selectedImage!.path),fit: BoxFit.cover,),
      height:MediaQuery.of(context).size.height*0.5,
    ),
        ),
  ],
),

            //todo change to x file
            SizedBox(height: 60,),
            TextButton(onPressed: ()async{
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text('Processing...'),),
              );
              selectedImageString= await storageService.uploadPic(selectedImage!)!;
              await fireStoreService.addGarbageDoc(g: Garbage(img:selectedImageString, name:"dummy User", loc: loc, time:Timestamp.fromDate(DateTime.now())));
isSelected=false;
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text('request sent'),),
              );
setState(() {

});


            }, child:Text('request to collect garbage')),
            SizedBox(height: 20,),
            TextButton(onPressed: ()async{
              selectedImage = await imagePicker.pickImage(source:ImageSource.camera);
              // if (selectedImages!.isNotEmpty) {
              //   imageFileList!.addAll(selectedImages);
              // }
              print("imageSlected");
              isSelected=true;
              setState(() {


              });
            }, child:Text('retake')),

          ],

        ),
      )  : Center(child: FloatingActionButton(onPressed:() async{
        selectedImage = await imagePicker.pickImage(source:ImageSource.camera);

        print("imageSlected");
        isSelected=true;
        setState(() {


        });

      },child: Icon(Icons.camera),)),
    );
  }
}
