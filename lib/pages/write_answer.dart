import 'dart:convert';

import 'package:flu1/pojo/answerForm.dart';
import 'package:flu1/utils/httpUtils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteAnswerPage extends StatefulWidget {
  final question;

  WriteAnswerPage(this.question);

  @override
  State<StatefulWidget> createState() => _WriteAnswerPage();
}

class _WriteAnswerPage extends State<WriteAnswerPage> {
  var _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    final sumHeight = MediaQuery.of(context).size.height;
    final sumWidth = MediaQuery.of(context).size.width;
    final paddingTop = MediaQuery.of(context).padding.top;

    final contentController = TextEditingController();

    _close() {
      Navigator.pop(context);
    }

    _answer() async {
      try {
        var prefs = await _prefs;
        var userId = prefs.getInt("userId") ?? 0;
        if (userId == 0)
          //todo
          return;
        var answerForm = AnswerForm.toJsonObj(
            widget.question["questionId"].toString(),
            userId.toString(),
            contentController.text);
        var request = await httpPostRequest("/answer/save", answerForm);
        var answerVo = jsonDecode(request);
        if (answerVo["answerId"] == null)
          //todo
          return;
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }

    AppBar appBar = AppBar(
      backgroundColor: Colors.grey[200],
      leading: IconButton(
        icon: Icon(Icons.close),
        color: Colors.blueAccent,
        onPressed: () => _close(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.send),
          color: Colors.blueAccent,
          onPressed: () => _answer(),
        )
      ],
    );

    Text questionText = Text(
      widget.question["title"],
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );

    TextField answerContentField = TextField(
      autofocus: true,
      maxLines: 50,
      controller: contentController,
      decoration: InputDecoration(
        hintText: "write answer",
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: questionText,
          ),
          SizedBox(
            width: sumWidth,
            height: 5,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
          Expanded(
            child: answerContentField,
          ),
        ],
      ),
    );
  }
}
