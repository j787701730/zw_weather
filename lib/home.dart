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
  List daily_forecast = [];
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
    ajax('https://free-api.heweather.net/s6/weather?location=$location&', '', false, (data) {
      if (!mounted) return;
      if (data['HeWeather6'] != null && data['HeWeather6'][0] != null) {
        setState(() {
          weatherData = data;
          daily_forecast = data['HeWeather6'][0]['daily_forecast'].sublist(1);
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
                                style: TextStyle(fontSize: MediaQuery.of(context).size.width / 4),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.width / 4,
                            child: Image.asset(
                              'icons/${weatherData['HeWeather6'][0]['now']['cond_code']}.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: <Widget>[
//                                      data['HeWeather6'][0]['daily_forecast']
                                        Text(
                                          '${weekday[DateTime.parse(weatherData['HeWeather6'][0]['daily_forecast'][0]['date']).weekday]}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(' 今日')
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
//                                      data['HeWeather6'][0]['daily_forecast']
                                        Text(
                                          '${weatherData['HeWeather6'][0]['daily_forecast'][0]['tmp_max']}  ',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${weatherData['HeWeather6'][0]['daily_forecast'][0]['tmp_min']}',
                                          style: TextStyle(color: Colors.black54),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.black12,
                          ),
                          Container(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: weatherData['HeWeather6'][0]['hourly'].map<Widget>((item) {
                                return (SizedBox(
                                  width: 70,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 22,
                                        child: Center(
                                          child: Text('${DateTime.parse(item['time']).hour}时'),
                                        ),
                                      ),
                                      Container(
                                        height: 36,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                item['pop'] == '0' ? '' : '${item['pop']}%',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              Image.asset(
                                                'icons/${item['cond_code']}.png',
                                                width: 20,
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 22,
                                        child: Center(
                                          child: Text('${item['tmp']}'),
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
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: daily_forecast.map<Widget>((item) {
                                    return (Container(
                                      height: 30,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Text('${weekday[DateTime.parse(item['date']).weekday]}'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  'icons/${item['cond_code_d']}.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                Text(' - '),
                                                Image.asset(
                                                  'icons/${item['cond_code_n']}.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width / 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(item['tmp_max']),
                                                Text('  '),
                                                Text(item['tmp_min']),
                                                SizedBox(
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  }).toList(),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 4, left: 20, right: 20, bottom: 4),
                                  child: Text('今天：当前${weatherData['HeWeather6'][0]['now']['cond_txt']}。气温'
                                      '${weatherData['HeWeather6'][0]['now']['tmp']}℃；'
                                      '预计最高气温${weatherData['HeWeather6'][0]['daily_forecast'][0]['tmp_max']}℃，'
                                      '最低气温${weatherData['HeWeather6'][0]['daily_forecast'][0]['tmp_min']}℃。',),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 4),
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
                                      Text('${weatherData['HeWeather6'][0]['now']['wind_deg']}度')
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
                                      Text('${weatherData['HeWeather6'][0]['now']['wind_sc']}级')
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
                                  padding: EdgeInsets.only(bottom: 4),
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
                                  padding: EdgeInsets.only(bottom: 10, top: 6),
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
                                            Text(
                                              '${lifeStyle[item['type']]}：${item['brf']}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.only(top: 6, bottom: 10, left: 20, right: 20),
                                              child: Text(
                                                item['txt'],
                                                textAlign: TextAlign.justify,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(right: 20, top: 8, bottom: 8),
                                      child: Text(
                                        '数据来源于和风天气',
                                        style: TextStyle(color: Colors.black38,fontSize: 12),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
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
                          InkWell(
                            onTap: () {
                              getWeather();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Icon(Icons.refresh), Text('刷新')],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Icon(Icons.search), Text('搜索')],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
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
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[Icon(Icons.star), Text('关注')],
                                ),
                              ),
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
