import 'package:flutter/material.dart';
import 'home.dart';

//import 'search.dart';
import 'favorite.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: new TabBarView(controller: _tabController, children: <Widget>[
            MyHomePage(),
            Favorite(),
//            Search(),
          ]),
          bottomNavigationBar: Material(
            child: SafeArea(
                child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFd0d0d0),
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              height: 48,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black26,
                indicatorColor: Colors.transparent,
                labelStyle: TextStyle(fontSize: 12),
                // 下划线颜色
//              indicatorWeight: 3.0,
                tabs: <Tab>[
                  Tab(
                      child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.home), Text('首页')],
                    ),
                  )),
                  Tab(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Icon(Icons.star), Text('关注')],
                        )),
                  ),
//                  Tab(
//                    child: Container(
//                        width: MediaQuery.of(context).size.width / 2,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[Icon(Icons.search), Text('搜索')],
//                        )),
//                  ),
                ],
                controller: _tabController,
              ),
            )),
          ),
        ),
        onWillPop: () async {
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressedAt = DateTime.now();
            return false;
          }
          return true;
        });
  }
}
