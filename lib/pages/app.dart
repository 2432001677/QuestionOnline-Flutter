import 'package:flu1/pages/write_question.dart';
import 'package:flu1/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flu1/pages/home.dart';
import 'package:flu1/pages/favor.dart';
import 'package:flu1/pages/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: RoutePath,
      home: MainPage(title: 'QuestionOnline'),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _userId;
  int _selectedIndex = 0;
  final pages = [HomePage(), CoursePage(), FavorPage()];

  _loadUser() async {
    final SharedPreferences prefs = await _prefs;
    _userId = prefs.getInt("userId") ?? 0;
    if (_userId == 0) {
      Navigator.pushNamed(context, "/login");
    }
  }

  _goWriteQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteQuestionPage(),
      ),
    );
  }

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text("Course")),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("Favor")),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goWriteQuestion(),
      ),
      body: pages[_selectedIndex],
    );
  }
}
