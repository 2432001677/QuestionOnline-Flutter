import 'dart:convert';
import 'package:flu1/pages/answer.dart';
import 'package:flu1/pages/write_answer.dart';
import 'package:flu1/utils/httpUtils.dart';
import 'package:flu1/utils/timeZoneParse.dart';
import 'package:flu1/widgets/round_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  final question;

  QuestionPage(this.question);

  @override
  State<StatefulWidget> createState() => _QuestionPage();
}

class _QuestionPage extends State<QuestionPage> {
  var answerList = [];
  var topHeight = 200.0;
  var _marked = false;
  var userId = 0;
  var _prefs = SharedPreferences.getInstance();

  _goAnswer(answer) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnswerPage(
                  answer: answer,
                )));
  }

  _gotoWriteAnswer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteAnswerPage(widget.question),
      ),
    ).whenComplete(_getAnswers);
  }

  _getMark() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt("userId") ?? 0;
      if (userId == 0) Navigator.pop(context);
      var questionId = widget.question["questionId"];
      final request = await httpGetRequest(
          "/question/is_marked?uid=$userId&qid=$questionId");
      setState(() {
        if (request == "true")
          _marked = true;
        else if (request == "false")
          _marked = false;
        else
          Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    }
  }

  _getAnswers() async {
    try {
      final request = await httpGetRequest(
          "/answer/" + widget.question["questionId"].toString());
      setState(() {
        topHeight = (widget.question["content"].length ~/ 30 + 1) * 25.0 + 190;
        answerList = jsonDecode(request);
      });
    } catch (e) {
      print(e);
    }
  }

  _greyText(str) {
    return Text(
      str,
      style: TextStyle(color: Colors.grey),
    );
  }

  _weight800Text(str) {
    return Text(
      str,
      style: TextStyle(fontWeight: FontWeight.w800),
    );
  }

  @override
  void initState() {
    _getMark();
    _getAnswers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final sumHeight = MediaQuery.of(context).size.height;
//    final paddingTop = MediaQuery.of(context).padding.top;
    final sumWidth = MediaQuery.of(context).size.width;

    final questionId = widget.question["questionId"];

    Color _markColor = Colors.lightBlueAccent;
    _mark() async {
      setState(() {
        _markColor = Colors.grey;
      });
      try {
        var prefs = await _prefs;
        var userId = prefs.getInt("userId") ?? 0;
        if (userId == 0) throw Exception("userId is 0");
        await httpGetRequest("/question/" +
            (_marked ? "unmark" : "mark") +
            "?uid=$userId&qid=$questionId");
        setState(() {
          widget.question["markNum"] += _marked ? -1 : 1;
          _marked = !_marked;
        });
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _markColor = Colors.lightBlueAccent;
        });
      }
    }

    IconButton backBtn = IconButton(
      icon: Icon(Icons.arrow_back),
      color: Colors.blueAccent,
      onPressed: () {
        Navigator.pop(context);
      },
    );
    IconButton markBtn = IconButton(
      icon: _marked ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
      color: _markColor,
      onPressed: () => _mark(),
    );

    Padding titlePad = Padding(
      padding: EdgeInsets.fromLTRB(4, 10, 4, 0),
      child: Text(
        widget.question["title"],
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
    );

    Padding contentPad = Padding(
      padding: EdgeInsets.fromLTRB(4, 10, 0, 0),
      child: Text(
        widget.question["content"],
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.question_answer),
        onPressed: () => _gotoWriteAnswer(),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: backBtn,
            centerTitle: true,
            pinned: true,
            expandedHeight: topHeight,
            actions: <Widget>[
              markBtn,
            ],
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                titlePad,
                contentPad,
                Padding(
                  padding: EdgeInsets.fromLTRB(4, 10, 4, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          roundName(widget.question["userName"]),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text(widget.question["userName"]),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          _weight800Text((answerList.length ?? 0).toString()),
                          _greyText("回答"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          _weight800Text(widget.question["markNum"].toString()),
                          _greyText("收藏"),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _greyText(widget.question["className"]),
                      _greyText(addEightHour(widget.question["createDate"])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 125,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _goAnswer(answerList[index]),
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircleAvatar(
                                    child: Text(
                                      answerList[index]["creatorName"][0]
                                          .toUpperCase(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  answerList[index]["creatorName"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: SizedBox(
                              height: 42,
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: sumWidth,
                                ),
                                child: Text(
                                  answerList[index]["content"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              _greyText(
                                  answerList[index]["supportNum"].toString()),
                              _greyText("赞同"),
                              SizedBox(
                                width: 10,
                              ),
                              _greyText(answerList[index]["nonsupportNum"]
                                  .toString()),
                              _greyText("反对"),
                              SizedBox(
                                width: 10,
                              ),
                              _greyText(addEightHour(
                                  answerList[index]["createDate"])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: answerList.length,
            ),
          ),
        ],
      ),
    );
  }
}
