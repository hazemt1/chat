import 'package:chat/AppConfigProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _searchText = '';
  late AppConfigProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);

    return Container(
      margin: EdgeInsets.only(right: 20, top: 10, bottom: 5, left: 10),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: provider.getFolded() ? 64 : 360,
        height: 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: provider.getFolded() ? Colors.transparent : Colors.white),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                child: InkWell(
                  child: Icon(
                    CupertinoIcons.clear,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    setState(() {
                      provider.toggleFold();
                      provider.setSearchText('');
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10,bottom: 5),
                  child: !provider.getFolded()
                      ? TextField(
                    decoration: InputDecoration(

                      hintText: 'Search Room',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Theme.of(context).primaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      _searchText = text;
                    },
                    onSubmitted: (text) {
                      setState(() {
                        provider.setSearchText(text);
                      });
                    },
                  )
                      : null,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                child: InkWell(
                  child: Icon(
                    CupertinoIcons.search,
                    color:
                    provider.getFolded() ? Colors.white : Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    setState(() {
                      if (!provider.getFolded() && _searchText != '') {
                        provider.setSearchText(_searchText);
                      } else if (provider.getFolded())
                        provider.toggleFold();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
