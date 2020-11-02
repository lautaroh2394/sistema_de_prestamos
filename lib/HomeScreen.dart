import 'package:flutter/material.dart';
import 'ClientData.dart';
import 'dart:collection';

class HomeScreen extends StatefulWidget {
  static String route = "/HomeScreen";

  HomeScreen({Key key, this.title = "Sistema de préstamos"}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    initControllers();
    super.initState();
  }
  String btnPressed = "";
  TextEditingController userInputController = TextEditingController(text: "",);
  String filter = "";
  List _results = null;
  bool _valid = false;
  final regNro = new RegExp(r"^([0-9]|\+){6,8}$");
  final regLetras = new RegExp(r"^[a-zA-Z\ áéíóúÁÉÍÓÚñ]*$");
  final regTel = new RegExp(r"^[0-9]*$");
  final regMonto = new RegExp(r"^[0-9]*(\.)?[0-9]*$");
  final regFecha = new RegExp(r"^[0-9]{2}/[0-9]{2}/[0-9]{2}$");
  Map<String,dynamic> controllers;

  void initControllers(){
    controllers = {
      "nroDoc":{
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regNro.hasMatch(value),
      },
      "nombre" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regLetras.hasMatch(value),
      },
      "telefono" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regTel.hasMatch(value),
      },
      "tipoPrestamo" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regLetras.hasMatch(value),
      },
      "monto" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regMonto.hasMatch(value),
      },
      "interes" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regMonto.hasMatch(value),
      },
      "fecha" : {
        "controller":TextEditingController(),
        "color": Colors.teal,
        "isValid" : (String value) => regFecha.hasMatch(value),
      }
    };
  }

  void showBlock(String bloque){
    setState(() {
      _results = null;
      btnPressed = bloque;
    });
  }

  void setConsulta(){
    controllers.forEach((key, value) {value["controller"].text = "";});
    setState(()=>{
    _valid = false
    });
    showBlock("consultar");
  }

  void dispose() {
    controllers.forEach((key, value) {value["controller"].dispose();});
    super.dispose();
  }
  
  void updateValid(){
    bool v = false;
    if (controllers.entries.map((entry) {
      return entry.value["isValid"](entry.value["controller"].text);
    }).every((v) => v)){
      v = true;
    }
    setState(()=>{
      _valid = v
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: opciones(context),
            ),
            Expanded(
              flex: 9,
              child: bloques(context),
            )
          ],
        ),
      ),
    );
  }

  Widget opciones(context){
    return Container(
      decoration:BoxDecoration(
        color: Colors.grey[400],
        ),
      child: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Consultar"),
                    onPressed: ()=> showBlock("consultar"),
                  )
                )
            )
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Nuevo"),
                    onPressed: ()=> showBlock("nuevo"),
                  )
                )
            )
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Eliminar"),
                    onPressed: ()=> showBlock("eliminar"),
                  )
                )
            )
          )
        ],
      )
    );
  }

  Widget bloques(context){
    return Column(
      children: [
        userinput(context),
        formulario(context),
        Expanded(
          child: ListView.builder(
            itemCount: (_results != null ? _results.length : ClientData.getInstance().data.length),
            itemBuilder: (context, index){
              print("buld listveiw");
              if (_results != null){
                return showFormulario(
                  context,
                  (){
                    //Lo correcto sería esperar a un Future para evitar posibles problemas con la actualizacion del archivo
                    ClientData.getInstance().removeByDoc(_results[index]["nroDoc"]);
                    //Actualizo la lista. Lo correcto sería usar provider.
                    var r = ClientData.getInstance().find(filter);
                    setState(() {
                      _results = r;
                    });
                    },
                  (_results != null  ? _results : ClientData.getInstance().data)[index],
                );
              }
              else{
                return showFormulario(context, (){
                  //Lo correcto sería esperar a un Future para evitar posibles problemas con la actualizacion del archivo
                  ClientData.getInstance().removeByIndex(index);
                  //Actualizo la lista. Lo correcto sería usar provider.
                  var r = ClientData.getInstance().find(filter);
                  setState(() {
                    _results = r;
                  });
                },
                (_results != null ? _results : ClientData.getInstance().data)[index],);
              }
            }
          )
        )
      ],
    );
  }

  Widget userinput(context){
    return Visibility(
      visible: (btnPressed == "consultar" || btnPressed == "eliminar"),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Center(
          child: TextField(
            controller: userInputController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Ingrese nombre o número de documento",
            ),
            onChanged: (value) {
              setState(() {
                _results = ClientData.getInstance().find(value);
                filter = value;
              });
            }
          ),
        ),
      )
    );
  }

  Widget inputForm(String key, String label, {String helper : null}){
    return Expanded(
      flex: 1,
      child:TextField(
        controller: controllers[key]["controller"],
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: controllers[key]["color"],
            ),
          ),
          labelText: label,
          helperText: helper,
        ),
        onChanged: (String v){
          Color c = null;
          if (controllers[key]["isValid"](v)){
            c = Colors.green;
          }
          else{
            c = Colors.red;
          }
          setState(()=>{
            controllers[key]["color"] = c
          });
          print(controllers);
          updateValid();
        },
      ),
    );
  }

  Widget formulario(context){
    return Visibility(
      visible: (btnPressed == "nuevo"),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: Colors.green[100]),
        child: Column(
          children:[
            Row(
              children: [
                inputForm("nroDoc", "Ingrese nro de documento"),
                inputForm("nombre", "Ingrese nombre y apellido"),
                inputForm("telefono","Ingrese nro de teléfono"),
                inputForm("tipoPrestamo", "Ingrese tipo de prestamo"),
              ],
            ),
            Row(
              children: [
                inputForm("monto","Ingrese monto"),
                inputForm("interes","Ingrese tasa"),
                inputForm("fecha","Ingrese fecha (DD/MM/AA)"),
                guardarButton(),
              ],
            )
          ]
        )
      )
    );
  }

  Widget clienteForm(title, value){
    return Expanded(
      child: Column(
        children:[
         Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children:[
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child:Text(title),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child:Container(
                      margin: EdgeInsets.symmetric(horizontal:5),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      alignment: Alignment.center,
                      child: Text(value)
                    )
                ),
              ]
            )
          )
        ]
      )
    );
  }

  Widget showFormulario(context, onDeleteCallback, cliente){
    return Visibility(
      visible: (btnPressed == "eliminar" || btnPressed == "consultar"),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: Colors.green[100]),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                    children:[
                      Row(
                          children:[
                            clienteForm("DOC:",cliente["nroDoc"]),
                            clienteForm("NOM:",cliente["nombre"]),
                            clienteForm("TEL:",cliente["telefono"]),
                            clienteForm("TIPO:",cliente["tipoPrestamo"]),
                          ]
                      ),
                      Row(
                          children:[
                            clienteForm("MONTO:",cliente["monto"]),
                            clienteForm("TASA", cliente["interes"]),
                            clienteForm("FECHA", cliente["fecha"]),
                            clienteForm("",""),
                          ]
                      ),
                    ]
                )
            ),
            Column(
              children: [
                Visibility(
                    visible: btnPressed == "eliminar",
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        child: Text("Borrar"),
                        onPressed: onDeleteCallback,
                      )
                    )
                )
              ],
            )
          ]
        )
      )
    );
  }

  Widget guardarButton(){
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        child: Text("Guardar"),
        onPressed: _valid ? () async {
          await (ClientData.getInstance()).add(
            controllers["nroDoc"]["controller"].text,
            controllers["nombre"]["controller"].text,
            controllers["telefono"]["controller"].text,
            controllers["tipoPrestamo"]["controller"].text,
            controllers["monto"]["controller"].text,
            controllers["interes"]["controller"].text,
            controllers["fecha"]["controller"].text,
          );
          setConsulta();
          print(ClientData.getInstance().data);
        } : null,
      ),
    );
  }
}