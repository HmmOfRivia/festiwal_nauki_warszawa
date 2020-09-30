import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_table_repository.dart';
import 'package:festiwal_nauki_warszawa/utils/Event.dart';
import 'package:festiwal_nauki_warszawa/utils/Strings.dart' as Strings;

part 'events_slider_event.dart';
part 'events_slider_state.dart';

class EventsSliderBloc extends Bloc<EventsSliderEvent, EventsSliderState> {
  EventsTableRepository _eventsTableRepository;
  EventsSliderBloc({EventsTableRepository eventsTableRepository})
      : _eventsTableRepository = eventsTableRepository,
        super(EventsSliderInitial());
  int currentIndex = 0;

  @override
  Stream<EventsSliderState> mapEventToState(
    EventsSliderEvent event,
  ) async* {
    if (event is SliderStarted) {
      this.add(PageTapped(index: this.currentIndex));
    }
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(index: this.currentIndex);
      yield PageLoading();
      if (currentIndex == 0) {
        List data = await _getMeetingsData(currentIndex);
        yield MeetingsLoaded(meetingsData: data);
      }
      if (currentIndex == 1) {
        List data = await _getExpoData(currentIndex);
        yield ExpoLoaded(expoData: data);
      }
      if (currentIndex == 2) {
        List data = await _getLecturesData(currentIndex);
        yield LecturesLoaded(lecturesData: data);
      }

      if (currentIndex == 3) {
        List data = await _getMeetingsData(currentIndex);
        yield SearchPageState(meetingsData: data);
      }
    }
  }

  Future<List<Event>> _getMeetingsData(currentIndex) async {
    List eventsData = _eventsTableRepository.meetingsList;
    if (eventsData.isEmpty) {
      await _eventsTableRepository.getEvents(
          url: Strings.API_MEETINGS,
          listReturned: currentIndex);
      eventsData = _eventsTableRepository.meetingsList;
    }
    return eventsData;
  }

  Future<List<Event>> _getExpoData(currentIndex) async {
    List eventsData = _eventsTableRepository.expoList;
    if (eventsData.isEmpty) {
      await _eventsTableRepository.getEvents(
          url: Strings.API_EXPO,
          listReturned: currentIndex);
      eventsData = _eventsTableRepository.expoList;
    }
    return eventsData;
  }

  Future<List<Event>> _getLecturesData(currentIndex) async {
    List eventsData = _eventsTableRepository.lecturesList;
    if (eventsData.isEmpty) {
      await _eventsTableRepository.getEvents(
          url: Strings.API_LECTURES,
          listReturned: currentIndex);
      eventsData = _eventsTableRepository.lecturesList;
    }
    return eventsData;
  }
}
