import 'package:flutter/cupertino.dart';

import 'model/User.dart';

class AppConfigProvider extends ChangeNotifier {
  User? currentUser =
  // User(
  //   id: 'CfLDu3uuJzNW4JZYSmbMOa8Id143',
  //   email: 'yousef1@gmail.com',
  //   userName: 'yousef',
  // );
  User(
    id: 'C8Khdj6tAocdpdCAbrcpPXa9hcq2',
    email: 'yousef@gmail.com',
    userName: 'yousef',
  );
}
