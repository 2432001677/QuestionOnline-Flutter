import 'dart:convert';
import 'package:flu1/pojo/loginForm.dart';
import 'package:flu1/utils/httpUtils.dart';
import 'package:flu1/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  var _prefs = SharedPreferences.getInstance();
  String dropdownValue;
  var schoolList;
  final usernameController = TextEditingController();
  final passwdController = TextEditingController();
  String _loginBtnText = "Login";

  _logining() async {
    setState(() {
      _loginBtnText = "Login......";
    });
    try {
      var haveSpace = false;
      var message = "";
      if (usernameController.text == "") {
        haveSpace = true;
        message = "账号为空";
      } else if (passwdController.text == "") {
        haveSpace = true;
        message = "密码为空";
      } else if (dropdownValue == null) {
        haveSpace = true;
        message = "学校为空";
      }
      if (haveSpace) {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            message: message,
          ),
        );
        return;
      }
      var loginForm=LoginForm.toJsonObj(usernameController.text, passwdController.text, dropdownValue);
      final loginResults = await httpPostRequest("/login", loginForm);
      var results = json.decode(loginResults);
      if (results["result"]) {
        var prefs = await _prefs;
        prefs.setInt("userId", results["userId"]);
        prefs.setString("userName", results["userName"]);
        prefs.setString("userType", results["userType"]);
        prefs.setString("school", results["school"]);
        setState(() {
          _loginBtnText = "Login";
        });
        Navigator.pop(context);
      } else {
        print(results["result"]);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _loginBtnText = "Login";
      });
    }
  }

  _getSchools() async {
    var schoolsJson;
    try {
      schoolsJson = await httpGetRequest("/schools");
      var schools = jsonDecode(schoolsJson);
      setState(() {
        schoolList = <DropdownMenuItem<String>>[];
        for (var school in schools) {
          var schoolName = school["schoolName"];
          schoolList.add(DropdownMenuItem<String>(
            value: schoolName,
            child: Text(schoolName),
          ));
        }
      });
    } catch (e) {
      print("err " + e);
      schoolList = <DropdownMenuItem<String>>[];
    }
  }

  @override
  void initState() {
    _getSchools();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Row avatar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.account_circle,
          color: Theme.of(context).accentColor,
          size: 80,
        )
      ],
    );
    TextField username = TextField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: "account name",
        hintText: "enter your ID(numbers)",
      ),
      controller: usernameController,
      inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
    );

    DropdownButton<String> schoolSelector = DropdownButton<String>(
      elevation: 24,
      iconSize: 30,
      hint: Text("please select a school"),
      value: dropdownValue,
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: schoolList,
    );

    TextField password = TextField(
      decoration: InputDecoration(labelText: "password"),
      obscureText: true,
      controller: passwdController,
    );

    Text forgetPasswd = Text(
      "Forget password?",
      style: TextStyle(
        color: Colors.lightBlue,
      ),
    );
    Text register = Text(
      "Register",
      style: TextStyle(
        color: Colors.lightBlue,
      ),
    );
    RaisedButton loginBtn = RaisedButton(
      child: Text(
        _loginBtnText,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 20,
        ),
      ),
      color: Colors.blue,
      onPressed: _logining,
    );
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Loging"),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
          child: Column(
            children: <Widget>[
              avatar,
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: username,
              ),
              SizedBox(
                height: 50,
                child: schoolSelector,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: password,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                      height: 30,
                      child: GestureDetector(
                        child: forgetPasswd,
                      )),
                  SizedBox(
                      height: 30,
                      child: GestureDetector(
                        child: register,
                        onTap: () => Navigator.pushNamed(context, "/register"),
                      )),
                ],
              ),
              SizedBox(
                height: 45,
                width: 140,
                child: loginBtn,
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        var prefs = await SharedPreferences.getInstance();
        var _counter = prefs.getInt("userId") ?? 0;
        return _counter == 0 ? false : true;
      },
    );
  }
}
