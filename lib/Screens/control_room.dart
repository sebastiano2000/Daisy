import 'dart:math';
import 'dart:ui' as ui;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/Screens/Manual.dart';
import 'package:graduation_project/Screens/ObjectDetection.dart';
import 'package:graduation_project/Screens/manualControl.dart';
import 'package:graduation_project/Screens/voiceControl.dart';
import 'package:graduation_project/widgets/Constants.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/languages.dart';
import 'Chatbot.dart';
import 'DashBoard.dart';
import 'Voice.dart';

class ControlRoom extends StatefulWidget {
  const ControlRoom(this.username,this.photo, this.server, {Key key}) : super(key: key);

  static const String id = 'ControlRoomScreen';

  final BluetoothDevice server;
  final String username;
  final String photo;

  @override
  State<ControlRoom> createState() => _ControlRoomState(username, photo, server);
}

class _ControlRoomState extends State<ControlRoom> {

  @override
  void initState() {
    super.initState();

    DashBoard.isUser = true;
  }

  BluetoothDevice server;
  List<String> bot = [];
  List<String> commands = [];

  String welcomeMessage;
  String description;
  String note;
  String forwardCommand = "Enter the command equivalent to Forward.";

  String username;
  String photo;

  _ControlRoomState(this.username, this.photo, this.server);

  Future<void> load() async {
    bot.clear();

    final prefs = await SharedPreferences.getInstance();

    int status;

    int temp = 0 + Random().nextInt(4 - 0);

    try {
      status = prefs.getInt("status");
      if (status == null) {
        status = 0;
      }
    } catch (e) {
    }

    try {
      commands = prefs.getStringList("commands");
      if (commands == null) {
        commands = ["forward", "backward", "right", "left", "stop"];
      }
    } catch (e) {
    }

    switch (status) {
      case 0:
        {
          welcomeMessage = "BEEB POOP\nHello, I am Daisy Learning Bot.";
          description =
          "I am here to help you add commands in your own language to make you control the vehicle in an easier and more comfortable way.\n\nLets Get Started!";
          note =
          "Please Note that the Application is still in the Beta phase.\nSo we only support English and Arabic for now.";
          prefs.setInt("status", 1);
          break;
        }
      case 1:
        {
          welcomeMessage =
          "BEEB POOP\nI see we meet again Hello, I am Daisy Learning Bot.";
          description =
          "Don't forget I am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
          note =
          "We are doing our best to add more languages but for now we only support English and Arabic.";
          prefs.setInt("status", 2);
          break;
        }
      case 2:
        {
          welcomeMessage =
          "BEEP POOP\nLet me try and guess your name is it... ammm...\nI will remember it next time.";
          description =
          "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
          note =
          "No we still did not add new languages we will notify you once it's added so only type in English and Arabic";
          prefs.setInt("status", 3);
          break;
        }
      case 3:
        {
          welcomeMessage =
          "BEEP POOP\nAHAA I told you i will remember your name it is $username";
          description =
          "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
          note =
          "Supportiamo solo inglese e arabo\nThat means we only support English and Arabic in italian";
          prefs.setInt("status", 4);
          break;
        }
      case 4:
        {
          welcomeMessage = "BEEP POOP\nWelcome back my dear Friend $username";
          description =
          "You should already know but i will say it again\nI am here to make it easier for you to control your vehicle by adding your own commands.\n\nLets Get Started!";
          note =
          "We are working hard to add as many languages as we could but we only support English and Arabic for now.";

          prefs.setInt("status", temp);
          break;
        }
    }

    bot.add(welcomeMessage);
    bot.add(description);
    bot.add(note);
    bot.add(forwardCommand);
  }

  void _changeLanguage(Language language) {
    Locale _temp;
    switch (language.LanguageCode) {
      case 'en':
        _temp = Locale(language.LanguageCode, 'US');
        break;
      case 'ar':
        _temp = Locale(language.LanguageCode, 'EG');
        break;
      default:
        _temp = Locale(language.LanguageCode, 'US');
    }
    EasyLocalization.of(context).setLocale(_temp);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState != ConnectionState.waiting) {
            return Scaffold(
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                backgroundColor: Colors.redAccent,
                overlayColor: Colors.black,
                overlayOpacity: 0.4,
                spacing: 12,
                spaceBetweenChildren: 10,
                tooltip: 'Menu Options'.tr().toString(),
                childrenButtonSize: Size(65, 65),
                children: [
                  SpeedDialChild(
                      child: Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 30,
                      ),
                      backgroundColor: Color(0xff0E4EC9),
                      onTap: () {
                        setState(() {
                          Alert(
                            style: AlertStyle(
                                animationType: AnimationType.fromTop,
                                isButtonVisible: false,
                                isCloseButton: true,
                                isOverlayTapDismiss: true,
                                animationDuration: Duration(milliseconds: 700),
                                alertBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                )),
                            context: context,
                            title: "Choose Language".tr().toString(),
                            content: Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: DropdownButton(
                                hint: Text(
                                  "Change Language".tr().toString(),
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onChanged: (Language language) {
                                  _changeLanguage(language);
                                  Navigator.pop(context);
                                },
                                dropdownColor: Colors.white,
                                items: Language.languageList()
                                    .map<DropdownMenuItem<Language>>((lang) =>
                                    DropdownMenuItem(
                                      value: lang,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            lang.flag,
                                            style: TextStyle(fontSize: 23),
                                          ),
                                          Text(
                                            lang.name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ))
                                    .toList(),
                                icon: Icon(
                                  Icons.language,
                                  size: 35,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ).show();
                        });
                      }),
                  SpeedDialChild(
                      child: Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, bottom: 5, right: 5),
                          child: Icon(
                            FontAwesomeIcons.robot,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      backgroundColor: Color(0xff0E4EC9),
                      onTap: () async {
                        await load();

                        Navigation(
                            widget: widget,
                            context: context,
                            type: PageTransitionType.fade,
                            screen: ChatBot(
                              bot: bot,
                              commands: commands,
                              username: widget.username,
                            )).navigate();
                      }),
                ],
              ),
              backgroundColor: buttonsColor,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90,top: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,0),
                        child: Container(
                            width: 150,
                            height: 150,
                            child: Image.asset('assets/Images/daisy.png')),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360),
                            ),
                            margin: EdgeInsets.all(20),
                            width: 55,
                            height: 75,
                            child: photo != null
                                ? SizedBox(
                              height: 250,
                              child: CachedNetworkImage(
                                imageUrl: photo,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                                : Container(width: 0.0, height: 0.0),
                          ),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText('Welcome\n'.tr().toString() +
                                  '${widget.username}'.tr().toString(),
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 28,
                                  ),
                                  speed: Duration(milliseconds: 400)),
                            ],
                            totalRepeatCount: 1,
                            displayFullTextOnTap: true,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async{
                              // Map<Permission, PermissionStatus> statuses = await [
                              //   Permission.bluetooth,
                              //   Permission.bluetoothAdvertise,
                              //   Permission.bluetoothConnect,
                              //   Permission.bluetoothScan,
                              // ].request();
                              //
                              // if(statuses.isNotEmpty){
                              //   Navigation(
                              //       widget: widget,
                              //       context: context,
                              //       type: PageTransitionType.rightToLeft,
                              //       screen: Voice())
                              //       .navigate();
                              // }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VoiceControl(server: server);
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Lottie.asset(
                                      'assets/voice.json',
                                      height: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Voice\ncontrol'.tr().toString(),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async{
                              // Map<Permission, PermissionStatus> statuses = await [
                              //   Permission.bluetooth,
                              //   Permission.bluetoothAdvertise,
                              //   Permission.bluetoothConnect,
                              //   Permission.bluetoothScan,
                              // ].request();
                              //
                              // if(statuses.isNotEmpty){
                              //   Navigation(
                              //       widget: widget,
                              //       context: context,
                              //       type: PageTransitionType.rightToLeft,
                              //       screen: Manual())
                              //       .navigate();
                              // }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ManualControl(server: server);
                                  },
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Manual\ncontrol'.tr().toString(),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    Lottie.asset(
                                      'assets/manual.json',
                                      height: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async{
                              try {
                                List<CameraDescription> cameras = await availableCameras();

                                Navigation(
                                    widget: widget,
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    screen: ObjectDetection(cameras))
                                    .navigate();
                              } on CameraException catch (e) {
                                print('Error: $e.code\nError Message: $e.message');
                              }

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Lottie.asset(
                                      'assets/object.json',
                                      height: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                    ),
                                    Text(
                                      'Object\nDetection'.tr().toString(),
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) {
                      //               return Voice();
                      //             },
                      //           ),
                      //         );
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Color(0xFF0F0BDB),
                      //           boxShadow: <BoxShadow>[
                      //             BoxShadow(
                      //               color: Colors.blue.withOpacity(0.1),
                      //               blurRadius: 1,
                      //               offset: Offset(0, 2),
                      //             ),
                      //           ],
                      //         ),
                      //         alignment: Alignment.center,
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 14, horizontal: 16),
                      //         width: MediaQuery.of(context).size.width * 0.8,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               'Voice'
                      //                   'Control',
                      //               style: TextStyle(color: Colors.white),
                      //             ),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Icon(Icons.keyboard_voice, color: Colors.white)
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //         height:20
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         //manual page
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Color(0xFF0F0BDB),
                      //           boxShadow: <BoxShadow>[
                      //             BoxShadow(
                      //               color: Colors.blue.withOpacity(0.1),
                      //               blurRadius: 1,
                      //               offset: Offset(0, 2),
                      //             ),
                      //           ],
                      //         ),
                      //         alignment: Alignment.center,
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 14, horizontal: 16),
                      //         width: MediaQuery.of(context).size.width * 0.8,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               'Manual'
                      //                   'Control',
                      //               style: TextStyle(color: Colors.black),
                      //
                      //             ),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Icon(Icons.gamepad, color: Colors.white)
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Home();
          }
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Center(
          child: Icon(
            Icons.bluetooth_disabled,
            size: 200.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
