library random_chat;

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:random_chat/api.dart';
import 'package:random_chat/storage.dart';
import 'package:rxdart/subjects.dart';

import 'models/identity.dart';
import 'models/message.dart';

class RandomChatBloc extends Bloc{
  
  Storage _storage;
  Api _api;

  Identity _currentIdentity;

  StreamSubscription _messagesSubscription;

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
    _api = Api();

    _messagesSubscription = _api.queryMessages().listen((messages) => _messagesController.add(messages));
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
    _messagesSubscription.cancel();
  }

  void _onIdentityChanged(Identity newIdentity) async {
    await _storage.saveIdentity(newIdentity);
    _currentIdentity = newIdentity;
    _currentIdentityController.add(_currentIdentity);
  }

  void _onMessageSent(String text) {
    if(_currentIdentity != null) {
      _api.addMessage(Message(identity: _currentIdentity, text: text))
      .then((_) {
          _messagesSubscription?.cancel();
          _messagesSubscription = _api.queryMessages().listen((messages) => _messagesController.add(messages));
      });
    }
  }

  void _getCurrentIdentity() async {
    _currentIdentity = await _storage.getIdentity();

    if(_currentIdentity != null) {
      _currentIdentityController.add(_currentIdentity);
    }
  }
}
