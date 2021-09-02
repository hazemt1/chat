import 'package:chat/home/HomeScreen.dart';
import 'package:flutter/material.dart';



class SideMenu extends StatelessWidget {

  Function onSideMenuItemClick;
  SideMenu(this.onSideMenuItemClick);
  @override
  Widget build(BuildContext context) {
    List<SideMenuItem> sideMenuList = [
      SideMenuItem(SideMenuItem.CATEGORIES, SideMenuItem.CATEGORIES, Icons.list,HomeScreen.ROUTE_NAME),
    ];
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(
              child: Text(
                'test',
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
  static const CATEGORIES = 'Cats';
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(sideMenuItem.routeName);
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
