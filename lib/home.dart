import 'package:flutter/material.dart';
import 'util/util.dart';
import 'util/pageLoading.dart';
import 'search.dart';
import 'favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  @protected
  bool get wantKeepAlive => true;

  String location = '福州';

  Map weatherData = {};
  Map lifeStyle = {
    'comf': '舒适度指数',
    'cw': '洗车指数',
    'drsg': '穿衣指数',
    'flu': '感冒指数',
    'sport': '运动指数',
    'trav': '旅游指数',
    'uv': '紫外线指数',
    'air': '空气污染扩散条件指数',
    'ac': '空调开启指数',
    'ag': '过敏指数',
    'gl': '太阳镜指数',
    'mu': '化妆指数',
    'airc': '晾晒指数',
    'ptfc': '交通指数',
    'fsh': '钓鱼指数',
    'spi': '防晒指数'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCitys();
    print('init');
  }

  _readCitys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currCity = preferences.get('currCity');
    String citys = preferences.get('usedCitys');
    if (citys == null) {
      preferences.setString('usedCitys', jsonEncode([]));
    }
    if (!mounted) return;
    if (currCity != null) {
      setState(() {
        location = currCity;
      });
    }
    getWeather();
  }

  getWeather() {
    setState(() {
      weatherData = {};
    });
    print('ajax');
    ajax('https://free-api.heweather.net/s6/weather?location=$location&', '', false, (data) {
      if (!mounted) return;
      print(data);

      if (data['HeWeather6'] != null && data['HeWeather6'][0] != null) {
        setState(() {
          weatherData = data;
        });
      }
    }, (data) {}, context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
          child: weatherData.isEmpty
              ? PageLoading()
              : Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 50 - MediaQuery.of(context).padding.top,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Text(weatherData['HeWeather6'][0]['basic']['location']),
                          ),
                          Container(
                            child: Text(weatherData['HeWeather6'][0]['now']['tmp'] + '℃'),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              'https://cdn.heweather.com/cond_icon/${weatherData['HeWeather6'][0]['now']['cond_code']}.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            child: Text(weatherData['HeWeather6'][0]['now']['cond_txt']),
                          ),
                          Container(
                            child: Text('体感温度' + weatherData['HeWeather6'][0]['now']['fl'] + '℃'),
                          ),
                          Container(
                            child: Text('风向360角度' + weatherData['HeWeather6'][0]['now']['wind_deg']),
                          ),
                          Container(
                            child: Text('风向' + weatherData['HeWeather6'][0]['now']['wind_dir']),
                          ),
                          Container(
                            child: Text('风力' + weatherData['HeWeather6'][0]['now']['wind_sc']),
                          ),
                          Container(
                            child: Text('风速' + weatherData['HeWeather6'][0]['now']['wind_spd'] + '公里/小时'),
                          ),
                          Container(
                            child: Text('相对湿度' + weatherData['HeWeather6'][0]['now']['hum'] + '%'),
                          ),
                          Container(
                            child: Text('降水量' + weatherData['HeWeather6'][0]['now']['pcpn'] + 'mm'),
                          ),
                          Container(
                            child: Text('云量' + weatherData['HeWeather6'][0]['now']['cloud']),
                          ),
                          Container(
                            child: Text(
                              '生活指数',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: weatherData['HeWeather6'][0]['lifestyle'].map<Widget>((item) {
                              return Wrap(
                                children: <Widget>[
                                  Text(lifeStyle[item['type']]),
                                  Text(': '),
                                  Text(item['brf']),
                                  Text(item['txt']),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Colors.black54, width: 1),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(
                              child: FlatButton(
                                  onPressed: () {
                                    getWeather();
                                  },
                                  child: Text('刷新')),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new Search();
                                    })).then((res) {
                                      if (res != null) {
                                        setState(() {
                                          location = res;
                                          getWeather();
                                        });
                                      }
                                    });
                                  },
                                  child: Text('搜索')),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Center(
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
                                      return new Favorite();
                                    })).then((res) {
                                      if (res != null) {
                                        setState(() {
                                          location = res;
                                          getWeather();
                                        });
                                      }
                                    });
                                  },
                                  child: Text('关注')),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}
