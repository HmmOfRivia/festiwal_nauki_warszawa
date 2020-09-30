import 'package:festiwal_nauki_warszawa/blocs/detail_page/detail_page_bloc.dart';
import 'package:festiwal_nauki_warszawa/map_page/map_page.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_detail_page_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:festiwal_nauki_warszawa/utils/Strings.dart' as Strings;

class DetailPage extends StatefulWidget {
  DetailPage({this.nid});
  final String nid;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<DetailPageBloc>(
            create: (BuildContext context) => DetailPageBloc(
                detailEventRepository: DetailEventRepository(widget.nid))
              ..add(DetailPageStarted()),
            child: Scaffold(
                body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF21005e), Color(0xFFD2006B)])),
              child: BlocBuilder<DetailPageBloc, DetailPageState>(
                builder: (BuildContext context, state) {
                  if (state is DetailEventLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Color(0xFF21005e),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFD2006B))));
                  }
                  if (state is DetailEventLoaded) {
                    return _buildDetailPageScreen(state.event);
                  }
                  return Container();
                },
              ),
            ))));
  }

  Widget _buildDetailPageScreen(event) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildInfoWindow(event),
          SizedBox(
            height: 50,
          ),
          _buildDescriptionWidget(event),
        ],
      ),
    );
  }

  Widget _buildInfoWindow(event) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Strings.THOROUGHFARE, Icons.location_on,
                event.thoroughfare + ', ' + event.postalcode),
            SizedBox(height: 10),
            _buildInfoRow(Strings.DATE, Icons.calendar_today, event.date),
            SizedBox(height: 10),
            _buildInfoRow(Strings.ADDITIONAL_INFO, Icons.info,
                event.additionalInfo.toString()),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                    icon: Icon(Icons.location_on),
                    label: Text(Strings.MAP),
                    backgroundColor: Color(0xFF21005e),
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MapPage(event.thoroughfare)));
                    }),
                FloatingActionButton.extended(
                    icon: Icon(Icons.assignment),
                    label: Text(Strings.SIGN_UP),
                    backgroundColor: Color(0xFFD2006B),
                    heroTag: null,
                    onPressed: () {})
              ],
            )
          ],
        ));
  }

  Widget _buildInfoRow(String title, IconData icon, var event) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20)),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Flexible(
                child: Column(children: [
                  Container(
                    child: Text(
                      event,
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                ]),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionWidget(event) {
    AnimationController controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    Animation<Offset> offset =
        Tween<Offset>(end: Offset.zero, begin: Offset(0.0, 1.0))
            .animate(controller);
    controller.forward();
    return SlideTransition(
      position: offset,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
              child: Text(event.title,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserrat(fontSize: 24)),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    event.body,
                    style:
                        GoogleFonts.quicksand(fontSize: 19, color: Colors.grey),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
