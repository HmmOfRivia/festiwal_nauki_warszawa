import 'package:festiwal_nauki_warszawa/blocs/detail_page/detail_page_bloc.dart';
import 'package:festiwal_nauki_warszawa/map_page/map_page.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_detail_page_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is DetailEventLoaded) {
                    return _buildDetailPageScreen(state.event, context);
                  }
                  return Container();
                },
              ),
            )
            )
        )
    );
  }

  Widget _buildDetailPageScreen(event, context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildInfoWindow2(event),
          SizedBox(
            height: 50,
          ),
          _buildDescriptionWidget(event),
        ],
      ),
    );
  }

  Widget _buildInfoWindow2(event) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Adres", Icons.location_on,
                event.thoroughfare + ', ' + event.postalcode),
            SizedBox(height: 10),
            _buildInfoRow("Data", Icons.calendar_today, event.date),
            SizedBox(height: 10),
            _buildInfoRow("Dodatkowe Informacje", Icons.info,
                event.additionalInfo.toString()),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton.extended(
                    icon: Icon(Icons.location_on),
                    label: Text('Mapa'),
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
                    label: Text('Zapisz się'),
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

  Widget _buildInfoWindow(event) {
    return Container(
        margin: EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFD2006B),
                  offset: Offset(4, 4),
                  blurRadius: 4,
                  spreadRadius: 1),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 4,
                  spreadRadius: 1)
            ]),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.map,
                    size: 30,
                    color: Color(0xFFD2006B),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    event.thoroughfare,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 30,
                    color: Color(0xFFD2006B),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    event.date,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.title,
                    size: 30,
                    color: Color(0xFFD2006B),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    event.type,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ));
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
          boxShadow: [
            BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
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
