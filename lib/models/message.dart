import 'package:flutter/material.dart';
import 'package:random_chat/models/identity.dart';

class Message{
  Identity identity;
  String text;
  num createdAt;
  bool sent;

  Message({@required this.identity, @required this.text, this.createdAt, this.sent});
}