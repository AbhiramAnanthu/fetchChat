import 'package:flutter/material.dart';
import 'package:frontend/pages/homeBody.dart';
import 'package:frontend/pages/urlInput.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 14, 44, 1),
      bottomNavigationBar: _tabBar(),
      body: const TabBarView(children: [
        HomeBody(),
        UrlInput(),
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
      padding: EdgeInsets.only(bottom: 16.0),
      indicatorColor: Colors.transparent,
      isScrollable: false,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: Color.fromRGBO(135, 35, 65, 1),
        borderRadius: BorderRadius.circular(50.0),
      ),
      tabs: [
        SizedBox(
            width: 100,
            child: Tab(
                icon: Icon(
              Icons.home,
              color: Colors.white,
            ))),
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
