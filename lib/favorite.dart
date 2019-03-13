import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List citysData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCitys();
  }

  _readCitys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List citys = jsonDecode(preferences.get('usedCitys'));
    if (!mounted) return;
    setState(() {
      citysData = citys;
    });
  }

  _addCityF(data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('currCity', data);
  }

  _delUsedCity(city) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    citysData.remove(city);
    setState(() {
      citysData = citysData;
    });
    preferences.setString('usedCitys', jsonEncode(citysData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: citysData.isEmpty
            ? Placeholder(
                color: Colors.transparent,
              )
            : ListView(
                children: citysData.map<Widget>((item) {
                  return (Slidable(
                    delegate: new SlidableDrawerDelegate(),
                    actionExtentRatio: 0.25,
                    child: new Container(
                      color: Colors.white,
                      child: new ListTile(
//                        leading: new CircleAvatar(
//                          backgroundColor: Colors.indigoAccent,
//                          child: new Text('3'),
//                          foregroundColor: Colors.white,
//                        ),
                        title: FlatButton(
                            onPressed: () {
                              _addCityF(item);
                              Navigator.of(context).pop(item);
                            },
                            child: new Text(item)),
//                        subtitle: new Text('SlidableDrawerDelegate'),
                      ),
                    ),
//                actions: <Widget>[
//                  new IconSlideAction(
//                    caption: 'Archive',
//                    color: Colors.blue,
//                    icon: Icons.archive,
////                        onTap: () => _showSnackBar('Archive'),
//                  ),
//                  new IconSlideAction(
//                    caption: 'Share',
//                    color: Colors.indigo,
//                    icon: Icons.share,
////                        onTap: () => _showSnackBar('Share'),
//                  ),
//                ],
                    secondaryActions: <Widget>[
//                  new IconSlideAction(
//                    caption: 'More',
//                    color: Colors.black45,
//                    icon: Icons.more_horiz,
////                        onTap: () => _showSnackBar('More'),
//                  ),
                      new IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _delUsedCity(item),
                      ),
                    ],
                  ));
                }).toList(),
              ),
      )),
    );
  }
}
