import 'package:flutter/material.dart';

import 'package:pozoriste/Screens/login.dart';
import 'package:pozoriste/Screens/registracija.dart';

class Background extends StatelessWidget{
  //final Widget child;

  const Background({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/PozadinaLinije.png"),
            width: size.width
          ),
          Positioned(
              top: 150,
              right: 0,
              child: Image.asset("assets/LogoPozoriste.png"),
              width: size.width
          ),
          Positioned(
              top: 500,
              width: 350,
              child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                      backgroundColor: const Color(0xFF031620),
                      padding: const EdgeInsets.all(20),
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 25, fontFamily: 'Cinzel')
                  ),

                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Prijavi se")
              ),

          ),
          Positioned(
            top: 600,
            width: 350,
            child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    backgroundColor: Color(0xFF031620),
                    padding: const EdgeInsets.all(20),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 25, fontFamily: 'Cinzel')
                ),

                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registracija()));
                },
                child: const Text("Registruj se")
            ),

          ),


        ],
      ),
    );
  }


}