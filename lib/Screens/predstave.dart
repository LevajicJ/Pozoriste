import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/dodaj_predstavu.dart';
import 'package:pozoriste/Screens/izmeni_predstavu.dart';
import 'package:pozoriste/Screens/podaci_o_predstavi.dart';


class Predstave extends StatefulWidget {
  const Predstave({Key? key}) : super(key: key);

  @override
  State<Predstave> createState() => _PredstaveState();
}

class _PredstaveState extends State<Predstave> {

  final CollectionReference predstave = FirebaseFirestore.instance.collection('predstave');
  final controller = TextEditingController();
  late String naziv = "";
  int indeks = 1;
  String vrsta = 'sve';

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.5;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predstave'),
        centerTitle: true,
        backgroundColor: const Color(0xFF900020),
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: vidljivost(),
            child: IconButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DodajPredstavu()));
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  naziv = val;
                });
              },
              controller: controller,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF900020),
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF900020),
                ),
                hintText: 'Naziv predstave',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF900020),
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                focusColor: const Color(0xFF900020)
              ),
            ),
          ),
          const Text('Filtriraj predstave:',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF031620)
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      indeks = 1;
                      vrsta = 'sve';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: indeks == 1 ? const Color(0xFF031620) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  child: Text("Sve",
                    style: TextStyle(
                      color: indeks == 1 ? Colors.white : Color(0xFF031620),
                    ),
                  )
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      indeks = 2;
                      vrsta = 'dramska predstava';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: indeks == 2 ? const Color(0xFF031620) : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: Text("Dramske",
                    style: TextStyle(
                      color: indeks == 2 ? Colors.white : Color(0xFF031620),
                    ),
                  )
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      indeks = 3;
                      vrsta = 'dečija predstava';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: indeks == 3 ? const Color(0xFF031620) : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  child: Text("Dečije",
                    style: TextStyle(
                      color: indeks == 3 ? Colors.white : Color(0xFF031620),
                    ),
                  )
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder(
              stream: indeks == 1 ? predstave.snapshots() : predstave.where('vrsta', isEqualTo: vrsta).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                if(streamSnapshot.hasData){
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      if(naziv.isEmpty){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PregledPredstave(documentSnapshot: documentSnapshot)));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 100,
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Image.network(
                                    Text(documentSnapshot['poster']).data.toString(),
                                    loadingBuilder: (context, child, loadingProgress){
                                      if(loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: c_width,
                                  child: Text(documentSnapshot['naziv'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Visibility(
                                  visible: vidljivost(),
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () async{
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => IzmeniPredstavu(documentSnapshot: documentSnapshot)));
                                          },
                                          icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () => showDialog(context: context, builder:(context) =>
                                            AlertDialog(
                                              title: const Text("Da li želiš da obrišeš ovu predstavu?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Ne',
                                                    style: TextStyle(color: Color(0xFF900020)),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    documentSnapshot.reference.delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Da',
                                                    style: TextStyle(color: Color(0xFF900020))
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                        icon: const Icon(Icons.delete),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),

                          ),
                        );
                      }
                      else if(documentSnapshot['naziv'].toString().toLowerCase().startsWith(naziv.toLowerCase())){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PregledPredstave(documentSnapshot: documentSnapshot)));
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 100,
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Image.network(
                                    Text(documentSnapshot['poster']).data.toString(),
                                    loadingBuilder: (context, child, loadingProgress){
                                      if(loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: c_width,
                                  child: Text(documentSnapshot['naziv'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Visibility(
                                  visible: vidljivost(),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async{
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => IzmeniPredstavu(documentSnapshot: documentSnapshot)));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () => showDialog(context: context, builder:(context) =>
                                          AlertDialog(
                                           title: const Text("Da li želiš da obrišeš ovu predstavu?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Ne'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  documentSnapshot.reference.delete();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Da'),
                                              ),
                                            ],
                                          ),
                                          ),
                                        icon: const Icon(Icons.delete),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),

                          ),
                        );
                      }
                      else {
                        return Container();
                      }

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
