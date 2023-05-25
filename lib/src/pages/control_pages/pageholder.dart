import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/pages/control_pages/tab_pages/homepage.dart';

class Pageholder extends StatelessWidget {
  const Pageholder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Home'),
        ),
        body: TabBarView(children: [
          Homepage(), // 메인페이지
          Center(
            child: Text("music"),
          ),
          Center(
            child: Text("apps"),
          ),
          Center(
            child: Text("settings"),
          ),
          Center(
              child: ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text('LogOut'),
          ))
        ]),
        bottomNavigationBar: Container(
          height: 60,
          padding: EdgeInsets.only(top: 0),
          child: const TabBar(
              indicator: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                color: Colors.red,
                width: 2,
              ))),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black38,
              labelStyle: TextStyle(fontSize: 13),
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.video_camera_front),
                  text: 'Stream',
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: 'Detection',
                ),
                Tab(
                  icon: Icon(Icons.event_note),
                  text: 'Event',
                ),
                Tab(
                  icon: Icon(Icons.settings),
                  text: 'Setting',
                )
              ]),
        ),
      ),
    );
  }
}
