import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitialMapState());
  Geolocator geolocator = Geolocator();
  Position placePosition;
  List<Marker> markers = [];
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoords = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is MapInitial) {
      try {
        placePosition = await findCoords(event.thoroughfare);
        LatLng latLng = LatLng(placePosition.latitude, placePosition.longitude);
        markers.add(buildMarker(latLng, BitmapDescriptor.defaultMarker));
        yield MapShowInfo(latLng, markers);
      } catch (e) {}
    }
    if (event is NavigationTap) {
      Position userPosition = await _getCurrentPosition();
      LatLng latLng = LatLng(userPosition.latitude, userPosition.longitude);
      markers.add(buildMarker(latLng, BitmapDescriptor.defaultMarker));
      List cameraBounds = _calculateCameraBounds(userPosition, placePosition);
      await _createPolylines(userPosition, placePosition);
      yield MapNavigation(userPosition, cameraBounds, polylines);
    }
  }

  _createPolylines(Position userPosition, Position placePosition) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBwvapxyHvVcWErtmF_JsJN_dOn4UA36wo",
        PointLatLng(userPosition.latitude, userPosition.longitude),
        PointLatLng(placePosition.latitude, placePosition.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId('route');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoords,
      width: 5,
    );

    polylines[id] = polyline;
  }

  _calculateCameraBounds(Position userPosition, Position placePosition) {
    Position southWest;
    Position northEast;
    if (userPosition.latitude <= placePosition.latitude) {
      if (userPosition.longitude >= placePosition.longitude) {
        northEast = Position(
            latitude: placePosition.latitude,
            longitude: userPosition.longitude);
        southWest = Position(
            latitude: userPosition.latitude,
            longitude: placePosition.longitude);
      } else {
        northEast = placePosition;
        southWest = userPosition;
      }
    } else {
      if (placePosition.longitude > userPosition.longitude) {
        northEast = Position(
            latitude: userPosition.latitude,
            longitude: placePosition.longitude);
        southWest = Position(
            latitude: placePosition.latitude,
            longitude: userPosition.longitude);
      } else {
        northEast = userPosition;
        southWest = placePosition;
      }
    }
    return [southWest, northEast];
  }

  Marker buildMarker(LatLng coords, icon) {
    Marker marker = Marker(
      markerId: MarkerId('$coords'),
      position: coords,
      icon: icon,
    );
    return marker;
  }

  Future findCoords(thoroughfare) async {
    List<Placemark> placemark =
        await geolocator.placemarkFromAddress(thoroughfare);
    Position position = placemark[0].position;
    return position;
  }

  Future<Position> _getCurrentPosition() async {
    return await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
