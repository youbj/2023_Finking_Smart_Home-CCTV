import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:guardian/src/pages/LoginPage.dart';
import 'package:guardian/src/pages/control_pages/tab_pages/Streamingpage.dart';
import 'package:guardian/src/pages/control_pages/tab_pages/homepage.dart';
import 'package:guardian/src/pages/control_pages/tab_pages/webcam_screen.dart';

class Pageholder extends StatelessWidget {
  const Pageholder({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Home'),
        ),
        body: TabBarView(children: [
          Container(
            margin: EdgeInsets.all(50),
            child: Column(
              children: [
                //Container(width: size.width * 0.7, child: WebcamScreen()),
                Container(
                  width: size.width * 0.7,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StreamPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '배터리 잔량 : 98%',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Text(
                                '로그 : 2023-05-31',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: IconButton(
                              color: Colors.black54,
                              icon: Icon(Icons.more_vert),
                              iconSize: size.width * 0.05,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // 메인페이지
          
          Center(
            child: Text("apps"),
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
              GoogleSignIn().signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginWidget(),
              ));
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
