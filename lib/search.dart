import 'package:flutter/material.dart';
import 'util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';
  DateTime _lastPressedAt;
  List searchData = [
    {'basic': null}
  ];

  queryChange(val) {
//    print(val);
//    _lastPressedAt = DateTime.now();
//    print(DateTime.now().difference(_lastPressedAt));
//
//    if (DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
//      //两次点击间隔超过1秒则重新计时
////      _lastPressedAt = DateTime.now();
////      setState(() {
////        query = val;
////      });
//
//    } else {}
    setState(() {
      query = val;
    });
    getData();
  }

  getData() {
    if (query.isEmpty) {
      return;
    }
    ajax('https://search.heweather.net/find?location=$query&group=cn&', '', false, (data) {
      setState(() {
        searchData = data['HeWeather6'];
      });
    }, () {}, context);
  }

  _addCity(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('currCity', data);
    List citys = jsonDecode(preferences.get('usedCitys'));
    if (citys.isNotEmpty && citys.indexOf(data) >= 0) {
      citys.remove(data);
    }
    citys.insert(0, data);
    preferences.setString('usedCitys', jsonEncode(citys));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Container(
          child: TextField(
            decoration: InputDecoration(
              hintText: '搜索城市',
            ),
            onChanged: queryChange,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              getData();
            },
            icon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          )
        ],
        bottom: PreferredSize(
            child: Container(
          height: 1,
          color: Colors.black26,
        )),
      ),
      body: SafeArea(
        child: searchData[0]['basic'] == null
            ? Placeholder(
                color: Colors.transparent,
              )
            : ListView(
                children: searchData[0]['basic'].map<Widget>((item) {
                  return (FlatButton(
                    onPressed: () {
                      _addCity(item['location']);
                      Navigator.of(context).pop(item['location']);
                    },
                    child: Text(item['location']),
                  ));
                }).toList(),
              ),
      ),
    );
  }
}
