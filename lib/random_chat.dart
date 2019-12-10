library random_chat;

import 'dart:async';
import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:random_chat/api.dart';
import 'package:random_chat/storage.dart';
import 'package:rxdart/subjects.dart';

import 'models/identity.dart';
import 'models/message.dart';

class RandomChatBloc extends Bloc {
  Storage _storage;
  Api _api;

  Identity _currentIdentity;

  StreamSubscription _messagesSubscription;

  //INPUTS

  StreamController<void> _changeIdentityController = StreamController();
  Sink<void> get changeIdentity => _changeIdentityController.sink;

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

    _messagesSubscription = _api
        .queryMessages()
        .listen((messages) => _messagesController.add(messages));
        
    _getCurrentIdentity();
    _changeIdentityController.stream.listen((_) => _onIdentityChanged(_generateIdentity()));
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
    if (_currentIdentity != null) {
      _api
          .addMessage(Message(identity: _currentIdentity, text: text))
          .then((_) {
        _messagesSubscription?.cancel();
        _messagesSubscription = _api
            .queryMessages()
            .listen((messages) => _messagesController.add(messages));
      });
    }
  }

  void _getCurrentIdentity() async {
    _currentIdentity = await _storage.getIdentity();

    if (_currentIdentity != null) {
      _currentIdentityController.add(_currentIdentity);
    } else {
      _onIdentityChanged(_generateIdentity());
    }
  }

  Identity _generateIdentity() {
    List<String> manNames = [
      "Troy",
      "Adam",
      "Chung",
      "Grover",
      "Noel",
      "Terrance",
      "Earl",
      "Galen",
      "Stewart",
      "Claud",
      "Stanton",
      "Richie",
      "Andreas",
      "Jefferson",
      "Jeffry",
      "Frances",
      "Jamal",
      "Lonnie",
      "Shelby",
      "Ariel",
      "Bernard",
      "Deangelo",
      "Demetrius",
      "Lucius",
      "Harry",
      "Jc",
      "Antwan",
      "Mauro",
      "Kelley",
      "Marc",
      "Lamont",
      "Solomon",
      "Tobias",
      "Rico",
      "Adrian",
      "Erick",
      "Kennith",
      "Werner",
      "Brandon",
      "Cleo",
      "Connie",
      "Benton",
      "Rosario",
      "Eldon",
      "Trent",
      "Kirby",
      "Rory",
      "Newton",
      "Cecil",
      "Anderson",
      "Merlin",
      "Dusty",
      "Arnoldo",
      "Lyle",
      "Cedrick",
      "Gayle",
      "Rashad",
    ];

    List<String> womanNames = [
      "Danica",
      "Candelaria",
      "Rosenda",
      "Laquanda",
      "Pam",
      "Garnett",
      "Grace",
      "Micheline",
      "Bell",
      "Kiera",
      "Tamesha",
      "Mee",
      "Regenia",
      "Lesa",
      "Hiedi",
      "Slyvia",
      "Karri",
      "Margeret",
      "Ocie",
      "Idella",
      "Lyda",
      "Rhonda",
      "Alleen",
      "Crystle",
      "Kristeen",
      "Nicki",
      "Maren",
      "Arletha",
      "Nathalie",
      "Tamatha",
      "Genevive",
      "Sandie",
      "Karine",
      "Nadia",
      "Talisha",
      "Micaela",
      "Pauletta",
      "Carolann",
      "Irish",
      "Neomi",
      "Verdell",
      "Wilhelmina"
    ];

    //Decide gender
    num gender = Random().nextInt(2);

    String alias = gender == 0 ? manNames[Random().nextInt(manNames.length)] : womanNames[Random().nextInt(womanNames.length)];
    String profilePictureUrl = "https://randomuser.me/api/portraits/${gender == 0 ? 'men' : 'women'}/${Random().nextInt(90)}.jpg";

    return Identity(
      alias: alias,
      profilePictureUrl: profilePictureUrl
    );
  }
}
