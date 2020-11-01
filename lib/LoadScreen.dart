import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'ClientData.dart';

class LoadScreen extends StatefulWidget {
  LoadScreen({Key key, this.title}) : super(key:key);

  final String title;

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  @override
  void initState(){
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    print("load data");
    var c = ClientData.getInstance();
    print("client data instanced");
    await c.loadData();
    print("loaded data");
    Navigator.pushNamed(context, HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cargando info...',
            ),
          ],
        ),
      ),
    );
  }
}
