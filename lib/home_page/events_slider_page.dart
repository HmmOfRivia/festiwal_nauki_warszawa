import 'package:festiwal_nauki_warszawa/SearchPage.dart';
import 'package:festiwal_nauki_warszawa/blocs/authentication/authentication_bloc.dart';
import 'package:festiwal_nauki_warszawa/blocs/events_slider/events_slider_bloc.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_table_repository.dart';
import 'package:festiwal_nauki_warszawa/utils/User.dart';
import 'package:festiwal_nauki_warszawa/widgets/background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events_slider.dart';

class EventsSlider extends StatefulWidget {
  final User user;
  EventsSlider({this.user});

  @override
  _EventsSliderState createState() => _EventsSliderState();
}

class _EventsSliderState extends State<EventsSlider> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider<EventsSliderBloc>(
            create: (context) =>
                EventsSliderBloc(eventsTableRepository: EventsTableRepository())
                  ..add(SliderStarted()),
            child: EventsSliderTemplate()));
  }
}

class EventsSliderTemplate extends StatelessWidget {
  final int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFD2006B), Color(0xFF21005e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight))),
        elevation: 8,
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            margin: EdgeInsets.all(10),
            child: FittedBox(
              child: FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  backgroundColor: Color(0xFFD2006B),
                  label: Text('Twoje wydarzenia')),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<EventsSliderBloc, EventsSliderState>(
            builder: (context, state) {
              if (state is PageLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Color(0xFF21005e),
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Color(0xFFD2006B)),
                ));
              }
              if (state is MeetingsLoaded) {
                return EventCards(state.meetingsData);
              }
              if (state is SearchPageState) {
                return SearchPage(eventData: state.meetingsData);
              }
              return Container();
            },
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<EventsSliderBloc, EventsSliderState>(
        builder: (BuildContext context, EventsSliderState state) {
          return BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF21005e),
              unselectedItemColor: Color(0xFFD2006B),
              iconSize: 26,
              showUnselectedLabels: true,
              unselectedLabelStyle: TextStyle(
                color: Color(0xFFD2006B),
              ),
              currentIndex:
                  BlocProvider.of<EventsSliderBloc>(context).currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), title: Text("Spotkania")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.book), title: Text("Lekcje")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.rate_review), title: Text("Wykłady")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), title: Text("Wyszukaj"))
              ],
              onTap: (index) => BlocProvider.of<EventsSliderBloc>(context)
                  .add((PageTapped(index: index))));
        },
      ),
    );
  }
}
