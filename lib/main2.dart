import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//使用画布绘制/绘画
void main() {
  debugPaintSizeEnabled = false; //开启断点调试模式
  runApp(MaterialApp(
      title: '使用画布绘制/绘画',
      theme: ThemeData(
        // 应用程序的主题
        // primarySwatch: Colors.grey,
        primaryColor: Colors.blue,
        //这使得视觉密度适应平台上运行应用程序。
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //程序主页
      home: DemoApp()));
}

class DemoApp extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(body: Signature());
}

class Signature extends StatefulWidget {
  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[]; //偏移量

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //手势探测器
      onPanUpdate: (DragUpdateDetails details) {
        //手指抬起
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
          _points = List.from(_points)..add(localPosition); //将手指按下到抬起的所有点记录起来
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null), //手指按下
      child: CustomPaint(
        //油漆
        painter: SignaturePainter(_points), //画笔
        size: Size.infinite,
      ),
    );
  }
}

//自定义油漆
class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    //开始画
    var paint = Paint()
      ..color = Colors.black //画笔颜色
      ..strokeCap = StrokeCap.round //画笔圆形
      ..strokeWidth = 3.0; //画笔宽度
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        //在画布上画一条直线
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
