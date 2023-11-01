import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/DB/Datacontrol.dart';
import 'package:guardian/src/pages/register_login/fisrt.dart';
import 'package:guardian/src/widgets/CustomStyle.dart';
import '../../widgets/common_switch.dart';
import 'package:intl/intl.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'tab_pages/androidcam.dart';
import 'websocket/webrtc_controller.dart';
import 'websocket/webrtc_mainview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Pageholder extends StatefulWidget {
  const Pageholder({Key? key}) : super(key: key);

  @override
  State<Pageholder> createState() => _PageholderState();
}

class _PageholderState extends State<Pageholder> {
  final WebRTCController _controller = WebRTCController();
  List<Widget> drawerItems = []; // ListTile을 저장하는 리스트
  int itemCount = 0; // 현재 아이템 개수

  @override
  void initState() {
    super.initState();
    _controller.initHandler();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   //재구성할 때
  //   super.didChangeDependencies();
  //   _controller.initHandler();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScreenState>(
      valueListenable: _controller.screenNotifier,
      builder: (_, screenState, __) {
        late Widget body;
        switch (screenState) {
          case ScreenState.loading: // socket 접속 대기
            body = const Center(
              child: Text('Loading...'),
            );
            break;
          case ScreenState.initDone: // socket 연결 이후 화면
            _controller.requsetList();
            body = _initDone();
            break;
          case ScreenState.receivedCalling:
            // Not use
            break;
        }
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Color.fromARGB(255, 250, 250, 250),
                      title: Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Home Guardian',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      elevation: 0.0,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Builder(
                            builder: (context) => IconButton(
                              color: Colors.blue,
                              icon: Icon(
                                Icons.notifications,
                                size: 30,

                              ),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            endDrawer: _buildDrawer(),
            body: body,
            bottomNavigationBar: _buildBottomNavigationBar(),
          ),
        );
      },
    );
  }

  Widget _initDone() {
    return TabBarView(children: [
      /** 메인페이지 */
      _mainPage(),
      /** 감지 페이지 */
      Container(
        child: Center(
          child: ElevatedButton(
            onPressed: ()  async{
              // 버튼을 누를 때마다 ListTile 추가
               CameraData cameraData = await fetchData();//여기서 데이터를 받아옴
                     //*snackbar 작업
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                       content: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.yellow), // 아이콘 추가
                            SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격 조절
                              Text('넘어짐이 감지되었습니다!'),
                              ],
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red, // 스낵바의 배경색 변경
                                action: SnackBarAction(
                                  label: '닫기',
                                  onPressed: () {
                                    // 스낵바를 닫는 작업 추가
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  },
                                ),
                              ),
                                          );
                                          //*snackbar 작업
                      setState(() {
                        drawerItems.add(
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                            child: ListTile(
                              leading: Icon(Icons.security),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('사용자 ${cameraData.id}의 CCTV에서'),
                                  Text(' ${cameraData.cameraStartTime}에'),
                                  Image.asset('assets/images/fall_capture_20231030011159.jpg'),
                 
                                  Text('위험이 감지되었습니다!'),
                                ],
                              ),
                            ),
                          ),
                        );
                        itemCount++;
                        });
            },
            child: Text('Add ListTile to Drawer!'),
          ),
        ),
      ),
      /** 이벤트 페이지 */
      Container(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('예시용'),
                    subtitle: Text(
                      '가격 원',
                    ),
                  ),
                ],
              ),
            ),
           ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraApp()));}, child: Text('이미지 전송 테스트')),
          ],
        ),
      ),
      /** 환경설정 */
      _controlPage()
    ]);
  }

  /// 메인 페이지
  Widget _mainPage() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: ValueListenableBuilder<List<String>>(
          valueListenable: _controller.userListNotifier,
          builder: (_, list, __) {
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  String userId = list[index];
                  if (userId != _controller.user) {
                    return _buildUserCard(userId);
                  } else {
                    null;
                  }
                });
          }),
    );
  }

  /// 메인 페이지 유저카드 생성
  Widget _buildUserCard(String userId) {
    return Card(
      margin: EdgeInsets.all(30.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Home",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "유저 ID : $userId",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  "최근 로그 : <<추가해야함>>",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                iconSize: 50,
                color: Colors.black,
                onPressed: () async {
                  setState(() {
                    _controller.to = userId;
                  });
                  await _controller.sendOffer();
                  _moveToVideoView();
                },
                icon: Icon(
                  Icons.login,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _moveToVideoView() {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebRTCMainView(
          controller: _controller,
        ),
      ),
    ).whenComplete(() {
      _controller.screenNotifier.value = ScreenState.initDone;
    });
  }

  /// 환경설정 페이지
  Widget _controlPage() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //1
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "General Setting",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    title: Text("Account"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return const First();
                        },
                      ), (route) => false);
                    },
                  ),
                ],
              ),
            ),

            //2
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Network",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.sim_card,
                      color: Colors.grey,
                    ),
                    title: Text("Simcard & Network"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.wifi,
                        color: Colors.amber,
                      ),
                      title: Text("Wifi"),
                      trailing: CommonSwitch(
                        defValue: true,
                      )),
                  ListTile(
                    leading: Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    ),
                    title: Text("More"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ],
              ),
            ),

            //3
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Sound",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 2.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.do_not_disturb_off,
                      color: Colors.orange,
                    ),
                    title: Text("Silent Mode"),
                    trailing: CommonSwitch(
                      defValue: false,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.vibration,
                      color: Colors.purple,
                    ),
                    title: Text("Vibrate Mode"),
                    trailing: CommonSwitch(
                      defValue: true,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.volume_up,
                      color: Colors.green,
                    ),
                    title: Text("Sound Volume"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Drawer 생성
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100,
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        'Event',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildDynamicListTiles(),
        ],
      ),
    );
  }

  /// Drawer 타일생성 -> 수정필요
  Widget _buildDynamicListTiles() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: drawerItems.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            setState(() {
              drawerItems.removeAt(index);
            });
          },
          child: drawerItems[index],
        );
      },
    );
  }

  /// 하단바
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(top: 0),
      child: const TabBar(
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.black38,
        labelStyle: TextStyle(fontSize: 13),
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
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
        ],
      ),
    );
  }
}
