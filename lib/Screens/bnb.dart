import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/predstave.dart';
import 'package:pozoriste/Screens/profil.dart';



import 'home.dart';

class BottomBar extends StatefulWidget {
  final int indeks;
  const BottomBar({Key? key, required this.indeks}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {


  List stranice = [
    Home(),
    Predstave(),
    Profil()
  ];
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.indeks;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: stranice[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Color(0xFF031620).withOpacity(0.4),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0, //da se ne vidi linija iznad
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF900020),
        enableFeedback: true,
        
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items:
        const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna',
            //backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.theater_comedy_outlined),
              label: 'Predstave',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profil'
          ),

        ],



      ),
    );
  }
}
