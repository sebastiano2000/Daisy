import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Screens/control_room.dart';
import 'package:graduation_project/Screens/scan_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui' as ui;
import 'DashBoard.dart';
import 'aboutUs.dart';

class NavBar extends StatefulWidget {
  NavBar({Key key}) : super(key: key);

  NavBar.Info({
    this.username,
    this.index,
  });

  NavBar.ind({
    this.index,
    this.isUser
  });

  String username = '';
  int index = 0;
  bool isUser = true;

  @override
  _NavBarState createState() => _NavBarState(username,index,isUser);
}

class _NavBarState extends State<NavBar> {
  int _selectedScreen = 0;
  String username;
  int index;
  bool isUser;

  _NavBarState(this.username, this.index,this.isUser);

  var _screens = [DashBoard(), ScanScreen(), AboutUs()];
  var _screens2 ;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkScreen();
  }


void checkScreen (){
  if (index == 1 && isUser){
    _screens2 = [DashBoard(), ControlRoom(username), AboutUs()];
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
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end:
            Alignment.centerRight,
            colors: <Color>[
              Color(0xff138def),
              Color(0xff478DC1),
              Color(0xff5062AE),
              Color(0xff593D99),
              Color(0xff91447E),
              Color(0xffD95662),
            ], // red to yellow
          ),
          style: TabStyle.titled,
          items: [
            TabItem(icon: Icons.home, title: 'Home'.tr().toString()),
            TabItem(icon: Icons.videogame_asset, title: 'Control'.tr().toString()),
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
