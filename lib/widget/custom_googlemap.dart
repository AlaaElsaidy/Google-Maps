import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps/models/placeModel.dart';
import 'package:google_maps/utils/location-service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late LocationService locationService;

  @override
  void initState() {
    // initMarkers();
    // initPolyLines();
    locationService=LocationService();

    initialCameraPosition = CameraPosition(
        target: LatLng(30.05708555784763, 31.233783628745364), zoom: 10);
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GoogleMap(
            polylines: polyLines,
            zoomControlsEnabled: false,
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              googleMapController = controller;
              setLocation();
              updateStyle();

            },
            // cameraTargetBounds: CameraTargetBounds(LatLngBounds(southwest: LatLng(30.028257874947304, 31.22190046941553), northeast: LatLng(30.098659250758395, 31.289416473362444))),
            initialCameraPosition: initialCameraPosition),
        ElevatedButton(
            onPressed: () {
              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  const CameraPosition(
                      target: LatLng(31.31212763125657, 29.900449881500407),
                      zoom: 12)));
            },
            child: Text("change location"))
      ],
    );
  }
////// update style ////////
  void updateStyle() async {
    var newStyle = await DefaultAssetBundle.of(context)
        .loadString("assets/googleMap_style/dark_style.json");
    googleMapController.setMapStyle(newStyle);
  }

  Future<Uint8List> getImageFromRawData(String imagePath,double height,double width)async{
    var imageData=await rootBundle.load(imagePath);
    var imageCodic=await ui.instantiateImageCodec(
      targetHeight: height.round(),
        targetWidth: width.round(),
        imageData.buffer.asUint8List());
    var imageFrame = await imageCodic.getNextFrame();//
    var imageByteData=await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);

    return imageByteData!.buffer.asUint8List();


  }

  // void initMarkers() async {
  //   // var marker=const Marker(markerId: MarkerId("1"),position:LatLng(30.05708555784763, 31.233783628745364) );
  //   // markers.add(marker);
  //   var customMarkerIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(size: Size(50, 50)), "assets/images/marker.png");
  //   // var customMarkerIcon=BitmapDescriptor.fromBytes(await getImageFromRawData("assets/images/marker.png", 100,100));
  //   var myMarkers = places
  //       .map((placeModel) => Marker(
  //           icon: customMarkerIcon,
  //           position: placeModel.latLng,
  //           infoWindow: InfoWindow(title: placeModel.name),
  //           markerId: MarkerId(placeModel.id.toString())))
  //       .toSet();
  //   markers.addAll(myMarkers);
  //   setState(() {});
  // }

  // void initPolyLines() {
  //   var polyLine =  Polyline(
  //     zIndex: 2 ,
  //       width: 10,
  //       geodesic: true,  //curve
  //       color: Colors.red,
  //       startCap: Cap.roundCap,
  //       patterns:[PatternItem.dot,PatternItem.dash(50)] ,
  //       polylineId: PolylineId("1"),
  //       points: [
  //         LatLng(30.12049024651684, 30.889419642103622),
  //         LatLng(29.94039805309396, 30.917444262849706),
  //         LatLng(30.061401030947923, 31.331695542846465),
  //         LatLng(30.297086040165624, 31.771017839642763)
  //       ]);
  //   var polyLine2 = const Polyline(
  //       width: 5,
  //       color: Colors.blue,
  //       startCap: Cap.roundCap,
  //       points: [
  //         LatLng(30.21973490652899, 31.719364092581287),
  //         LatLng(30.53928682677589, 31.691742529868687),
  //       ],
  //       polylineId: PolylineId("2"));
  //   polyLines.add(polyLine);
  //   polyLines.add(polyLine2);
  // }


  void setLocation() async{
    await locationService.checkAndRequestLocationService();
    var hasPermission= await locationService.checkAndRequestLocationPermission();
    if(hasPermission){
      locationService.getRealLocation((locationData) {
        updateCameraPosition(locationData);
        setMyLocationMarker(locationData);
      });
    }
  }

  void updateCameraPosition(LocationData locationData) {
     // var cameraPosition=CameraPosition(target: LatLng(locationData.latitude!, locationData.longitude!),zoom: 16);
    googleMapController.animateCamera(CameraUpdate.newLatLng(LatLng(locationData.latitude!, locationData.longitude!)));
  }

  void setMyLocationMarker(LocationData locationData) {
    var locationMarker=Marker(markerId: MarkerId("tracker marker"),position: LatLng(locationData.latitude!, locationData.longitude!));
    markers.add(locationMarker);
    setState(() {

    });
  }
}
