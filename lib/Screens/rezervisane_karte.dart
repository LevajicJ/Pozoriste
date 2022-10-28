import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RezervisaneKarte extends StatefulWidget {
  const RezervisaneKarte({Key? key}) : super(key: key);

  @override
  State<RezervisaneKarte> createState() => _RezervisaneKarteState();
}

class _RezervisaneKarteState extends State<RezervisaneKarte> {

  final CollectionReference rezervacije = FirebaseFirestore.instance.collection('rezervacija');
  final user = FirebaseAuth.instance.currentUser!;
  late DateTime date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezervisane karte"),
        centerTitle: true,
        backgroundColor: const Color(0xFF900020),
      ),
      body: Column(
        children: [
          const Image( image: AssetImage("assets/maske.png"),
            height: 200,
            width: 200,
          ),
          Expanded(
            child: StreamBuilder(
              stream: rezervacije.where('email', isEqualTo: user.email).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                if(streamSnapshot.hasData){
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      Timestamp t = documentSnapshot['termin'] as Timestamp;
                      date = t.toDate();
                        return Card(
                          elevation: 10,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(documentSnapshot['predstava'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10,),
                              Text("${date.day.toString().padLeft(2,'0')}"
                                  ".${date.month.toString().padLeft(2,'0')}"
                                  ".${date.year.toString().padLeft(2,'0')}"
                                  ". ${date.hour.toString().padLeft(2,'0')}"
                                  ":${date.minute.toString().padLeft(2,'0')}",
                                style: const TextStyle(
                                    color: Color(0xFF031620),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10,),
                              Text('Broj rezervisanih ulaznica: ' + documentSnapshot['brojUlaznica'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10,),

                            ],
                          ),

                        );


                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
