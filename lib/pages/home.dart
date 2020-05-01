import 'dart:convert';
import 'package:flu1/pages/question.dart';
import 'package:flu1/utils/httpUtils.dart';
import 'package:flu1/utils/timeZoneParse.dart';
import 'package:flu1/widgets/drawer.dart';
import 'package:flu1/widgets/round_name.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var questionList = [];

  _getQuestions() async {
    try {
      final request = await httpGetRequest("/question/all");
      setState(() {
        questionList = jsonDecode(request);
      });
    } catch (e) {
      print(e);
    }
  }

  _goQuestion(question) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionPage(question),
        ));
  }

  @override
  void initState() {
    _getQuestions();
    super.initState();
  }

  Row questionRow = Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.blueAccent,
                onPressed: () {
                  //todo
                },
              ),
            ],
            leading: Builder(
              builder: (BuildContext context) {
                // 用leading自定义弹出Drawer
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            floating: true,
            pinned: false,
            snap: true,
            expandedHeight: 250,
//            flexibleSpace: Column(
//              children: <Widget>[
//                Text("Question Online"),
//              ],
//            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Question Online",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                ),
              ),
              background: Image.asset(
                "imgs/home.jpg",
                height: 210,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 121,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _goQuestion(questionList[index]),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(2, 0, 2, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      // 边框
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      boxShadow: [
                        //阴影
                        BoxShadow(
                          blurRadius: 3, //阴影范围
                          spreadRadius: 0.2, //阴影浓度
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            questionList[index]["title"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              roundName(questionList[index]["userName"]),
                              Padding(
                                padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                child: Text(
                                  questionList[index]["userName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              questionList[index]["content"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                questionList[index]["className"],
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                addEightHour(questionList[index]["createDate"]),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: questionList.length, // 项数
            ),
          ),
        ],
      ),
    );
  }
}
