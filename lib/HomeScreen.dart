import 'package:flutter/material.dart';
import 'ClientData.dart';

class HomeScreen extends StatefulWidget {
  static String route = "/HomeScreen";

  HomeScreen({Key key, this.title = "Sistema de préstamos"}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String btnPressed = "";
  TextEditingController userInputController = TextEditingController(text: "",);
  List _results = null;

  void showBlock(String bloque){
    setState(() {
      _results = null;
      btnPressed = bloque;
    });
  }

  void dispose() {
    userInputController.dispose();
    super.dispose();
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
                return showFormulario(context, (){
                  ClientData.getInstance().removeByDoc(_results[index]["nroDoc"]);
                }, (_results != null  ? _results : ClientData.getInstance().data)[index],);
              }
              else{
                return showFormulario(context, (){
                  ClientData.getInstance().removeByIndex(index);
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
              });
            }
          ),
        ),
      )
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
            /*Row(
              children: [*/
                TextField(),
                TextField(),
                TextField(),
                TextField(),
              ],
            ),
            /*Row(
              children: [
                TextField(),
                TextField(),
                TextField(),
                TextField(),
              ],
            )
          ]
        )*/
      )
    );
  }

  Widget showFormulario(context, onDeleteCallback, cliente){
    return Visibility(
      visible: (btnPressed == "eliminar" || btnPressed == "consultar"),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(color: Colors.green[100]),
        child: Column(
          children:[
            Row(
              children:[
                Text(cliente["nroDoc"]),
                Text("show form"),
                Text("show form"),
                Text("show form"),
              ]
            ),
            Row(
              children:[
                Text("show form"),
                Text("show form"),
                Text("show form"),
                Visibility(
                  visible: btnPressed == "eliminar",
                  child: ElevatedButton(
                    child: Text("Borrar"),
                    onPressed: onDeleteCallback,
                  )
                )
              ]
            ),
          ]
        )
      )
    );
  }
}