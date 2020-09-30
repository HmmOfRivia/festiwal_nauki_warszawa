import 'package:festiwal_nauki_warszawa/blocs/map/map_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String thoroughfare;
  MapPage(this.thoroughfare);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CameraPosition cameraPosition = CameraPosition(target: LatLng(0.0,0.0));
  GoogleMapController mapController;
  List<Marker> markers;
  Map<PolylineId, Polyline> polylines;
  double _widgetHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<MapBloc>(
            create: (BuildContext context) =>
                MapBloc()..add(MapInitial(widget.thoroughfare)),
            child: BlocListener<MapBloc, MapState>(
                listener: (BuildContext context, state) {
                  if(state is MapShowInfo){
                    setState(() {
                      markers = state.markers;
                    });
                    mapController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: state.placePosition, zoom: 18)));
                  }
                  if(state is MapNavigation){
                    setState(() {
                      _widgetHeight = 200;
                      polylines = state.polylines;
                    });
                    mapController.animateCamera(CameraUpdate.newLatLngBounds(LatLngBounds(
                      southwest: LatLng(
                        state.cameraBounds[0].latitude,
                        state.cameraBounds[0].longitude
                      ),
                      northeast: LatLng(
                          state.cameraBounds[1].latitude,
                          state.cameraBounds[1].longitude
                      ),
                    ), 100));
                  }
            },
                child: Stack(
                  children: [
                    buildGoogleMap(markers, cameraPosition),
                    BlocBuilder<MapBloc, MapState>(
                      builder: (context, state){
                        return buildPlaceLabel(context);
                      },
                    )
                  ],
                )
            )));
  }

  Widget buildPlaceLabel(context){
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: _widgetHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),

                ),
              ),
              SizedBox(width: 20,),
              FloatingActionButton.extended(
                backgroundColor: Color(0xFF21005e),
                icon: Icon(Icons.navigation),
                label: Text('Nawiguj'),
                onPressed: () => BlocProvider.of<MapBloc>(context)..add(NavigationTap()),
              )
            ],
          ),
        ));
  }

  Widget buildGoogleMap(markers, position) {
    return Container(
      child: GoogleMap(
        markers: markers != null ? Set<Marker>.from(markers) : null,
        polylines: polylines != null ? Set<Polyline>.of(polylines.values) : null,
        myLocationEnabled: true,
        initialCameraPosition: position,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
