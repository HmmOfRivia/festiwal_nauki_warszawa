part of 'events_slider_bloc.dart';

abstract class EventsSliderState extends Equatable {
  @override
  List<Object> get props => [];

}

class EventsSliderInitial extends EventsSliderState {}
class CurrentIndexChanged extends EventsSliderState{
  final int index;
  CurrentIndexChanged({this.index});
}
class PageLoading extends EventsSliderState{}
class MeetingsLoaded extends EventsSliderState {
  final List meetingsData;
  MeetingsLoaded({this.meetingsData});
}
class ExpoLoaded extends EventsSliderState{
  final List expoData;
  ExpoLoaded({this.expoData});
}

class LecturesLoaded extends EventsSliderState{
  final List lecturesData;
  LecturesLoaded({this.lecturesData});
}

class SearchPageState extends EventsSliderState{
  final List meetingsData;
  SearchPageState({this.meetingsData});
}