import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/predstave.dart';

import 'bnb.dart';

class Izvodjenje extends StatefulWidget {
  final String nazivPredstave;
  const Izvodjenje({Key? key, required this.nazivPredstave}) : super(key: key);

  @override
  State<Izvodjenje> createState() => _IzvodjenjeState();
}

class _IzvodjenjeState extends State<Izvodjenje> {
  DateTime now = DateTime.now();
  late DateTime dateTime;

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17, 0);




  @override
  Widget build(BuildContext context) {

    dateTime =  DateTime(now.year, now.month, now.day, 17, 00);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dodaj izvođenje predstave"),
        backgroundColor: const Color(0xFF900020),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 10,
                  child: Container(
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const Image( image: AssetImage("assets/izvodjenje.png"),),
                        ListTile(
                            title: Center(
                              child: Text(widget.nazivPredstave,
                                style: const TextStyle(
                                  color: Color(0xFF031620),
                                  fontSize: 30,
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Text("Izaberi termin: ",
                              style: TextStyle(
                                  color: Color(0xFF031620),
                                  fontSize: 25
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF900020),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                              child: Icon(Icons.calendar_today_rounded),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) => Theme(
                                      data: ThemeData().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF900020),
                                            onPrimary: Colors.white,
                                            surface: Color(0xFF900020),
                                            onSurface: Colors.black,
                                          )
                                      ), child: child!,
                                    )
                                );

                                if(newDate == null) return;
                                setState(() => date = newDate);

                                TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
                                    builder: (context, child) => Theme(
                                      data: ThemeData().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF900020),                                            )
                                      ), child: child!,
                                    )
                                );

                                if(newTime == null) return;
                                final newDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    newTime.hour,
                                    newTime.minute
                                );
                                setState(() => date = newDateTime);

                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Text(
                          '${date.day.toString().padLeft(2,'0')}.${date.month.toString().padLeft(2,'0')}.${date.year}. ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 20),
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
                                 FirebaseFirestore.instance.collection("repertoar").doc().set({
                                  'predstava': widget.nazivPredstave,
                                  'termin' : date
                                }).then((result) {
                                  print("Uspesno upisano");
                                }).catchError((error) {
                                  print("Error!");
                                });

                                await showDialog(context: context, builder: (context) => AlertDialog(
                                  title: Text("Uspešna dodavanje"),
                                  content: Text('Dodato je izvođenje predstave'),
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
                            child: Text("Dodaj u bazu")
                        )

                      ],
                    ),
                  )

              ),
            ),
          ],

        ),
      ),
    );
  }



  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if(date == null) return;

    TimeOfDay? time = await pickTime();
    if(time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );
    setState(() {
      this.dateTime = dateTime;
      print(this.dateTime);
      print(dateTime);

    });
    print(dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022,9,1),
      lastDate: DateTime(2022,9,30),
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );
}
