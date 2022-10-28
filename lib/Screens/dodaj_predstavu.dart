import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pozoriste/Screens/bnb.dart';
import 'package:pozoriste/Screens/predstava_text_field.dart';
import 'dart:io';
import 'package:random_string/random_string.dart';
import 'package:pozoriste/model/predstava.dart';


class DodajPredstavu extends StatefulWidget {
  const DodajPredstavu({Key? key}) : super(key: key);

  @override
  State<DodajPredstavu> createState() => _DodajPredstavuState();
}

class _DodajPredstavuState extends State<DodajPredstavu> {
  bool loading = false;

  late final TextEditingController nazivController;
  late final TextEditingController opisController;
  late final TextEditingController rezijaController;
  late final TextEditingController scenografijaController;
  late final TextEditingController ulogeController;
  late final TextEditingController vrstaController;
  String imageUrl = " ";
  String preuzetiUrl = "";
  final _formKey = GlobalKey<FormState>();
  int selectedValue = 1;
  String vrstaPredstave = "";

  //init i dispose zbog memorije, dispose oslobadja memoriju
  @override
  void initState() {
    nazivController = TextEditingController();
    opisController = TextEditingController();
    rezijaController = TextEditingController();
    scenografijaController = TextEditingController();
    ulogeController = TextEditingController();
    vrstaController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nazivController.dispose();
    opisController.dispose();
    rezijaController.dispose();
    scenografijaController.dispose();
    ulogeController.dispose();
    vrstaController.dispose();
    super.dispose();
  }

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref =
        FirebaseStorage.instance.ref().child('files/' + randomAlpha(10));

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  Future dodajPredstavu(
        {
          required String naziv,
          required String opis,
          required String rezija,
          required String scenografija,
          required String uloge,
          required String slika,
          required String vrsta
        }
      ) async{

    setState(() {
      loading = true;
    });

    if(nazivController.text.isNotEmpty &&
        opisController.text.isNotEmpty &&
        rezijaController.text.isNotEmpty &&
        scenografijaController.text.isNotEmpty &&
        ulogeController.text.isNotEmpty &&
        imageUrl != " "
    )
    {
      try{
        PredstavaModel predstava = PredstavaModel(naziv, opis, slika, rezija, scenografija, uloge, vrsta);

        await FirebaseFirestore.instance.collection("predstave").doc(predstava.naziv).set(predstava.toJson());

        await showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text("Predstava je uspešno dodata"),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: const Color(0xFF900020),
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomBar(indeks: 1,)));
                },
                child: const Text('Ok', style: TextStyle(color: Color(0xFF900020)),))],
        ));
        Navigator.of(context).pop();
      }
       catch (e){
        setState(() {
          loading = false;
        });
        return e.toString();
      }
    }
    else{
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Neuspešno dodavanje predstave'),
        content: Text("Proverite da li ste dodali sliku"),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          } ,
              child: const Text('Ok', style: TextStyle(color: Color(0xFF900020) )))],
      ));
      setState(() {
        loading = false;
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF900020),
        title: const Text("Dodaj predstavu"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        /*physics: const BouncingScrollPhysics(),*/
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
                          vrstaPredstave = 'dramska predstava';
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
                                if(_formKey.currentState != null && _formKey.currentState!.validate()){
                                  dodajPredstavu(naziv: nazivController.text,
                                      opis: opisController.text,
                                      rezija: rezijaController.text,
                                      scenografija: scenografijaController.text,
                                      uloge: ulogeController.text,
                                      slika: imageUrl,
                                      vrsta: vrstaPredstave.toString()
                                  );
                                }


                              },
                              child: const Text('Dodaj predstavu'),
                            ),
                    ),
                  ],
                ),
              ),


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
