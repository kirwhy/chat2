import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:random_chat/random_chat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        creator: (c, b) => RandomChatBloc(),
        child: MaterialApp(
          title: "RandomChat Example",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Text("RandomChat Example"),
        ));
  }
}