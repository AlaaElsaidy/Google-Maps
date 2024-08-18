import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({required this.id, required this.name, required this.latLng});
}
List<PlaceModel> places=[
  PlaceModel(id: 1, name: "مستشفى العجوز التخصصى", latLng: LatLng(30.097651023766183, 31.206122297497128)),
  PlaceModel(id: 2, name: "مستشفي أوسيم المركزي", latLng: LatLng(30.12372091505315, 31.139369301551387)),
  PlaceModel(id: 3, name: "مطار سفنكس الدولي", latLng: LatLng(30.112913155392643, 30.88631278643272)),

];