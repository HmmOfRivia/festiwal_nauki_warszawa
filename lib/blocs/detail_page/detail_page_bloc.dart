import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_detail_page_repository.dart';
import 'package:festiwal_nauki_warszawa/utils/DetailEvent.dart';

part 'detail_page_event.dart';
part 'detail_page_state.dart';

class DetailPageBloc extends Bloc<DetailPageEvent, DetailPageState> {
  DetailEventRepository _detailEventRepository;
  DetailPageBloc({DetailEventRepository detailEventRepository}) :
        _detailEventRepository = detailEventRepository, super(DetailEventLoading());

  @override
  Stream<DetailPageState> mapEventToState(
    DetailPageEvent event,
  ) async* {
    if(event is DetailPageStarted){
      DetailEvent event = await _getDetailEventData();
      yield DetailEventLoaded(event: event);
    }
  }

  Future _getDetailEventData() async {
    return await _detailEventRepository.getDetails();
  }
}
