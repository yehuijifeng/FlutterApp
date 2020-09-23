import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

import 'bean/Posts.dart';

//异步任务
void main() {
  debugPaintSizeEnabled = false; //开启断点调试模式
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '异步任务',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _MyHome(),
    );
  }
}

class _MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyState();
  }
}

class _MyState extends State<_MyHome> {
  List<dynamic> widgets = []; //请求的数据
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> testJson=Map();
    testJson["userId"]=0;
    testJson["id"]=0;
    testJson["title"]="正在加载";
    testJson["body"]="正在加载";
    widgets.add(testJson);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("异步任务"),
      ),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
    );
  }

  //获得一个item
  Widget getRow(int i) {
    var user = Posts.fromJson(widgets[i]);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(" ${user.userId}"),
          Text(" ${user.id}"),
          Text(" ${user.body}"),
        ],
      ),
    );
  }

  //一个异步任务
  Future<void> loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    Response response = await get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}

