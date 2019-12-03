library random_chat;

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:random_chat/storage.dart';
import 'package:rxdart/subjects.dart';

import 'models/identity.dart';
import 'models/message.dart';

class RandomChatBloc extends Bloc{
  
  Storage _storage;

  Identity _currentIdentity;

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
    _storage = Storage();

    _getCurrentIdentity();
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

  void _onIdentityChanged(Identity newIdentity) async {
    await _storage.saveIdentity(newIdentity);
    _currentIdentity = newIdentity;
    _currentIdentityController.add(_currentIdentity);
  }

  void _onMessageSent(String text) {
    print("Sending message : ${_currentIdentity?.alias} - $text");
  }

  void _getCurrentIdentity() async {
    _currentIdentity = await _storage.getIdentity();

    if(_currentIdentity != null) {
      _currentIdentityController.add(_currentIdentity);
    }
  }
}
