import 'package:chat/AppConfigProvider.dart';
import 'package:chat/auth/LoginScreen.dart';
import 'package:chat/home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class SideMenu extends StatelessWidget {

  Function onSideMenuItemClick;
  SideMenu(this.onSideMenuItemClick);

  @override
  Widget build(BuildContext context) {
    List<SideMenuItem> sideMenuList = [
      SideMenuItem(SideMenuItem.HOME, AppLocalizations.of(context)!.home, Icons.home,HomeScreen.ROUTE_NAME),
      SideMenuItem(SideMenuItem.SETTINGS, AppLocalizations.of(context)!.settings, Icons.settings, 'routeName'),
      SideMenuItem(SideMenuItem.SIGN_OUT, AppLocalizations.of(context)!.logOut, Icons.logout, LoginScreen.ROUTE_NAME)
    ];
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SideMenuWidget(sideMenuList[index],onSideMenuItemClick);
              },
              itemCount: sideMenuList.length,
            ),
          )
        ],
      ),
    );
  }
}

class SideMenuItem {
  static const HOME = 'home';
  static const SIGN_OUT = 'sign out';
  static const SETTINGS = 'settings';
  String routeName;
  String id;
  String title;
  IconData iconData;

  SideMenuItem(this.id, this.title, this.iconData,this.routeName);
}

class SideMenuWidget extends StatelessWidget {
  final SideMenuItem sideMenuItem;
  Function onSideMenuItemClick;
  SideMenuWidget(this.sideMenuItem,this.onSideMenuItemClick);
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider= Provider.of<AppConfigProvider>(context);

    return InkWell(
      onTap: () {
        onSideMenuItemClick(sideMenuItem);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(12), child: Icon(sideMenuItem.iconData)),
          Text(sideMenuItem.title)
        ],
      ),
    );
  }
}
