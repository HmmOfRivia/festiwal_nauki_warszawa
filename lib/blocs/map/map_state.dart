part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialMapState extends MapState {}

class MapShowInfo extends MapState {
  final LatLng placePosition;
  final List<Marker> markers;
  MapShowInfo(this.placePosition, this.markers);
}

class MapNavigation extends MapState {
  final Position userPosition;
  final List<Position> cameraBounds;
  final Map<PolylineId, Polyline> polylines;
  MapNavigation(this.userPosition, this.cameraBounds, this.polylines);
}
