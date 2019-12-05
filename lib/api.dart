import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_chat/models/identity.dart';

import 'models/message.dart';

class Api {

  Future<void> addMessage(Message message) {
    return Firestore.instance.collection('messages').document()
      .setData(
        { 
          'identity': {
            'alias' : message.identity.alias,
            'profile_picture_url' : message.identity.profilePictureUrl,
          }, 
          'text': message.text,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }
      );
  }

  Stream<List<Message>> queryMessages() {
    return Firestore.instance.collection('messages').snapshots()
      .map((snapshot) => snapshot.documents)
      .map((documents) => documents.map((document) {
        String alias = document['identity.alias'];
        String profilePicture = document['identity.profile_picture_url'];
        String text = document['text'];
        
        return Message(
          identity: Identity(
            alias: alias,
            profilePictureUrl: profilePicture
          ),
          text: text, 
          createdAt: document['createdAt'],
          sent: !document.metadata.hasPendingWrites,
        );    
      })).map((messages) {
        List<Message> messagesList = messages.toList();
        messagesList.sort((m1, m2) => m1.createdAt.compareTo(m2.createdAt));
        return messagesList;
      });
  }
}