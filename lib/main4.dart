import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//意图intent
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<String, WidgetBuilder> myPage = HashMap<String, WidgetBuilder>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '意向Intent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        //注册别名
        '/a': (context) => NewRoute(),
        '/b': (context) => TipRoute(text: '从上个路由传递过来的参数'),
        '/c': (context) => ResultRoute(),
      },
      home: _MyHomePage(),
    );
  }
}

//首页view
class _MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomeState();
  }
}

//首页view的state,在sate中调用setState会使整个ui布局更新
class _MyHomeState extends State<_MyHomePage> {
  String resultData = "无返回值";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //页面脚手架；它提供了默认的导航栏、标题和包含主屏幕widget树
      appBar: AppBar(
        title: Text("意向Intent"),
      ),
      body: Center(
        //内容中添加垂直布局：Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //调整布局位置
          children: <Widget>[
            RaisedButton(
              child: Text('跳转页面'),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pushNamed('/a');
              },
            ),
            RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/b');
                },
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('跳转页面带参数')),
            RaisedButton(
                onPressed: () async {
                  //导航到新路由,并等待异步结果
                  var result = await Navigator.of(context).pushNamed('/c');
                  setState(() {
                    resultData = result;
                  });
                },
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('跳转页面带参数并返回参数')),
            Text(
              resultData,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}

//创建一个新路由
class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //新的脚手架
      appBar: AppBar(
        //toolbar
        title: Text("新路由"),
      ),
      body: Center(
        //内容
        child: Text("这是一个新路由"),
      ),
    );
  }
}

//创建一个可以接收文本参数的新路由
class TipRoute extends StatelessWidget {
  final String text;

  TipRoute({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //新的脚手架
      appBar: AppBar(
        //toolbar
        title: Text("带参数进来的新路由"),
      ),
      body: Center(
        //内容
        child: Text(text),
      ),
    );
  }
}

//创建一个带有返回值的新路由
class ResultRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //新的脚手架
      appBar: AppBar(
        //toolbar
        title: Text("返回带参数的路由"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.pop(context, "我是返回值"),
            child: Text("返回"),
          )
        ],
      ),
    );
  }
}
