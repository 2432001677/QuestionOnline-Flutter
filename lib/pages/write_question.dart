import 'dart:convert';

import 'package:flu1/utils/httpUtils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteQuestionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WriteQuestionPage();
}

class _WriteQuestionPage extends State<WriteQuestionPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var _prefs = SharedPreferences.getInstance();
  String dropdownValue;
  var classList;
  var jsonList = [];
  var teacherName = "";

  _getClassList() async {
    var prefs = await _prefs;
    try {
      var request = await httpGetRequest(
          "/class/my_class/" + (prefs.getInt("userId") ?? 0).toString());
      jsonList = jsonDecode(request);
      setState(() {
        classList = <DropdownMenuItem<String>>[];
        for (var i = 0; i < jsonList.length; i++) {
          classList.add(DropdownMenuItem<String>(
            value: i.toString(),
            child: Text(jsonList[i]["className"]),
          ));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getClassList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialButton submitBtn = MaterialButton(
      child: Text(
        "发布问题",
        style: TextStyle(color: Colors.lightBlue),
      ),
      onPressed: () {},
    );

    AppBar appBar = AppBar(
      backgroundColor: Colors.white70,
      leading: IconButton(
        icon: Icon(Icons.close),
        color: Colors.blueAccent,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        submitBtn,
      ],
    );

    TextField textTitle = TextField(
//      autofocus: true,
      decoration: InputDecoration(
        hintText: "input a simple description here",
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
        fontSize: 22,
      ),
      controller: titleController,
    );

    TextField textContent = TextField(
      decoration: InputDecoration(
        hintText: "write more details",
        fillColor: Colors.black45,
        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      ),
      maxLines: 50,
      keyboardType: TextInputType.multiline,
      controller: contentController,
    );

    DropdownButton<String> classSelector = DropdownButton<String>(
      elevation: 24,
      iconSize: 30,
      hint: Text("choose your class"),
      value: dropdownValue,
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue;
          teacherName = jsonList[int.parse(newValue)]["teacherName"];
        });
      },
      items: classList,
    );
    Text teacher = Text(
      teacherName,
      style: TextStyle(
        fontSize: 16,
      ),
    );
    Text teacherText = Text(
      "老师",
      style: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
            child: textTitle,
          ),
          Expanded(
            child: textContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: classSelector,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 10, 10),
                child: Row(
                  children: <Widget>[
                    teacher,
                    teacherText,
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
