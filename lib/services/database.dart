import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  // Call this function on sign up/ login
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from Snapshot
  List<Brew> _brewListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew (
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '0'
      );
    }).toList();
  }

  // get brew stream
  Stream<List<Brew>> get brews {
    // we convert the stream of snapshots to stream of List of Brew
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}