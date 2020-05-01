import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  String _userName = "please login";
  var _prefs = SharedPreferences.getInstance();

  _getUserName() async {
    final prefs = await _prefs;
    setState(() {
      _userName = prefs.getString("userName");
    });
  }

  @override
  void initState() {
    _getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Padding accountIcon = Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipOval(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  child: Text(
                    _userName[0].toUpperCase(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
          Text(
            _userName,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );

    Expanded accountManager = Expanded(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add account'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage accounts'),
          ),
        ],
      ),
    );

    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: accountIcon,
              onTap: () => Navigator.pushNamed(context, "/login")
                  .whenComplete(_getUserName),
            ),
            accountManager,
          ],
        ),
      ),
    );
  }
}
