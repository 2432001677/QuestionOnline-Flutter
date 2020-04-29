import 'package:flu1/widgets/round_name.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  final answer;

  AnswerPage({@required this.answer});

  @override
  State<StatefulWidget> createState() => _AnswerPage();
}

class _AnswerPage extends State<AnswerPage> {
  _contentText(str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sumHeight = MediaQuery.of(context).size.height;
    final sumWidth = MediaQuery.of(context).size.width;
    final paddingTop = MediaQuery.of(context).padding.top;

    Padding contentPad = Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: sumHeight - paddingTop,
          minWidth: sumWidth,
        ),
        child: _contentText(widget.answer["content"]),
      ),
    );

    Scrollbar scrollbar = Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            contentPad,
          ],
        ),
      ),
    );

    AppBar appBar = AppBar(
      title: Row(
        children: <Widget>[
          roundName(widget.answer["creatorName"]),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(widget.answer["creatorName"]),
          ),
        ],
      ),
    );

    RaisedButton supportBtn = RaisedButton(
      child: Text(
        "点个赞",
        style: TextStyle(
          color: Colors.blueAccent[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      onPressed: () {
        print(MediaQuery.of(context).padding.top);
      },
      color: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
    RaisedButton nonsupportBtn = RaisedButton(
      child: Text(
        "踩一下",
        style: TextStyle(
          color: Colors.blueAccent[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      color: Colors.lightBlue[50],
      onPressed: () {},
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: <Widget>[
          scrollbar,
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  supportBtn,
                  nonsupportBtn,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
