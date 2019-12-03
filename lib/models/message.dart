import 'package:flutter/material.dart';
import 'package:random_chat/models/identity.dart';

class Message{
  Identity identity;
  String text;

  Message({@required this.identity, @required this.text});
}