import 'package:festiwal_nauki_warszawa/detail_page/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCards extends StatelessWidget {
  final List eventsData;
  EventCards(this.eventsData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: GlowingOverscrollIndicator(
            color: Color(0xFFD2006B),
            axisDirection: AxisDirection.down,
            child: ListView.builder(
                itemCount: eventsData.length,
                itemBuilder: (context, int index) {
                  return _buildEventCard(
                      context,
                      eventsData[index].nid,
                      eventsData[index].title,
                      eventsData[index].host,
                      eventsData[index].street,
                      eventsData[index].date,
                      eventsData[index].domain);
                }),
          ),
        )
      ],
    ));
  }

  _buildEventCard(context, nid, title, host, street, date, domain) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(title),
                _buildAdressRow(host, street),
                Divider(thickness: 2),
                _buildDateRow(date),
                Divider(thickness: 2),
                _buildDomainRow(domain),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Color(0xFF21005e),
                child: Icon(Icons.forward, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(nid: nid)));
                },
              ))
        ],
      ),
    );
  }

  _buildDomainRow(domain) {
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Icon(
                Icons.turned_in_not,
                size: 28,
                color: Color(0xFFD2006B)
              )),
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(domain,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xB3000000)
                    )),
              ))
        ],
      ),
    );
  }

  _buildDateRow(date) {
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Icon(
                Icons.access_time,
                size: 28,
                color: Color(0xFFD2006B)
              )),
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(date,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,fontSize: 16,
                        color: Color(0xB3000000)
                    )),
              ))
        ],
      ),
    );
  }

  _buildAdressRow(host, street) {
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Icon(
                Icons.my_location,
                size: 28,
                color: Color(0xFFD2006B),
              )),
          Expanded(
              flex: 8,
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(host,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xB3000000))),
                    SizedBox(
                      height: 3,
                    ),
                    Text(street,
                        style:
                            GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xB3000000)))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  _buildTitle(title) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF21005e),
            Color(0xFFD2006B),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          )),
    );
  }
}
