import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//with WidgetsBindingObserver 可以监听生命周期
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    //初始化
    WidgetsBinding.instance.addObserver(this);
    loadData3();
  }

  @override
  void dispose() {
    //销毁
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //异步请求网络，会阻塞UI线程
  loadData1() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    Response response = await get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }

  //异步任务，不会阻塞UI线程，但是需要告诉UI线程去改变，不可再子线程中修改UI
  loadData2() async {
    ReceivePort receivePort = new ReceivePort(); //接收端口，用于返回到UI线程
    //子线程中请求网络,关键词：Isolate.spawn（要运行的方法，接收端口）
    await Isolate.spawn(dataLoader, receivePort.sendPort);
    SendPort sendPort = await receivePort.elementAt(0); //获取队列中的第一个
    List msg = await sendReceive(
        sendPort, "https://jsonplaceholder.typicode.com/posts");
    setState(() {
      widgets = msg;
    });
  }

  //该方法实在独立线程中运行的
  static dataLoader(SendPort sendPort) async {
    ReceivePort port = new ReceivePort();
    sendPort.send(port.sendPort);

    await for (var i in port) {
      String data = i[0];
      SendPort replyTo = i[1];
      String dataURL = data;
      Response response = await get(dataURL);
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, String msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  Widget getRow(int i) {
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i]["title"]}"));
  }

  //显示进度
  loadData3() async{
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    Response response = await get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }

  showLoadingDialog() {
    return widgets.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterApp'),
        ),
        body:  getBody()
    // new ListView.builder(
        //     itemCount: widgets.length,
        //     itemBuilder: (BuildContext context, int position) {
        //       return getRow(position);
        //     })
    // body: Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       FlatButton(
    //         onPressed: loadData1(),
    //         child: Text("请求网络"),
    //       ),
    //       Text(widgets),
    //     ],
    //   ),
    // ),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {},
    //   tooltip: 'Add',
    //   child: Icon(Icons.add),
    // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// loadData() async {
//   ReceivePort receivePort = new ReceivePort();
//   await Isolate.spawn((message) {}, message)
// }
