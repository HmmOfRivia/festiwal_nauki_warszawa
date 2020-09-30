import 'package:festiwal_nauki_warszawa/home_page/events_slider.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List eventData;
  SearchPage({this.eventData});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _filteredEventData = List();
  String _selectedChoice;
  String _selectedText = '';

  @override
  void initState() {
    _filteredEventData = widget.eventData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: [
              _buildChipList(),
              _buildSearchField(),
              Expanded(child: EventCards(_filteredEventData))
           ],
        ),
    ));
  }

  _buildSearchField(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
            labelText: "wyszukaj po frazie",
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD2006B)))),
        onChanged: (string) {
          setState(() {
            _selectedText = string;
            if (_selectedChoice != null) {
              _filteredEventData = widget.eventData.where((e) =>
              e.title.toLowerCase().contains(string.toLowerCase()) &&
                  e.domain.toLowerCase().contains(_selectedChoice.toLowerCase())).toList();
            } else {
              _filteredEventData = widget.eventData.where((e) =>
                  e.title.toLowerCase().contains(string.toLowerCase())).toList();
            }
          });
        },
      ),
    );
  }

  _buildChipList() {
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
          labelStyle: TextStyle(
            color: _selectedChoice == i ? Colors.white: Colors.black
          ),
          backgroundColor: Colors.grey[200],
          selectedColor: Color(0xFFD2006B),
          selected: _selectedChoice == i,
          onSelected: (selected) {
            setState(() {
              _selectedChoice = i;
              _filteredEventData = widget.eventData.where((e) =>
                e.title.toLowerCase().contains(_selectedText.toLowerCase()) &&
                      _selectedChoice != null &&
                      e.domain.toLowerCase().contains(_selectedChoice.toLowerCase())).toList();
            });
          },
        ),
      ));
    });

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: Wrap(children: choices));
  }
}
