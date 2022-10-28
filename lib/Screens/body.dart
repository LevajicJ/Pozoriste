import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/rezervisane_karte.dart';


import 'login.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    CollectionReference users =
        FirebaseFirestore.instance.collection('korisnici');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: CustomShape(),
                      child: Container(
                        height: 150,
                        color: const Color(0xFF900020),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 160,
                            width: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(0xFF900020),
                                  ),
                              ),
                            child: ClipOval(
                              child: data['slika']!= null ? Image.network(
                                  Text(data['slika']).data.toString(),
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.account_circle_sharp ,
                                      size: 160,
                                      color: Colors.grey,
                                  ),
                            )
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const ListTile(
                                  title: Text(
                                    'Vaši podaci:',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Ime:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(' ${data['ime']} ',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Prezime:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(' ${data['prezime']} ',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        'Email:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(' ${data['email']} ',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF031620),
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              fixedSize: const Size(380, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child:
                            const Text("Rezervisane karte", style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RezervisaneKarte()));
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF031620),
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              fixedSize: const Size(380, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child:
                            const Text("Odjavi se", style: TextStyle(fontSize: 18)),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                      (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}


class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double visina = size.height;
    double sirina = size.width;
    path.lineTo(0, visina - 100);
    path.quadraticBezierTo(sirina / 2, visina, sirina, visina - 100);
    path.lineTo(sirina, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
