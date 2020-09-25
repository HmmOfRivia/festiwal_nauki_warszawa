part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MapInitial extends MapEvent{
  final String thoroughfare;
  MapInitial(this.thoroughfare);
}

class NavigationTap extends MapEvent{
}
