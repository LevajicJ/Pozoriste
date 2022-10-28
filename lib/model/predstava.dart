import 'package:cloud_firestore/cloud_firestore.dart';

class PredstavaModel {
 late  String naziv;
 late String opis;
 late String poster;
 late String rezija;
 late String scenografija;
 late String uloge;
 late String vrsta;

 PredstavaModel(
     this.naziv,
     this.opis,
     this.poster,
     this.rezija,
     this.scenografija,
     this.uloge,
     this.vrsta
     );

 PredstavaModel.fromDocumentSnapshot(QueryDocumentSnapshot snapshot){
  naziv = snapshot.get('naziv');
  opis = snapshot.get('opis');
  poster = snapshot.get('poster');
  rezija = snapshot.get('rezija');
  scenografija = snapshot.get('scenografija');
  uloge = snapshot.get('uloge');
  vrsta = snapshot.get('vrsta');
 }

 Map<String, dynamic> toJson() => {
  'naziv': naziv,
  'opis' : opis,
  'rezija': rezija,
  'scenografija': scenografija,
  'uloge': uloge,
  'poster': poster,
  'vrsta': vrsta
 };


}
