import 'package:flutter/material.dart';
import 'package:guardian/src/DB/Datacontrol.dart';
import '../pageholder.dart';

enum Options { search, upload, copy, exit }

class EventView extends StatefulWidget {
  final MessagefetchData cameraData; // CameraData 필드 추가
  EventView({super.key, required this.cameraData});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  String url = 'http://192.168.0.23:5001/images/';

  var appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    String year = widget.cameraData.message_cameraStartTime.substring(0, 4);
    String month = widget.cameraData.message_cameraStartTime.substring(4, 6);
    String days = widget.cameraData.message_cameraStartTime.substring(6, 8);
    String hours = widget.cameraData.message_cameraStartTime.substring(8, 10);
    String min = widget.cameraData.message_cameraStartTime.substring(10, 12);

    String user = widget.cameraData.message_id;
    String situation = widget.cameraData.message_cameraSituation;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        elevation: 1.0,
        actions: [
          _popupbutton(),
        ],
        title: Text('Home`s CCTV'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color.fromARGB(255, 250, 250, 250),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        '$year년 $month월 $days일 $hours시 $min분',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        '$user 님의 CCTV에서 ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        '$situation이 감지되었습니다.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Image.network(url + widget.cameraData.message_cameraImage),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.warning),
                      Text('119 신고'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.phone_enabled),
                        Text('긴급 전화'),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _popupbutton() {
    return PopupMenuButton(
      onSelected: (value) {},
      offset: Offset(0.0, appBarHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
      ),
      itemBuilder: (ctx) => [
        _buildPopupMenuItem('Delete', Icons.delete),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData) {
    return PopupMenuItem(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.red,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void chunksdays() {}
}
