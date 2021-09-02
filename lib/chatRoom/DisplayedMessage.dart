import 'package:chat/AppConfigProvider.dart';
import 'package:chat/model/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayedMessage extends StatelessWidget {
  final Message? message;
  DisplayedMessage(this.message);
  late AppConfigProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    return message?.senderId == provider.currentUser?.id
        ? sentMessage()
        : receivedMessage();
  }

  Widget sentMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            message?.getDateFormatted() ?? '',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          // flex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )),
                    child: Text(
                      message?.content ?? '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget receivedMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            message?.senderName ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color.fromRGBO(120, 121, 147, 1.0),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 248, 248, 1.0),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )),
                    child: Text(
                      message?.content ?? '',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Color.fromRGBO(120, 121, 147, 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                message?.getDateFormatted() ?? '',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
