import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/registracija.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pozoriste/Screens/text_field.dart';

import 'bnb.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();

}

class Login extends StatelessWidget{
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Home();
          }
          else {
            return const LoginScreen();

          }
        },
        ),
    );
  }

}

class _LoginState extends State<LoginScreen>{

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _lozinkaController = TextEditingController();
  var loading = false;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/PozadinaRegistracija.png"),
          fit: BoxFit.cover,
        )
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                //email
                const SizedBox( height: 300,),
                CustomTextField(label: "Email", controller: _emailController,
                validator: _requiredValidator,
                keyboardType: TextInputType.emailAddress
                ),
                const SizedBox(height: 15,),

                //lozinka
                CustomTextField(label: 'Lozinka', controller: _lozinkaController,
                validator: _requiredValidator,
                password: true,
                ),
                const SizedBox(height: 15,),

                //dugme prijavi se
                SizedBox(
                  child: loading ? _CircularProgressIndicator() : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF031620),
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      fixedSize: const Size(380, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),

                    ),

                    onPressed: (){
                      setState(() {
                        loading = true;
                      });
                      if(_formKey.currentState != null && _formKey.currentState!.validate()){
                        _prijaviSe();
                      }
                    },
                    child: const Text('Prijavi se'),

                  ),
                ),


                TextButton(
                    style: TextButton.styleFrom(
                      primary: const Color(0xFF031620),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Registracija()));
                    },
                    child: const Text("Nemaš nalog? Registruj se")
                ),


              ],
            ),
          ),
        ),
      ),

    );

  }

  String? _requiredValidator(String? text){
    setState(() {
      loading = false;
    });
    if(text == null || text.trim().isEmpty) {
      return "Ovo polje je obavezno";
    }
    return null;
  }

  Future _prijaviSe() async{
    setState(() {
      loading = true;
    });

    if(_emailController.text.isNotEmpty && _lozinkaController.text.isNotEmpty)
    {
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _lozinkaController.text);

        await showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text("Uspešno prijavljivanje"),

          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: const Color(0xFF900020),
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BottomBar(indeks: 0,)));
                },
                child: const Text('Ok', style: TextStyle(color: Color(0xFF900020)),))],
        ));
        Navigator.of(context).pop();
      }
      on firebase_auth.FirebaseAuthException catch (e){
        setState(() {
          loading = false;
        });
        _handleSignUpError(e);
      }
    }

  }

  void _handleSignUpError(firebase_auth.FirebaseAuthException e){
    String messageToDisplay;
    switch(e.code){
      //nije u formi email-a
      case 'invalid-email':
        messageToDisplay = 'Neispravan format e-mail adrese';
        break;
      case 'user-not-found':
        messageToDisplay = 'Ne postoji nalog sa ovom e-mail adresom';
        break;
      case 'wrong-password':
        messageToDisplay = 'Pogrešna lozinka';
        break;
      default:
        messageToDisplay = 'Neispravna kombinacija e-mail adrese i lozinke';
        break;
    }

    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Neuspešno prijavljivanje'),
      content: Text(messageToDisplay),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        } ,
            child: const Text('Ok', style: TextStyle(color: Color(0xFF900020) )))],
    ));
  }



}


class _CircularProgressIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Color(0xFF900020),

    );
  }

}