import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/rezervacija.dart';
import 'dodaj_izvodjenje.dart';

class PregledPredstave extends StatefulWidget {

  final DocumentSnapshot documentSnapshot;
  const PregledPredstave({Key? key, required this.documentSnapshot,}) : super(key: key);


  @override
  State<PregledPredstave> createState() => _PregledPredstaveState();
}

class _PregledPredstaveState extends State<PregledPredstave> {

  var nazivPredstave = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF900020),
      ),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 550,
                child: Image.network(
                  Text(widget.documentSnapshot['poster']).data.toString(),
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  fit: BoxFit.fill,
                ),
              )
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 500),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.documentSnapshot['naziv'],
                      style: const TextStyle(
                        color: Color(0xFF031620),
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: [
                      const Text("Vrsta: ",
                        style: TextStyle(
                          fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(widget.documentSnapshot['vrsta'],
                        style: const TextStyle(
                            fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text("Opis:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    )
                  ),
                  const SizedBox(height: 10,),
                  Text(widget.documentSnapshot['opis'],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Režija: ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(widget.documentSnapshot['rezija'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const Text("Scenografija: ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(widget.documentSnapshot['scenografija'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text("Igraju: ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(widget.documentSnapshot['uloge'],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed:() {
                      nazivPredstave = widget.documentSnapshot['naziv'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Rezervacija(nazivPredstave: nazivPredstave,)));
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(380, 60),
                        primary: Color(0xFF031620),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    child: Text("Rezerviši karte"),
                  ),
                  const SizedBox(height: 20,),
                  Visibility(
                    visible: vidljivost(),
                    child: ElevatedButton(
                      onPressed:() {
                        nazivPredstave = widget.documentSnapshot['naziv'];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Izvodjenje(nazivPredstave: nazivPredstave,)));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(380, 60),
                          primary: Color(0xFF031620),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                      child: Text("Dodaj izvođenje predstave"),
                    ),
                  )




                ],
              ),

            ),
          )
        ],
      ),
    );
  }

  bool vidljivost() {
    final korisnik = FirebaseAuth.instance.currentUser!;
    if(korisnik.email == 'admin@admin.com'){
      return true;
    }
    else {
      return false;
    }
  }
}
