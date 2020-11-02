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
  String filter = "";
  List _results = null;

  void showBlock(String bloque){
    setState(() {
      _results = null;
      btnPressed = bloque;
    });
  }

  void setConsulta(){
    userInputController.text = "";
    nroDocController.text = "";
    nombreController.text = "";
    telefonoController.text = "";
    tipoPrestamoController.text = "";
    montoController.text = "";
    fechaController.text = "";
    interesController.text = "";
    showBlock("consultar");
  }

  void dispose() {
    userInputController.dispose();
    nroDocController.dispose();
    nombreController.dispose();
    telefonoController.dispose();
    tipoPrestamoController.dispose();
    montoController.dispose();
    fechaController.dispose();
    interesController.dispose();
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

  TextEditingController nroDocController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController tipoPrestamoController = TextEditingController();
  TextEditingController interesController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController fechaController = TextEditingController();

  Widget inputForm(TextEditingController tec, String label){
    return Expanded(
      flex: 1,
      child:TextField(
        controller: tec,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
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
                inputForm(nroDocController, "Ingrese nro de documento"),
                inputForm(nombreController, "Ingrese nombre y apellido"),
                inputForm(telefonoController,"Ingrese nro de teléfono"),
                inputForm(tipoPrestamoController, "Ingrese tipo de prestamo"),
              ],
            ),
            Row(
              children: [
                inputForm(montoController,"Ingrese monto"),
                inputForm(interesController,"Ingrese tasa"),
                inputForm(fechaController,"Ingrese fecha"),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    child: Text("Guardar"),
                    onPressed: () async {
                      await ClientData.getInstance().add(
                          nroDocController.text,
                          nombreController.text,
                          telefonoController.text,
                          tipoPrestamoController.text,
                          montoController.text,
                          interesController.text,
                          fechaController.text
                      );
                      setConsulta();
                      print(ClientData.getInstance().data);
                    },
                  ),
                )
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
}