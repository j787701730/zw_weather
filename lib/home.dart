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

  Map weekday = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期日',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCitys();
    print('init');
  }

  DateTime date;

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
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                weatherData['HeWeather6'][0]['basic']['location'],
                                style: TextStyle(fontSize: 34),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                weatherData['HeWeather6'][0]['now']['cond_txt'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                weatherData['HeWeather6'][0]['now']['tmp'] + '℃',
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width / 3),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            child: Image.network(
                              'https://cdn.heweather.com/cond_icon/${weatherData['HeWeather6'][0]['now']['cond_code']}.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black12,
                          ),
//                          Container(
//                            height: 100,
//                            child: ListView(
//                              scrollDirection: Axis.horizontal,
//                              children: weatherData['HeWeather6'][0]['daily_forecast'].map<Widget>((item) {
//                                return (SizedBox(
//                                  width: MediaQuery.of(context).size.width / 2,
//                                  height: 100,
//                                  child: Text('${weekday[DateTime.parse(item['date']).weekday]}'),
//                                ));
//                              }).toList(),
//                            ),
//                          ),
                          Container(
                            height: 90,
                            child: ListView(
                              children: weatherData['HeWeather6'][0]['daily_forecast'].map<Widget>((item) {
                                return (Container(
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 3,
                                        child: Center(
                                          child: Text('${weekday[DateTime.parse(item['date']).weekday]}'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 3,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.network(
                                              'https://cdn.heweather.com/cond_icon/${item['cond_code_d']}.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(' - '),
                                            Image.network(
                                              'https://cdn.heweather.com/cond_icon/${item['cond_code_n']}.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 3,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(item['tmp_max']),
                                            Text('  '),
                                            Text(item['tmp_min']),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                              }).toList(),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black12,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '体感温度：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['fl'] + '℃')
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '风向360角度：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['wind_deg'])
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '风向：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['wind_dir'])
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '风力：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['wind_sc'])
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '风速：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['wind_spd'] + '公里/小时')
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '相对湿度：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['hum'] + '%')
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '降水量：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['pcpn'] + 'mm')
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '云量：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['cloud'])
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '大气压强：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['pres'] + '百帕')
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    '能见度：',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(weatherData['HeWeather6'][0]['now']['vis'] + '公里')
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black12,
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 6, top: 6),
                            child: Center(
                              child: Text(
                                '生活指数',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Column(
                            children: weatherData['HeWeather6'][0]['lifestyle'].map<Widget>((item) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('${lifeStyle[item['type']]}：${item['brf']}',style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    child: Text(item['txt']),
                                  ),
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
