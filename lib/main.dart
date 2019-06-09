import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _resultado = "Informe seus dados!";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetField() {
    weightController.text = ""; // n precisa usar setState nos controladores
    heightController.text = "";
    setState(() {
      _resultado = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calcular() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      //Validação

      double imc = weight / (height * height);

      if (imc < 18.5) {
        _resultado =
            " Abaixo do peso, Risco de doença: Normal ou Elevado (IMC = ${imc.toStringAsPrecision(3)})";
      } else if (imc >= 18.5 && imc < 25.0) {
        _resultado =
            " Normal, Risco de doença: Pouco elevado (IMC = ${imc.toStringAsPrecision(3)})";
      } else if (imc >= 25.0 && imc < 30.0) {
        _resultado =
            " Sobrepeso, Risco de doença: Normal (IMC = ${imc.toStringAsPrecision(3)})";
      } else if (imc >= 30.0 && imc < 35) {
        _resultado =
            " Obesidade, Risco de doença: Elevado (IMC = ${imc.toStringAsPrecision(3)})";
      } else if (imc >= 35.0 && imc < 40) {
        _resultado =
            " Obesidade Severa, Risco de doença: Muito Elevado (IMC = ${imc.toStringAsPrecision(3)})";
      } else {
        // imc >=40
        _resultado =
            " Obesidade Mórbida, Risco de doença: Muitíssimo elevado (IMC = ${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _resetField();
                })
          ],
        ),
        backgroundColor: Color.fromARGB(255, 210, 223, 249),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 120,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Peso em Kg",
                          labelStyle: TextStyle(color: Colors.blue)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                      controller: weightController,
                      validator: (peso) {
                        if (peso.isEmpty) {
                          return "Insira seu Peso";
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Altura em CM",
                          labelStyle: TextStyle(color: Colors.blue)),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                      controller: heightController,
                      validator: (altura) {
                        if (altura.isEmpty) {
                          return "Insira sua Altura";
                        }
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: Container(
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _calcular();
                              }
                              SystemChannels.textInput.invokeMethod(
                                  'TextInput.hide'); // esconder teclado
                            },
                            child: Text(
                              "Calcular",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                        )),
                    Text(
                      _resultado,
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    )
                  ],
                ))));
  }
}
