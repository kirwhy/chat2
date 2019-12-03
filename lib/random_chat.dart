library random_chat;

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/subjects.dart';

import 'models/identity.dart';
import 'models/message.dart';

class RandomChatBloc extends Bloc{
  
  //INPUTS

  StreamController<Identity> _changeIdentityController = StreamController();
  Sink<Identity> get changeIdentity => _changeIdentityController.sink;

  StreamController<String> _sendMessageController = StreamController();
  Sink<String> get sendMessage => _sendMessageController.sink;


  //OUTPUTS

  BehaviorSubject<Identity> _currentIdentityController = BehaviorSubject();
  Stream<Identity> get currentIdentity => _currentIdentityController.stream;

  PublishSubject<List<Message>> _messagesController = PublishSubject();
  Stream<List<Message>> get messages => _messagesController.stream;
  
  RandomChatBloc() {
    _changeIdentityController.stream.listen(_onIdentityChanged);
    _sendMessageController.stream.listen(_onMessageSent);
  }

  @override
  void dispose() {
    _changeIdentityController.close();
    _sendMessageController.close();
    _currentIdentityController.close();
    _messagesController.close();
  }

  void _onIdentityChanged(Identity newIdentity) {
    print("Changing identity to ${newIdentity.alias}");
  }

  void _onMessageSent(String text) {
    print("Sending message $text");
  }
}
