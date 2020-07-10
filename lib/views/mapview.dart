import 'package:chatup/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}


class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  Location _location = new Location();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            mapType: MapType.hybrid,
          ),
        ]));
    }

  void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
      _location.onLocationChanged.listen((l) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(l.latitude,l.longitude),zoom: 15),));
      });

  }
}
