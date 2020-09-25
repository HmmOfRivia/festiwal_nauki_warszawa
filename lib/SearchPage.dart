import 'package:festiwal_nauki_warszawa/home_page/events_slider.dart';
import 'package:flutter/material.dart';
class SearchPage extends StatefulWidget{
  List eventData;
  SearchPage({this.eventData});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List filteredEventData = List();
  String selectedChoice;
  String selectedText;
  @override
  void initState() {
    filteredEventData = widget.eventData;
    selectedText = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _buidChipList(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "wyszukaj po frazie",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide( color: Color(0xFFD2006B))
                  )
                ),
                onChanged: (string) {
                  setState(() {
                    selectedText = string;
                    if(selectedChoice!=null){
                      filteredEventData = widget.eventData.where(
                              (e) => e.title.toLowerCase().contains(string.toLowerCase()) &&
                              e.domain.toLowerCase().contains(selectedChoice.toLowerCase())).toList();
                    }else {
                      filteredEventData = widget.eventData.where(
                              (e) => e.title.toLowerCase().contains(string.toLowerCase())).toList();
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: EventCards(filteredEventData)
            )

          ],
        ),
      )
    );
  }

  _buidChipList(){
    
    List<String> chipList = [
      "fizyczne",
      "matematyczne",
      "biologiczne",
      "humanistyczne",
    ];
    List<Widget> choices = List();

    chipList.forEach((i) { 
      choices.add(Container(
        padding: EdgeInsets.all(3),
        child: ChoiceChip(
          label: Text(i),
          backgroundColor: Colors.grey[200],
          selectedColor: Colors.black,
          selected: selectedChoice==i,
          onSelected: (selected) {
            setState(() {
              selectedChoice = i;
              filteredEventData = widget.eventData.where(
                      (e) => e.title.toLowerCase().contains(selectedText.toLowerCase()) &&
                      selectedChoice!=null && e.domain.toLowerCase().contains(selectedChoice.toLowerCase())).toList();            });
          },
        ),
      ));
    });

    return SingleChildScrollView(scrollDirection: Axis.horizontal ,child: Wrap(children: choices));
  }
}