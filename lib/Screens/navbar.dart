import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/scan_screen.dart';
import 'dart:ui' as ui;
import 'DashBoard.dart';
import 'aboutUs.dart';

class NavBar extends StatefulWidget {
  NavBar({Key key}) : super(key: key);

  NavBar.Info({
    this.username,
    this.photo,
    this.index,
    this.server,
  });

  NavBar.ind({
    this.index,
    this.isUser
  });

  BluetoothDevice server;
  String username = '';
  String photo = '';
  int index = 0;
  bool isUser = true;

  @override
  _NavBarState createState() => _NavBarState(username, photo, index, isUser, server);
}

class _NavBarState extends State<NavBar> {
  BluetoothDevice server;
  int _selectedScreen = 0;
  String username;
  String photo;
  int index;
  bool isUser;

  _NavBarState(this.username,this.photo, this.index, this.isUser, this.server);

  var _screens = [DashBoard(), ScanScreen(), AboutUs()];
  var _screens2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkScreen();
  }

  void checkScreen (){
    if (index == 1 && isUser){
      _screens2 = [DashBoard(), ControlRoom(username, photo, server), AboutUs()];
      _selectedScreen = 1;
    }else if(!isUser){
      _selectedScreen = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: ConvexAppBar(
          elevation: 3,
          height: 52,
          activeColor: Colors.lightBlue[50],
          color: Colors.black,
          style: TabStyle.titled,
          items: [
            TabItem(icon: Icons.home, title: 'Home'.tr().toString(),),
            TabItem(icon: Icons.gamepad, title: 'Control'.tr().toString()),
            TabItem(
              icon: Icons.assignment_late_outlined,
              title: 'About Us'.tr().toString(),
            ),
          ],
          initialActiveIndex: index,
          backgroundColor: Color(0xff17305F),
          onTap: (int value) {
            setState(() {
              _selectedScreen = value;
            });
          },
        ),
        body: index == 1  && isUser ? _screens2[_selectedScreen]: _screens[_selectedScreen],
      ),
    );
  }
}
