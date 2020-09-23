import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//自定义窗口小部件
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '自定义窗口小部件',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomButton("自定义窗口小部件"),
    );
  }
}

//自定义按钮
class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    // return RaisedButton(
    //     color: Colors.blue,
    //     textColor: Colors.white,
    //     onPressed: () {},
    //     child: Text(label));
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
            GestureDetector(
              onTap: () {
                print('MyButton was tapped!');
              },
              child: new Container(
                height: 36.0,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  color: Colors.lightGreen[500],
                ),
                child: new Center(
                  child: new Text('Engage'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
