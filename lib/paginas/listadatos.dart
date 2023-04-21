import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Aves Durango'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('avesdgo').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>; //nuevo paquete
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('avesdgo')
                      .doc(document.id);
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(data['foto']),
                        ListTile(
                          title: Text("Nombre común: " + data['nombrecomun'], style: TextStyle(fontSize: 20.0),),
                          //leading: Icon(Icons.favorite,color: Colors.red,),
                          subtitle: Text(
                            "Nombre científico: " +
                                data['nombrecientifico'] +
                                "\n" +
                                "Fotografiada por: " +
                                data['nombrecreador'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            actualizarDatos(
                                context,
                                data['nombrecomun'],
                                data['nombrecientifico'],
                                data['nombrecreador'],
                                document.id);
                          },
                          child: Text('Editar Datos'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ), // Texto del botón de edición
                        ),
                        ElevatedButton(
                          onPressed: () {
                            eliminarDatos(context, document.id);
                          },
                          child: Text('Eliminar Tarjeta'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ), // Texto del botón de edición
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }
}

void eliminarDatos(BuildContext context, String uid) {
  showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("¿Estás seguro de que deseas eliminar esta tarjeta?"),
          actions: [
            TextButton(
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Eliminar tarjeta",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                //Se agrega el metodo eliminarRegistro
                eliminarDocumento(uid);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Future<void> eliminarDocumento(String uid) async {
  final CollectionReference baseDatos =
      FirebaseFirestore.instance.collection('avesdgo');
  Future.delayed(Duration(seconds: 3), () {
    return baseDatos.doc(uid).delete();
  });
  print("Se ha eliminado la tarjeta");
}

//Método para mostrar el error de los textfields
void actualizarDatos(BuildContext context, String nombrecomun,
    String nombrecientifico, String nombrecreador, String documentoId) {
  final controladorNombreComun = TextEditingController();
  final controladorNombreCientifico = TextEditingController();
  final controladorNombreCreador = TextEditingController();
  controladorNombreComun.text = nombrecomun;
  controladorNombreCientifico.text = nombrecientifico;
  controladorNombreCreador.text = nombrecreador;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Captura de nuevo los datos de la tarjeta',
            style: TextStyle(fontSize: 20.0)),
        content: Column(
          children: [
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombreComun,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.add_circle),
                  border: OutlineInputBorder(),
                  labelText: "Nombre Común"),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombreCientifico,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.add_circle),
                  border: OutlineInputBorder(),
                  labelText: "Nombre Cientifico"),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombreCreador,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(),
                  labelText: "Créditos"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Guardar"),
            onPressed: () {
              if (validarNombreCientifico(controladorNombreCientifico.text)) {
                actualizarDocumento(
                    documentoId,
                    controladorNombreComun.text,
                    controladorNombreCientifico.text,
                    controladorNombreCreador.text);
                Navigator.of(context).pop();
              } else {
                mostrarError(
                    context,
                    "Debe contener sólo letras minúsculas entre paréntesis y un espacio",
                    "Nombre Científico");
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> actualizarDocumento(String documentoId, String nombrecomun,
    String nombrecientifico, String nombrecreador) async {
  print(documentoId);
  Future.delayed(Duration(seconds: 5), () async {
    try {
      await FirebaseFirestore.instance
          .collection('avesdgo')
          .doc(documentoId)
          .update({
        'nombrecomun': nombrecomun,
        'nombrecientifico': nombrecientifico,
        'nombrecreador': nombrecreador,
      });
      print('Datos actualizados correctamente');
    } catch (error) {
      print('Error al actualizar los datos: $error');
      throw error;
    }
  });
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

//Método para mostrar el error del nombre cientifico
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
