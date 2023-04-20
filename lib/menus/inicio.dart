import 'package:avesdgobd/paginas/fotos.dart';
import 'package:avesdgobd/paginas/listadatos.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MiInicio();
  }
}

class MiInicio extends State <Inicio> {
  int _selectedIndex = 0;
  final List <Widget> _children = [
    ListaDatos(),
    Fotos(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black12,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Fotos'
          ),
        ],
      ),
    );
  }
}