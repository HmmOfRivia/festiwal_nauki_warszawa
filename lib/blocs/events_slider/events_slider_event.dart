part of 'events_slider_bloc.dart';

abstract class EventsSliderEvent extends Equatable {
  @override
  List<Object> get props => [props];
}

class SliderStarted extends EventsSliderEvent {}

class PageTapped extends EventsSliderEvent{
  final int index;
  PageTapped({this.index});
}