import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_chooser/file_chooser.dart';

class ClientData extends ChangeNotifier{
  static ClientData _instance;
  String _path;
  static ClientData getInstance(){
    if (_instance == null){
      _instance = ClientData();
    }
    return _instance;
  }

  dynamic data = [];
  final RegExp reg = new RegExp(r"([0-9]|\+)");

  ClientData();

  void removeByIndex(int index){
    data.removeAt(index);
    notifyListeners();
    print("remove by index");
    print(data);
    updateFile();
  }

  void removeByDoc(String doc){
    var it = find(doc);
    var itemFound = (it != null && it.length > 0) ? it[0] : null;
    data.remove(itemFound);
    notifyListeners();
    print("remove by doc");
    print(data);
    updateFile();
  }

  Future<bool> add(nroDoc, nombre, telefono, tipoPrestamo, monto, interes, fecha) async{
    //Es valido?
    /*if (!(nroDoc.length >= 6 &&
        nombre.length > 0 &&
        telefono.length > 6 && telefono.split("").every((element) =>reg.hasMatch(element)) &&
        tipoPrestamo != "" &&
        monto != "" && monto > 0 &&
        interes != "" && interes > 0 &&
        fecha != "" &&
        find(nroDoc).length == 0)){
          return false;
        }
    */
    
    data.add({
      "nroDoc" : nroDoc,
      "nombre" : nombre,
      "telefono" : telefono,
      "tipoPrestamo" : tipoPrestamo,
      "monto" : monto,
      "interes" : interes,
      "fecha" : fecha
    });

    notifyListeners();
    await updateFile();
    return true;
  }

  List<dynamic> find(param){
    print("find");
    print(data);
    var r = data.where((cliente) => (cliente["nroDoc"] != null && cliente["nroDoc"].contains(param)) || cliente["nombre"].contains(param)).toList();
    print("find: $r");
    return r;
  }

  void updateFile() async{
    String content = json.encode( data);
    File f = File("$_path");
    await f.create();
    await f.writeAsString(content);
    print("Actualizado: $_path");
  }

  Future<void> loadData() async{
    //Chequear si existe el archivo 'path_json'
    //De no existir crearlo con la siguiente info:
    /*
    []
    Cada item seguirá la siguiente estructura:
    {
      "nroDoc" : nroDoc,
      "nombre" : nombre,
      "telefono" : telefono,
      "tipoPrestamo" : tipoPrestamo,
      "monto" : monto,
      "interes" : interes,
      "fecha" : fecha
    }
    */

    //Cargar el archivo
    FileChooserResult f = await showOpenPanel();
    while (f.canceled){
      f = await showOpenPanel();
      print("showopenpanel ${f.canceled}");
    }
    _path = f.paths[0];
    File file = File('${f.paths[0]}');
    String jsonstring = await file.readAsString();
    data = json.decode(jsonstring);
    notifyListeners();
    print(data);
    return;
  }
}