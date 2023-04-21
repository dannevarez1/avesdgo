import 'dart:io';
import 'package:avesdgobd/clases/datos.dart';
import 'package:avesdgobd/paginas/formularios.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Fotos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MisFotos();
  }
}

class MisFotos extends State<Fotos> {
  final picker = ImagePicker();
  File? imageFile; //Tipo de dato nulo hasta que se le asigne valor
  String reffoto = "";
  String nomfoto = "";

  Datos? dat = Datos("", "", "", "");

  Future<void> showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione opcion para foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: Text("Galeria"),
                      onTap: () {
                        abrirGaleria(context);
                      }),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Cámara"),
                    onTap: () {
                      abrirCamara(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void abrirGaleria(BuildContext context) async {
    final picture = await picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture!.path);
      Navigator.of(context).pop();
    });
  }

  void abrirCamara(BuildContext context) async {
    final picture = await picker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture!.path);
      Navigator.of(context).pop();
    });
  }

  void enviarImagen() async {
    firebase_storage.FirebaseStorage.instance
        .ref(reffoto + '.jpg')
        .putFile(imageFile!);
    print("Enviada__________________");
  }

  Future<void> visualizafoto() async {
    Future.delayed(Duration(seconds: 7), () async {
      String urll = await firebase_storage.FirebaseStorage.instance
          .ref(reffoto + ".jpg")
          .getDownloadURL();
      Datos.downloadURL = urll.toString();
      print("----------->" + Datos.downloadURL);
    });
  }

  Widget mostrarImagen() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: 500,
        height: 500,
      );
    } else {
      return Text("Seleccione un imagen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mostrarImagen(),
            Padding(padding: new EdgeInsets.all(30.00)),
            IconButton(
              icon: Icon(Icons.send_and_archive),
              onPressed: () {
                nomfoto = (DateFormat.yMd().add_Hms().format(DateTime.now()))
                    .toString();
                reffoto = "aves/" +
                    (nomfoto
                        .replaceAll("/", "_")
                        .replaceAll(" ", "_")
                        .replaceAll(":", ""));
                enviarImagen();
                print("---------------" + nomfoto);
                print("---------------" + reffoto);
                visualizafoto();
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Formulario();
                }));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showSelectionDialog(context);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
