import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//基本view属性
void main() {
  debugPaintSizeEnabled = true; //开启断点调试模式
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '基本小部件操作',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage>
    with TickerProviderStateMixin {
  AnimationController controller; //动画控制器
  CurvedAnimation curve; //曲线动画
  String textToShow = "I Like Flutter";
  bool toggle = true; //是否删除子view

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2), //动画执行时间2s
      vsync: this, //垂直同步
    );
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn); //加速运动
  }

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  void _updateText() {
    //setstate会让build方法重新走
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  _getToggleChild() {
    if (toggle) {
      return Text('Toggle One');
    } else {
      return MaterialButton(
          onPressed: () {},
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Toggle Two'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample App"),
      ),
      body: Center(
        //内容中添加垂直布局：Column
          child: Column(children: <Widget>[
        FadeTransition(//过渡动画
          opacity: curve,
          child: Icon(
            Icons.update,
          ),
        ),
        Text(textToShow),
        MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: _updateText,
          child: Text('修改文字内容'),
          padding: EdgeInsets.only(left: 20.0, right: 10.0),
        ),
        MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: _toggle,
          child: Text('添加或删除组件'),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
        ),
        _getToggleChild(),
        MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () => controller.forward(),//向前的动画
          child: Text('制作动画'),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}
