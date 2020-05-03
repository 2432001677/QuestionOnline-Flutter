import 'package:flu1/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CoursePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  var classList=[];

  @override
  Widget build(BuildContext context) {
    FlexibleSpaceBar flexibleSpaceBar = FlexibleSpaceBar(
      background: Image.asset(
        "imgs/course.jpg",
        fit: BoxFit.fitHeight,
      ),
    );

    SliverAppBar sliverAppBar = SliverAppBar(
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.blueAccent,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      floating: true,
      pinned: false,
      snap: true,
      expandedHeight: 280,
      flexibleSpace: flexibleSpaceBar,
      backgroundColor: Colors.white,
    );

    return Scaffold(
      drawer: MyDrawer(),
      body: EasyRefresh(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: <Widget>[
            sliverAppBar,
          ],
        ),
      ),
    );
  }
}
