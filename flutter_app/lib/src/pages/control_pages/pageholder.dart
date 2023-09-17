import 'package:flutter/material.dart';
import 'package:guardian/src/pages/control_pages/tab_pages/Streamingpage.dart';
import '../widgets/common_switch.dart';
import 'package:intl/intl.dart';

class Pageholder extends StatefulWidget {
  const Pageholder({Key? key}) : super(key: key);

  @override
  _PageholderState createState() => _PageholderState();
}

class _PageholderState extends State<Pageholder> {
  List<Widget> drawerItems = []; // ListTile을 저장하는 리스트
  int itemCount = 0; // 현재 아이템 개수
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    // initState에서 현재 시간을 업데이트합니다.
    updateTime();
  }

  void updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm:ss'); // 시간 형식을 지정합니다.
    setState(() {
      currentTime = formatter.format(now); // 현재 시간을 포맷팅하여 변수에 저장합니다.
    });

    // 1초마다 현재 시간을 업데이트합니다.
    Future.delayed(Duration(seconds: 1), updateTime);
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBar(
                  backgroundColor: Color.fromARGB(255, 250, 250, 250),
                  title: Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: Text(
                      'Home Guardian',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  elevation: 0.0,
                  // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: Builder(
                        builder: (context) => IconButton(
                          color: Colors.blue,
                          icon: Icon(
                            Icons.notifications,
                            size: 30,
                          ),
                          onPressed: () => Scaffold.of(context).openEndDrawer(),
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
        endDrawer: _buildDrawer(),
        body: TabBarView(children: [
          /** 메인페이지 */
          Container(
            color: Color.fromARGB(255, 250, 250, 250),
            margin: EdgeInsets.all(50),
            child: Column(
              children: [
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
                      // 버튼을 누를 때마다 ListTile 추가
                      setState(() {
                        drawerItems.add(
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                            child: ListTile(
                              leading: Icon(Icons.security),
                              title: Text(
                                '$currentTime' '에 감지 기록이 발생하였습니다.',
                              ),
                            ),
                          ),
                        );
                        itemCount++;
                      });
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
          ),
          /** 영상페이지 */
          Container(
            child: Center(
              child: Text("apps"),
            ),
          ),
          /** 감지 페이지 */
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // 버튼을 누를 때마다 ListTile 추가
                  setState(() {
                    drawerItems.add(
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: ListTile(
                          leading: Icon(Icons.security),
                          title: Text(
                            'Time: ' '$currentTime' '에 감지 기록이 발생하였습니다.',
                          ),
                        ),
                      ),
                    );
                    itemCount++;
                  });
                },
                child: Text('Add ListTile to Drawer'),
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
              ],
            ),
          ),
          /** 환경설정 */
          Container(
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
          )
        ]),
        bottomNavigationBar: _buildBottomNavigationBar(),
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
      ],
    ),
  );
}
