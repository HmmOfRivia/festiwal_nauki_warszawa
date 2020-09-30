import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:festiwal_nauki_warszawa/utils/Strings.dart' as Strings;

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(InitialMapState());
  Geolocator geolocator = Geolocator();
  Position placePosition;
  List<Marker> markers = [];
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylineMap = {};

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is MapInitial) {
      try {
        placePosition = await _findCoordinates(event.thoroughfare);
        LatLng latLng = LatLng(placePosition.latitude, placePosition.longitude);
        markers.add(_buildMarker(latLng, BitmapDescriptor.defaultMarker));
        yield MapShowInfo(latLng, markers);
      } catch (e) {}
    }
    if (event is NavigationTap) {
      Position userPosition = await _getCurrentPosition();
      LatLng latLng = LatLng(userPosition.latitude, userPosition.longitude);
      markers.add(_buildMarker(latLng, BitmapDescriptor.defaultMarker));
      List cameraBounds = _calculateCameraBounds(userPosition, placePosition);
      await _createPolyline(userPosition, placePosition);
      yield MapNavigation(userPosition, cameraBounds, polylineMap);
    }
  }

  _createPolyline(Position userPosition, Position placePosition) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Strings.GOOGLE_API_KEY,
        PointLatLng(userPosition.latitude, userPosition.longitude),
        PointLatLng(placePosition.latitude, placePosition.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId('route');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xFF21005e),
      points: polylineCoordinates,
      width: 5,
    );

    polylineMap[id] = polyline;
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

  Marker _buildMarker(LatLng coordinates, BitmapDescriptor icon) {
    return Marker(
      markerId: MarkerId('$coordinates'),
      position: coordinates,
      icon: icon,
    );
  }

  Future<Position> _findCoordinates(String thoroughfare) async {
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
