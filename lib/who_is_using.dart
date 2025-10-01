import 'package:flutter/material.dart';
import "bus_choice_page.dart"; 
import 'login_page.dart'; 

class WhoIsUsingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
      ***REMOVED***
    ***REMOVED***
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
            ***REMOVED***
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.directions_bus,
                  size: 120,
                  color: Colors.white,
            ***REMOVED***
          ***REMOVED***
              SizedBox(height: 30),

              Text(
                'Quem está usando?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                ***REMOVED***
                  ],
            ***REMOVED***
                textAlign: TextAlign.center,
          ***REMOVED***
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BusChoicePage()),
                ***REMOVED***
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
              ***REMOVED***
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
              ***REMOVED***
            ***REMOVED***
                child: Text('Sou Aluno'),
          ***REMOVED***
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                ***REMOVED***
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
              ***REMOVED***
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
              ***REMOVED***
            ***REMOVED***
                child: Text('Sou Motorista'),
          ***REMOVED***
            ],
      ***REMOVED***
    ***REMOVED***
  ***REMOVED***
  ***REMOVED***
  }
}
