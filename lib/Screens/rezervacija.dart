import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/predstave.dart';

import 'bnb.dart';

class Rezervacija extends StatefulWidget {

  final String nazivPredstave;
  const Rezervacija({Key? key, required this.nazivPredstave}) : super(key: key);

  @override
  State<Rezervacija> createState() => _RezervacijaState();
}

class _RezervacijaState extends State<Rezervacija> {
  int? selektovaniIndeks;
  int brojUlaznica = 1;
  late DateTime date;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var termini = FirebaseFirestore.instance.collection('repertoar').where('predstava', isEqualTo: widget.nazivPredstave);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezervacija"),
        centerTitle: true,
        backgroundColor: const Color(0xFF900020),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Image( image: AssetImage("assets/Karte.png"),
                height: 200,
                width: 200,
              ),
              Center(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 10,
                      child: Container(
                        margin: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            ListTile(
                                title: Center(
                                  child: Text(widget.nazivPredstave,
                                    style: const TextStyle(
                                      color: Color(0xFF031620),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                            ),
                            const SizedBox(height: 30,),
                            const Text("Izaberite datum: ",
                              style: TextStyle(
                                  color: Color(0xFF031620),
                                  fontSize: 25
                              ),
                            ),
                            const SizedBox(height: 20,),

                            Container(
                              //width: double.maxFinite,
                              height: 200,

                              child: StreamBuilder(
                                stream: termini.snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                                  if(streamSnapshot.connectionState == ConnectionState.waiting){
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  else {
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index){
                                        final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                                        Timestamp t = documentSnapshot['termin'] as Timestamp;
                                        date = t.toDate();
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selektovaniIndeks = index;
                                            });
                                            print("Radi print");
                                            print("${date.day.toString().padLeft(2,'0')}"
                                                ".${date.month.toString().padLeft(2,'0')}"
                                                ".${date.year.toString().padLeft(2,'0')}"
                                                ". ${date.hour.toString().padLeft(2,'0')}"
                                                ":${date.minute.toString().padLeft(2,'0')}");
                                            print("Istampao");
                                          },
                                          child: Card(
                                            color: selektovaniIndeks == index? Colors.white24 : Colors.white,
                                              child: ListTile(
                                                title: Text("${date.day.toString().padLeft(2,'0')}"
                                                    ".${date.month.toString().padLeft(2,'0')}"
                                                    ".${date.year.toString().padLeft(2,'0')}"
                                                    ". ${date.hour.toString().padLeft(2,'0')}"
                                                    ":${date.minute.toString().padLeft(2,'0')}",
                                                    style: const TextStyle(
                                                        color: Color(0xFF031620),
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w400
                                                    )
                                                ),

                                              )
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),

                            const Text("Izaberite broj ulaznica: ",
                              style: TextStyle(
                                  color: Color(0xFF031620),
                                  fontSize: 25
                              ),
                            ),
                            const SizedBox(height: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        if(brojUlaznica>1){
                                          brojUlaznica--;
                                        }
                                        else
                                          brojUlaznica = 1;
                                      });
                                    },
                                    child: Icon(Icons.remove),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF900020),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                Text(brojUlaznica.toString(),
                                  style: const TextStyle(
                                    fontSize: 30
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        brojUlaznica++;
                                      });
                                    },
                                    child: Icon(Icons.add),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF900020),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 20,),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(380, 60),
                                  primary: const Color(0xFF031620),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                ),
                                onPressed: () async {
                                  FirebaseFirestore.instance.collection("rezervacija").doc().set({
                                    'predstava': widget.nazivPredstave,
                                    'termin' : date,
                                    'email': user.email,
                                    'brojUlaznica': brojUlaznica

                                  }).then((result) {
                                    print("Uspesno upisano");
                                  }).catchError((error) {
                                    print("Error!");
                                  });

                                  await showDialog(context: context, builder: (context) => AlertDialog(
                                    title: Text("Uspešna rezervacija"),
                                    actions: [
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Color(0xFF900020),
                                          ),
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => BottomBar(indeks: 1,)));
                                          },
                                          child: Text('Ok', style: TextStyle(color: Color(0xFF900020)),))],
                                  ));
                                  Navigator.of(context).pop();

                                },
                                child: Text("Rezerviši"))



                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}
