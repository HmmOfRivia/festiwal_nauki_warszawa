part of 'detail_page_bloc.dart';

abstract class DetailPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailEventLoading extends DetailPageState{}

class DetailEventLoaded extends DetailPageState {
  final DetailEvent event;
  DetailEventLoaded({this.event});
}
