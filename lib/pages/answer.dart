import 'package:flu1/utils/httpUtils.dart';
import 'package:flu1/widgets/round_name.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  final answer;

  AnswerPage({@required this.answer});

  @override
  State<StatefulWidget> createState() => _AnswerPage();
}

class _AnswerPage extends State<AnswerPage> {
  var _isSupport = false;
  var _isNonsupport = false;

  _getMyVote() async {
    try {
      //todo
//      final request=await httpGetRequest("/answer/")
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getMyVote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sumHeight = MediaQuery.of(context).size.height;
    final sumWidth = MediaQuery.of(context).size.width;
    final paddingTop = MediaQuery.of(context).padding.top;

    _support() async {}

    _nonsupport() async {}

    _contentText(str) {
      return Text(
        str,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[800],
        ),
      );
    }

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
      backgroundColor: Colors.lightBlueAccent,
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

    RaisedButton supportNumBtn = RaisedButton(
      child: Text(
        widget.answer["supportNum"].toString(),
        style: TextStyle(
          color: Colors.blueAccent[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      onPressed: () => _support(),
      color: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
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
      onPressed: () => _support(),
      color: Colors.lightBlue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
    RaisedButton nonsupportNumBtn = RaisedButton(
      child: Text(
        widget.answer["nonsupportNum"].toString(),
        style: TextStyle(
          color: Colors.blueAccent[700],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      color: Colors.lightBlue[50],
      onPressed: () => _nonsupport(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
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
      onPressed: () => _nonsupport(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );

    _numBtnWidth(num) {
      var t = num ?? 0;
      var i = 0;
      do {
        t = t ~/ 10;
        i++;
      } while (t > 0);
      return i * 8.0 + 30;
    }

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
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: _numBtnWidth(widget.answer["supportNum"]),
                        child: supportNumBtn,
                      ),
                      SizedBox(
                        width: 72,
                        child: supportBtn,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: _numBtnWidth(widget.answer["nonsupportNum"]),
                        child: nonsupportNumBtn,
                      ),
                      SizedBox(
                        width: 72,
                        child: nonsupportBtn,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
