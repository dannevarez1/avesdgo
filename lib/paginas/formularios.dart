import 'package:avesdgobd/clases/datos.dart';
import 'package:avesdgobd/menus/inicio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Formulario extends StatefulWidget {
  @override
  State <StatefulWidget> createState() {
    return MiFormulario();
  }
}

class MiFormulario extends State <Formulario> {
  final controladorNombreComun = TextEditingController();
  final controladorNombreCientifico = TextEditingController();
  final controladorId = TextEditingController();
  final controladorNombreCreador = TextEditingController();
  Datos? dat = Datos("", "", "", "");
  List<Datos> _datos = [];

  Future <void> guardarDatos(String nombreComun, String nombreCientifico, String nombreCreador, String foto) async {
    Future.delayed(
        Duration(seconds: 10) , () async{
      final datos = await FirebaseFirestore.instance.collection('avesdgo');
      return datos.add({
        'nombrecomun' : nombreComun,
        'nombrecientifico' : nombreCientifico,
        'nombrecreador' : nombreCreador,
        'foto' : foto
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos de la Ave"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10.00)),
                TextField(
                  controller: controladorNombreComun,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.add_circle),
                      border:OutlineInputBorder(),
                      labelText: "Nombre Comun",
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.00)),
                TextField(
                  controller: controladorNombreCientifico ,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.add_circle),
                      border:OutlineInputBorder(),
                      labelText: "Nombre Cientifico"
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.00)),
                TextField(
                  controller: controladorNombreCreador ,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      border:OutlineInputBorder(),
                      labelText: "Creditos"
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.00)),
                ElevatedButton(onPressed: (){
                  if (validarNombreCientifico(controladorNombreCientifico.text)) {
                    dat!.nombrecomun = controladorNombreComun.text;
                    dat!.nombrecientifico = controladorNombreCientifico.text;
                    dat!.nombrecreador = controladorNombreCreador.text;
                    dat!.foto = Datos.downloadURL;
                    print (dat!.foto);

                    guardarDatos(dat!.nombrecomun, dat!.nombrecientifico, dat!.nombrecreador,  dat!.foto);
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Inicio();
                        }),
                        ModalRoute.withName('/')
                    );
                  } else {
                    mostrarError(
                        context,
                        "Debe contener sólo letras minúsculas entre paréntesis y un espacio",
                        "Nombre Científico"
                    );
                  }
                }, child: Text('Registrar'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green))
                    )
              ],
            ),
          )
      ),
    );
  }
}

// Expresión regular para el nombre científico
bool validarNombreCientifico(String cadena) {
  RegExp exp = new RegExp(r'^\([a-z]+. [a-z]*\)$');
  if (cadena.isEmpty) {
    return false;
  } else if (!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}

//Método para mostrar el error de los textfields
void mostrarError(BuildContext context, String mensaje, String campo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¡Error!', style: TextStyle(fontSize: 20.0)),
        content: Text("Verifica el $campo.\n\n$mensaje"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
