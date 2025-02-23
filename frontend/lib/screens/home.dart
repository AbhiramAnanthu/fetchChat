import 'package:flutter/material.dart';
import 'url_input.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 14, 44, 1),
      bottomNavigationBar: _tabBar(),
      body: TabBarView(controller: _controller, children: [
        InputUrl(),
        Text("hello"),
        Center(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }

  TabBar _tabBar() {
    return TabBar(
      controller: _controller,
      padding: EdgeInsets.only(bottom: 16.0),
      indicatorColor: Colors.transparent,
      isScrollable: false,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: Color(0xffe63946),
        borderRadius: BorderRadius.circular(50.0),
      ),
      tabs: [
        SizedBox(
            width: 100,
            child: Tab(
                icon: Icon(
              Icons.chat,
              color: Colors.white,
            ))),
        SizedBox(
            width: 100,
            child: Tab(
                icon: Icon(
              Icons.history,
              color: Colors.white,
            ))),
        SizedBox(
            width: 100,
            child: Tab(
                icon: Icon(
              Icons.person,
              color: Colors.white,
            ))),
      ],
    );
  }
}
