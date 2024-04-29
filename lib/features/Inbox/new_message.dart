// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final usernameController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final focusNodeSubject = FocusNode();
  final focusNodeMessage = FocusNode();

  bool areFieldsEmpty() {
    return usernameController.text.isEmpty ||
        subjectController.text.isEmpty ||
        messageController.text.isEmpty;
  }

  @override
  void dispose() {
    usernameController.dispose();
    subjectController.dispose();
    messageController.dispose();
    focusNodeSubject.dispose();
    focusNodeMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.transparent,
      appBar: AppBar(
        title: const Text(
          'New Message',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
          ),
        ),
        actions: <Widget>[
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: usernameController,
            builder:
                (BuildContext context, TextEditingValue value, Widget? child) {
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: subjectController,
                builder: (BuildContext context, TextEditingValue value,
                    Widget? child) {
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: messageController,
                    builder: (BuildContext context, TextEditingValue value,
                        Widget? child) {
                      return TextButton(
                        onPressed: areFieldsEmpty()
                            ? null
                            : () async {
                                final result = await context
                                    .read<NetworkService>()
                                    .sendMessege(
                                        usernameController.text,
                                        subjectController.text,
                                        messageController.text);

                                if (result['success']) {
                                  UserModel user = context
                                        .read<NetworkService>()
                                        .getUser();

                                  Messages message = Messages(
                                    id: result['messageID'],
                                    from: user.username,
                                    to: usernameController.text,
                                    subject: subjectController.text,
                                    text: messageController.text,
                                    createdAt: DateTime.now().toString(),
                                  );
                                  CustomSnackBar(
                                      context: context,
                                      content: 'Message sent'); 
                                  Navigator.pop(context, message);
                                  
                                }
                                else {
                                  CustomSnackBar(
                                      context: context,
                                      content: 'Message not sent');
                                  Navigator.pop(context, null);
                                }
                              },
                        child: Text('Send',
                            style: TextStyle(
                              color: areFieldsEmpty()
                                  ? Palette.greyColor
                                  : Palette.blueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Semantics(
                        identifier: 'username',
                        label: 'username',
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'u/',
                              style: TextStyle(color: Palette.whiteColor),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                  border: InputBorder.none,
                                ),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodeSubject);
                                },
                              ),
                            ),
                          ],
                        )),
                    const Divider(color: Colors.grey, thickness: 0.1),
                    Semantics(
                      identifier: 'Subject',
                      label: 'Subject',
                      child: TextFormField(
                        controller: subjectController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Subject',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          border: InputBorder.none,
                        ),
                        focusNode: focusNodeSubject,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(focusNodeMessage);
                        },
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.1),
                    Semantics(
                      identifier: 'Message',
                      label: 'Message',
                      child: TextFormField(
                        controller: messageController,
                        autofocus: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          border: InputBorder.none,
                        ),
                        focusNode: focusNodeMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
