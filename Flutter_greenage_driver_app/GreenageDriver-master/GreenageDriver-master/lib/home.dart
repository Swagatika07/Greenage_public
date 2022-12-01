import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdriver/model/garbage.dart';
import 'package:gdriver/model/stats.dart';
import 'package:gdriver/services/cloud_fireStore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool flag=false;
  LatLng loc=LatLng(0.0,0.0);





  Future _initLocationService() async {
    var location = Location();


    try {
      var _serviceEnabled = await location.serviceEnabled();
    } on PlatformException catch (err) {
      print("Platform exception calling serviceEnabled(): $err");
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

    var temp = await location.getLocation();
    loc=LatLng(temp.latitude!,temp.longitude!);
    print('inside location init');
    flag=true;
    GoogleMapController gc=await _mapConroller.future;

    gc.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target:loc,zoom:15.0 )
    ));
    setState(() async{


    });
    print("${loc.latitude} ${loc.longitude}");
  }
  @override
  void initState() {
    super.initState();
    _initLocationService();
getStats();

  }
  Completer<GoogleMapController> _mapConroller = Completer();
  static  final LatLng _kMapCenter =
  LatLng(19.018255973653343, 72.84793849278007);

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a))*1000;
  }

 final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  List<Marker> _markers = <Marker>[];
  List<Marker> updatedMarkers =[];
  // List<Markers> markers; //This the list of markers is the old set of markers that were used in the onMapCreated function

  void upDateMarkers() {
        MarkerUpdates.from(
              Set<Marker>.from(_markers), Set<Marker>.from(updatedMarkers));
          _markers = [];
          _markers = updatedMarkers;
          print('updated marker ');
          print(updatedMarkers.length);
    setState(() {
    });
  }






 List<String> modes=['All','Excess','Normal'];
 String currentMode='Normal';
num totalGarbage=0;
num totalCollcetd=0;
  List<Garbage> glist=[];
  List<String> glistCollected=[];
  List<String> glistExcess=[];



void getStats2() async{
  FireStoreService fireStoreService=FireStoreService();
Stats st= await fireStoreService.getStats();
totalGarbage=st.tRequested;
totalCollcetd=st.tCollected;

glist =await fireStoreService.getGrabage();
  final Uint8List markerIcon = await getBytesFromAsset("assets/images/waste-bin.png");
  final Uint8List markerIcon2 = await getBytesFromAsset("assets/images/garbage-truck.png");
  updatedMarkers=[];
  glist.forEach((gb) async {

    if(currentMode=='Excess')
    {
      if(gb.isExcess)
        updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
            icon: BitmapDescriptor.fromBytes(markerIcon2),
            position: gb.location));
    }else if(currentMode=='Normal')
    {
      if(!gb.isExcess)
        updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: gb.location));

    }else {
      gb.isExcess ? updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
          icon: BitmapDescriptor.fromBytes(markerIcon2),
          position: gb.location)) : updatedMarkers.add(
          Marker(markerId: MarkerId(gb.id),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              position: gb.location));
    }
  });

print(glist!.length);
upDateMarkers();
setState(() {
  print("inside stats 2");

});
}
  void getStats() async{
    FireStoreService fireStoreService=FireStoreService();
    Stats st= await fireStoreService.getStats();
    totalGarbage=st.tRequested;
    totalCollcetd=st.tCollected;

    glist =await fireStoreService.getGrabage();

    print(glist!.length);
    setState(() {

    });
  }
  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 30
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  int tempTotal=0;

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService =FireStoreService();
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;


    return Scaffold(

// body: Container(child:Image.asset("assets/images/img.png")),

      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          StreamBuilder(
              stream:FirebaseFirestore.instance.collection('stats').doc('statDoc').snapshots(),
              initialData: {'totalCollected':0,'totalRequest':0},
              builder:(context,snapshot)
    {

    var data = snapshot.data! as DocumentSnapshot;
      // var i= snapshot.data['totalCollected'];
      // var j=data['totalCollected'];
      print('snapshot dats ...');

      if(tempTotal!=data['totalRequest'])
        getStats2();

      // print(tempTotal);
    tempTotal=data['totalRequest'];


      // print(snapshot.data!);
      // print();

      return Text("Total collected : ${data['totalCollected']}/${data['totalRequest'] }",style: TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
      ),);
    }
          ),

          DropdownButton(
          value: currentMode, items:modes.map((String e) {
            return DropdownMenuItem(child:
            Text(e),
            value: e,);

          }).toList(), onChanged:(String ?val) async{

            final Uint8List markerIcon = await getBytesFromAsset("assets/images/waste-bin.png");
            final Uint8List markerIcon2 = await getBytesFromAsset("assets/images/garbage-truck.png");
            updatedMarkers=[];
            glist.forEach((gb) async {

              if(val=='Excess')
              {
                if(gb.isExcess)
                  updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
                      icon: BitmapDescriptor.fromBytes(markerIcon2),
                      position: gb.location));
              }else if(val=='Normal')
              {
                if(!gb.isExcess)
                  updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
                      icon: BitmapDescriptor.fromBytes(markerIcon),
                      position: gb.location));

              }else {
                gb.isExcess ? updatedMarkers.add(Marker(markerId: MarkerId(gb.id),
                    icon: BitmapDescriptor.fromBytes(markerIcon2),
                    position: gb.location)) : updatedMarkers.add(
                    Marker(markerId: MarkerId(gb.id),
                        icon: BitmapDescriptor.fromBytes(markerIcon),
                        position: gb.location));
              }

              currentMode=val!;
              upDateMarkers();
              setState(() {

              });


            });


          }),


          Container(
            height: height*0.6,
            width: width*0.9,

            child: GoogleMap(

              initialCameraPosition: _kInitialPosition,

              compassEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers),

              onMapCreated: (GoogleMapController controller) async{
    _mapConroller.complete(controller);
    
            getStats2();


             setState(() {
               print(_markers.length);
               print("inside add markers");

             });
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target:loc,zoom: 15)
                ));
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [


              TextButton(onPressed: () async{

                var location = Location();
                var temp = await location.getLocation();
                loc=LatLng(temp.latitude!,temp.longitude!);
                print('inside location init');

                _markers.forEach((m) {
                  double dis=calculateDistance(loc.latitude,loc.longitude,m.position.latitude,m.position.longitude);
                  if(dis<=10.0)
                    glistCollected.add(m.markerId.value);
                });

glistCollected.forEach((id) async{
  await fireStoreService.updateCollected(id);
});
              var snackBar;
if(glistCollected.isEmpty)
 snackBar = SnackBar(
    content: Text('No garbage near by'),
  );
else
snackBar = SnackBar(
                  content: Text('Garbage collected'),
                );
                getStats2();


                glistCollected=[];
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // fireStoreService.getGrabage();
              }, child:Text('Collect')),
              TextButton(onPressed: ()async{
                var location = Location();
                var temp = await location.getLocation();
                loc=LatLng(temp.latitude!,temp.longitude!);
                print('inside location init');

                _markers.forEach((m) {
                  double dis=calculateDistance(loc.latitude,loc.longitude,m.position.latitude,m.position.longitude);
                  print(dis);
                  if(dis<=10.0)
                    glistCollected.add(m.markerId.value);
                });

                glistCollected.forEach((id) async{
                  await fireStoreService.updateExcess(id);
                });


                var snackBar;
                if(glistCollected.isEmpty)
                  snackBar = SnackBar(
                    content: Text('No garbage near by'),
                  );
                else
                  snackBar = SnackBar(
                    content: Text('Garbage statusUpdated'),
                  );


                glistCollected=[];
                ScaffoldMessenger.of(context).showSnackBar(snackBar);




              }, child:Text('Excess'))

            ],
          ),
        ],
      ),

    );
  }
}
