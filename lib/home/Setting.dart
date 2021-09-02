import 'package:chat/AppConfigProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  static String language ='English';
  @override
  Widget build(BuildContext context) {
    // final AppConfigProvider provider = Provider.of<AppConfigProvider>(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(25.0),
          child: Text(
              'lang',
              // AppLocalizations.of(context)!.language,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.start),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(45.0, 0, 45.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1),
                ),
                child: DropdownButton<String>(
                  value: language,
                  icon: Icon(Icons.arrow_drop_down),
                  iconEnabledColor: Colors.black,
                  iconSize: 24,
                  isExpanded: true,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      language = newValue!;
                      // if (newValue == 'English')
                      //   provider.changeLanguage('en');
                      // else if (newValue == 'Arabic') {
                      //   provider.changeLanguage('ar');
                      // }
                    });
                  },
                  items: <String>['English', 'Arabic']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
