import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pozoriste/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:email_validator/email_validator.dart';
import 'package:pozoriste/Screens/text_field.dart';

class Registracija extends StatefulWidget {
  const Registracija({Key? key}) : super(key: key);
  @override
  State<Registracija> createState() => _RegistracijaState();
}

class _RegistracijaState extends State<Registracija> {

  var loading = false;

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _imeController;
  late final TextEditingController _prezimeController;
  late final TextEditingController _emailController;
  late final TextEditingController _lozinkaController;
  late final TextEditingController _potvrdaLozinkeController;

  //init i dispose zbog memorije, dispose oslobadja memoriju
  @override
  void initState() {
    _imeController = TextEditingController();
    _prezimeController = TextEditingController();
    _emailController = TextEditingController();
    _lozinkaController = TextEditingController();
    _potvrdaLozinkeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _imeController.dispose();
    _prezimeController.dispose();
    _emailController.dispose();
    _lozinkaController.dispose();
    _potvrdaLozinkeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Pozadina.png"),
                fit: BoxFit.fill,
              )
          ),
          child: Form(
            key: _formKey,
            child: Container(

              //color: Colors.amberAccent,
              child: Column(

                  children: [
                    SizedBox(height: 200,),

                    //IME
                    CustomTextField(label: 'Ime', controller: _imeController,
                      validator: _requiredValidator,),
                    SizedBox(height: 15,),

                    CustomTextField(label: 'Prezime', controller: _prezimeController,
                      validator: _requiredValidator,),
                    SizedBox(height: 15,),

                    CustomTextField(label: 'E-mail', controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _requiredValidator,),
                    SizedBox(height: 15,),

                    CustomTextField(label: 'Lozinka', controller: _lozinkaController,
                        validator: _passwordValidator,
                        password: true),
                    SizedBox(height: 15,),

                    CustomTextField(label: 'Potvrda lozinke', controller: _potvrdaLozinkeController,
                        validator: _confirmPasswordValidator,
                        password: true),
                    SizedBox(height: 15,),

                    //dugme registruj se
                    SizedBox(
                      child: loading ? _CircularProgressIndicator() : ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF031620),

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
                            EmailValidator.validate(_emailController.text);
                            _signUp();
                          }
                        },
                        child: const Text('Registruj se'),

                      ),
                    ),

                    TextButton(
                        style: TextButton.styleFrom(
                          primary: Color(0xFF031620),
                        ),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: const Text("Imaš nalog? Prijavi se")
                    )



                  ]
              ),
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

  String? _passwordValidator(String? passwordText){
    setState(() {
      loading = false;
    });
    if(passwordText == null || passwordText.trim().isEmpty){
      return "Ovo polje je obavezno";
    }
    if(passwordText.length < 6){
      return 'Lozinka mora imati bar 6 karaktera';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? confirmPasswordText){
    if(confirmPasswordText == null || confirmPasswordText.trim().isEmpty){
      return "Ovo polje je obavezno";
    }
    if(_lozinkaController.text != confirmPasswordText){
      return 'Lozinke se ne podudaraju';
    }
    return null;
  }

  Future _signUp() async{

    setState(() {
      loading = true;
    });

    final preuzetoIme = _imeController.text;
    final preuzetoPrezime = _prezimeController.text;
    final preuzetEmail = _emailController.text;
    final preuzetaLozinka = _lozinkaController.text;

    if(_imeController.text.isNotEmpty &&
        _prezimeController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _lozinkaController.text.isNotEmpty &&
        _potvrdaLozinkeController.text.isNotEmpty)
    {
      try{
        final korisnik = await firebaseAuth.createUserWithEmailAndPassword(
          email: preuzetEmail,
          password: preuzetaLozinka,
        );

        await FirebaseFirestore.instance.collection("korisnici").doc(korisnik.user?.uid).set({
          'ime': preuzetoIme,
          'prezime': preuzetoPrezime,
          'email': preuzetEmail,
          'lozinka': preuzetaLozinka
        });

        await showDialog(context: context, builder: (context) => AlertDialog(
          title: Text("Uspešna registracija"),
          content: Text('Vaš nalog je kreiran'),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xFF900020),
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Ok', style: TextStyle(color: Color(0xFF900020)),))],
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
      case 'email-already-in-use':
        messageToDisplay = 'Već postoji nalog sa ovom e-mail adresom';
        break;
      case 'invalid-email':
        messageToDisplay = 'E-mail adresa koju ste uneli nije ispravna';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'Ova operacija nije dozvoljena';
        break;
      case 'weak-password':
        messageToDisplay = 'Lozinka je slaba';
        break;
      default:
        messageToDisplay = 'Došlo je do greške';
        break;
    }

    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Registracija nije moguća'),
      content: Text(messageToDisplay),
      actions: [
        TextButton(onPressed: () {
        Navigator.of(context).pop();
        } ,
          child: Text('Ok', style: TextStyle(color: Color(0xFF900020) )))],
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