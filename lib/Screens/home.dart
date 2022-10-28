import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/podaci_o_predstavi.dart';

import 'bnb.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final CollectionReference predstave = FirebaseFirestore.instance.collection('predstave');
  final CollectionReference vesti = FirebaseFirestore.instance.collection('vesti');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF900020),
        automaticallyImplyLeading: false,
        title: const Text('Početna strana'),
        centerTitle: true,
      ),
      body:
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Izdvajamo",
                      style: TextStyle(
                        color: Color(0xFF031620),
                        fontSize: 25,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BottomBar(indeks: 1,)));
                        },
                        child: const Text('Sve predstave'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF031620),
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                    )
                  ],
                ),


                Container(
                  height: 300,
                  width: double.maxFinite,
                  child: StreamBuilder(
                    stream: predstave.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                      if(streamSnapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else {
                        return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index){
                          final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 15, top: 10),
                            width: 200,
                            height: 300,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PregledPredstave(documentSnapshot: documentSnapshot)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
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
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30,),
                const Text("Vesti",
                  style: TextStyle(
                      color: Color(0xFF031620),
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  ),
                ),

                Container(
                  //width: double.maxFinite,
                  height: 300,

                  child: StreamBuilder(
                    stream: vesti.snapshots(),
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
                          return Card(
                              child: ListTile(
                                  title: Text(documentSnapshot['naslov'],
                                  style: const TextStyle(
                                    color: Color(0xFF031620),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                    )
                                  ),
                                subtitle: Text(documentSnapshot['tekst'],
                                  style:  TextStyle(
                                    color: Color(0xFF031620).withOpacity(0.7),
                                    fontSize: 17
                                  ),
                                ),
                              )
                          );
                        },
                      );
                      }
                    },
                  ),
                ),
                SizedBox(height: 5,)

              ],
            ),
          ),
        ),



    );
  }


}
