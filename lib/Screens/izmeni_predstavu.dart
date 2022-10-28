import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pozoriste/Screens/predstava_text_field.dart';
import 'package:random_string/random_string.dart';

import '../model/predstava.dart';
import 'bnb.dart';

class IzmeniPredstavu extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const IzmeniPredstavu({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<IzmeniPredstavu> createState() => _IzmeniPredstavuState();
}

class _IzmeniPredstavuState extends State<IzmeniPredstavu> {
  bool loading = false;

  late final TextEditingController nazivController = TextEditingController();
  late final TextEditingController opisController = TextEditingController();
  late final TextEditingController rezijaController = TextEditingController();
  late final TextEditingController scenografijaController =
      TextEditingController();
  late final TextEditingController ulogeController = TextEditingController();
  late final TextEditingController vrstaController = TextEditingController();
  String imageUrl = " ";
  String preuzetiUrl = "";
  final _formKey = GlobalKey<FormState>();
  int selectedValue = 1;
  String vrstaPredstave = "";

  //init i dispose zbog memorije, dispose oslobadja memoriju
  @override
  void initState() {
    nazivController.text = widget.documentSnapshot['naziv'];
    opisController.text = widget.documentSnapshot['opis'];
    rezijaController.text = widget.documentSnapshot['rezija'];
    scenografijaController.text = widget.documentSnapshot['scenografija'];
    ulogeController.text = widget.documentSnapshot['uloge'];
    if(widget.documentSnapshot['vrsta'] == 'dramska predstava'){
      selectedValue = 1;
    }
    else if(widget.documentSnapshot['vrsta'] == 'dečija predstava'){
      selectedValue = 2;
    }
    vrstaController.text = widget.documentSnapshot['vrsta'];
    imageUrl = widget.documentSnapshot['poster'];
    super.initState();
  }

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('files/' + randomAlpha(10));

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  Future izmeniPredstavu(
      {required String naziv,
      required String opis,
      required String rezija,
      required String scenografija,
      required String uloge,
      required String slika,
      required String vrsta}) async {
    if (nazivController.text.isNotEmpty &&
        opisController.text.isNotEmpty &&
        rezijaController.text.isNotEmpty &&
        scenografijaController.text.isNotEmpty &&
        ulogeController.text.isNotEmpty) {
      try {
        PredstavaModel predstava = PredstavaModel(
            naziv, opis, slika, rezija, scenografija, uloge, vrsta);

        await FirebaseFirestore.instance
            .collection("predstave")
            .doc(predstava.naziv)
            .update(predstava.toJson());

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Predstava je uspešno izmenjena"),
                  actions: [
                    TextButton(
                        style: TextButton.styleFrom(
                          primary: const Color(0xFF900020),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomBar(indeks: 1,)));
                        },
                        child: const Text(
                          'Ok',
                          style: TextStyle(color: Color(0xFF900020)),
                        ))
                  ],
                ));
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          loading = false;
        });
        return e.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF900020),
        title: const Text("Izmeni predstavu"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/LinijeDole.png"),
                fit: BoxFit.fill,
              )
          ),
          child: Form(
            key: _formKey,
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  pickUploadImage();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 300,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF900020),
                  ),
                  child: imageUrl == " "
                      ? const Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.white,
                        )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                            imageUrl,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                      ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PredstavaTextField(
                      label: 'Naziv',
                      controller: nazivController,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Text("Vrsta predstave:",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    RadioListTile(
                        value: 1,
                        groupValue: selectedValue,
                        title: const Text("Dramska"),
                        activeColor: const Color(0xFF900020),
                        onChanged: (value) => setState(() {
                          selectedValue = 1;
                          vrstaPredstave = "dramska predstava";
                        })
                    ),
                    RadioListTile(
                        value: 2,
                        groupValue: selectedValue,
                        title: const Text("Dečija"),
                        activeColor: const Color(0xFF900020),
                        onChanged: (value) => setState(() {
                          selectedValue = 2;
                          vrstaPredstave = 'dečija predstava';
                        })
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PredstavaTextField(
                      label: 'Opis',
                      controller: opisController,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PredstavaTextField(
                      label: 'Režija',
                      controller: rezijaController,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PredstavaTextField(
                      label: 'Scenografija',
                      controller: scenografijaController,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    PredstavaTextField(
                      label: 'Uloge',
                      controller: ulogeController,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF031620),
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                fixedSize: const Size(380, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                izmeniPredstavu(
                                    naziv: nazivController.text,
                                    opis: opisController.text,
                                    rezija: rezijaController.text,
                                    scenografija: scenografijaController.text,
                                    uloge: ulogeController.text,
                                    slika: imageUrl,
                                    vrsta: vrstaPredstave.toString());
                              },
                              child: const Text('Izmeni predstavu'),
                            ),
                    ),
                  ],
                ),
              ),

              //dugme dodaj predstavu
            ]),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? text) {
    setState(() {
      loading = false;
    });
    if (text == null || text.trim().isEmpty) {
      return "Ovo polje je obavezno";
    }
    return null;
  }
}
