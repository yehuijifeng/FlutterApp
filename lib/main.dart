import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';

//列表
void main() {
  debugPaintSizeEnabled = false; //开启断点调试模式
  runApp(MyApp());
}

//应用程序的根
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wordPair = WordPair.random(); //生成一个随机英文字母
    return MaterialApp(
        title: '列表',
        theme: ThemeData(
          // 应用程序的主题
          // primarySwatch: Colors.grey,
          primaryColor: Colors.white,
          //这使得视觉密度适应平台上运行应用程序。
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //程序主页
        home: RandomWords());
  }
}

// 添加有状态的小部件
// 输入stful 自动生成StatefulWidget和State<?>的代码
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //保存生成的英文单词
  final _biggerFont = TextStyle(fontSize: 18.0, color: Colors.red); //字体大小
  final _saved = Set<WordPair>(); //保存被用户选中的英文单词

  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random(); //生成随机字母
    // return Text(wordPair.asPascalCase);
    //生成整个页面的ui
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flutter'), //标题
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                _pushSaved(context);
              })
        ], //appbar上的按钮
      ),
      body: Center(
        // child: Text('Hello World !'),
        // child: Text('${wordPair.asPascalCase}'),
        child: _buildSuggestions(),
      ),
    );
  }

  //此方法将构建 ListView显示建议的单词对的。
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //插入编程式断点，条件为真时中断
          // debugger(when: false);
          if (i.isOdd) //是否是奇数
            return Divider(
              height: 10,
            ); //产生一个高10的分割线
          final index = i ~/ 2; //2/ i/2然后取整；
          //如果当前行数大于了生成的英文单词，则生成10个新的英文单词
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  //list的item部件
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair); //查询是否是用户选中的单词
    return ListTile(
      title: Text(
        //item中显示的英文单词
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        //用户是否点击了喜欢这个英文单词
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //点击item的操作
        setState(() {
          //调用setState()方法会触发build()方法的重新调用，更新整个ui
          if (alreadySaved) {
            //如果原本就有该单词，则移除
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  //appbar上的按钮点击事件
  void _pushSaved(BuildContext context) {
    //导航到新页面
    Navigator.of(context).push(
      MaterialPageRoute<Void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('收藏的单词'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
