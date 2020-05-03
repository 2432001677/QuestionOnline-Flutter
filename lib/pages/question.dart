import 'dart:convert';
import 'package:flu1/pages/answer.dart';
import 'package:flu1/pages/write_answer.dart';
import 'package:flu1/utils/httpUtils.dart';
import 'package:flu1/utils/timeZoneParse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
  var _answerTip = "no answer yet";
  var _prefs = SharedPreferences.getInstance();

  _goAnswer(answer) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnswerPage(
                  answer: answer,
                ))).whenComplete(_init);
  }

  _gotoWriteAnswer() {
    var myAns;
    for (var ans in answerList) {
      if (ans["creator"] == userId) {
        myAns = ans;
        break;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteAnswerPage(
          widget.question,
          answer: myAns,
        ),
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
    setState(() {
      _answerTip = "loading...";
    });
    try {
      final request = await httpGetRequest(
          "/answer/" + widget.question["questionId"].toString());
      setState(() {
        topHeight = (widget.question["content"].length ~/ 30 + 1) * 25.0 + 190;
        answerList = jsonDecode(request);
      });
    } catch (e) {
      print(e);
    } finally {
      if (answerList == null || answerList.length == 0) {
        setState(() {
          _answerTip = "no answer yet";
        });
      }
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

  _init() {
    _getMark();
    _getAnswers();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    Text titleText = Text(
      widget.question["title"],
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    );

    Text contentText = Text(
      widget.question["content"],
    );

    _userTitle(name) {
      return Row(
        children: <Widget>[
          ClipOval(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircleAvatar(
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }

    _noAnswerTip() {
      if (answerList.length == 0) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
            child: Text(
              _answerTip,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        );
      }
      return null;
    }

    AppBar appBar = AppBar(
      backgroundColor: Colors.white,
      leading: backBtn,
      actions: <Widget>[
        markBtn,
      ],
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.question_answer),
        onPressed: () => _gotoWriteAnswer(),
      ),
      body: EasyRefresh(
        onRefresh: () async {
          _init();
        },
        child: ListView.builder(
          itemCount: answerList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: titleText,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: contentText,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _userTitle(widget.question["userName"]),
                          Row(
                            children: <Widget>[
                              _weight800Text(
                                  (answerList.length ?? 0).toString()),
                              _greyText("回答"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _weight800Text(
                                  widget.question["markNum"].toString()),
                              _greyText("收藏"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _greyText(widget.question["className"]),
                          _greyText(
                              addEightHour(widget.question["createDate"])),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: _noAnswerTip(),
              );
            return ListTile(
              subtitle: GestureDetector(
                onTap: () => _goAnswer(answerList[index - 1]),
                child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 5, 4, 0),
                        child: _userTitle(answerList[index - 1]["creatorName"]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 6, 4, 0),
                        child: Text(
                          answerList[index - 1]["content"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 6, 4, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                _greyText(answerList[index - 1]["supportNum"]
                                    .toString()),
                                _greyText("赞同"),
                                SizedBox(
                                  width: 10,
                                ),
                                _greyText(answerList[index - 1]["nonsupportNum"]
                                    .toString()),
                                _greyText("反对"),
                              ],
                            ),
                            _greyText(
                              addEightHour(answerList[index - 1]["createDate"]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
