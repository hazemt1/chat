import 'package:chat/AppConfigProvider.dart';
import 'package:chat/addRoom/AddRoom.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/home/BrowseScreen.dart';
import 'package:chat/home/MyRoomsScreen.dart';
import 'package:chat/home/widgets/SearchBar.dart';
import 'package:chat/home/Setting.dart';
import 'package:chat/home/widgets/SideMenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  static const ROUTE_NAME = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppConfigProvider provider;

  int index = 0;

  String title = 'Chat App';

  List<Widget> homeView = [
    TabBarView(
      children: [
        MyRoomsScreen(),
        BrowseScreen(),
      ],
    ),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              )),
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              drawer: SideMenu(onSideMenuItemClick),
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: provider.getFolded()
                    ? Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu_outlined),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      )
                    : Container(),
                // toolbarHeight: 70,
                title: provider.getFolded()
                    ? Text(
                        title,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
                titleTextStyle: GoogleFonts.exo(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                centerTitle: true,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                actions: [
                  index==0 ? SearchBar():Container(),
                ],
                bottom: index == 0
                    ? TabBar(
                        indicatorColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(
                            text: 'My Rooms',
                          ),
                          Tab(
                            text: 'Browse',
                          )
                        ],
                      )
                    : null,
              ),
              backgroundColor: Colors.transparent,
              floatingActionButton: index==0? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
                },
                child: Icon(Icons.add),
              ): null,
              body: homeView[index],
            ),
          ),
        ),
      ],
    );
  }

  void onSideMenuItemClick(SideMenuItem sideMenuItem) {
    if (sideMenuItem.id == SideMenuItem.HOME) {
      setState(() {
        index = 0;
        title = 'Chat App';
      });
    } else if (sideMenuItem.id == SideMenuItem.SETTINGS) {
      // to handle
      setState(() {
        index = 1;
        title = 'Settings';
      });
    }
    Navigator.pop(context);
    if (sideMenuItem.id == SideMenuItem.SIGN_OUT) {
      provider.signOut();
      Navigator.of(context).pushReplacementNamed(LoginScreen.ROUTE_NAME);
    }
  }
}
