import 'package:agrotest/history.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible;
  TextEditingController emailController;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    _passwordVisible = false;
    emailController= TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Color(0xff85a335),

        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.all(25),
                    color: Color(0xff85a335),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child:SingleChildScrollView(
                      child:  Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Ingresa a Trigal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 40),
                              child: Text(
                                "Sistema de gestion de casos",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey.withOpacity(0.9)),

                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(

                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          child: TextFormField(
                                            controller: emailController,
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 15.0, color: Colors.black),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              hintText: 'Correo Electrónico',
                                              filled: true,
                                              fillColor: Color(0xffFAFAFA),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 14.0, bottom: 6.0, top: 8.0),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffFFB74D)),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffFAFAFA)),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            obscureText: !_passwordVisible,
                                            //This will obscure text dynamically
                                            autofocus: false,
                                            style: TextStyle(
                                                fontSize: 15.0, color: Colors.black),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              hintText: 'Contraseña',
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  _passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Color(0xff85a335),
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    _passwordVisible =
                                                    !_passwordVisible;
                                                  });
                                                },
                                              ),
                                              filled: true,
                                              fillColor: Color(0xffFAFAFA),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 14.0, bottom: 6.0, top: 8.0),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffFFB74D)),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffFAFAFA)),
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 30),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(30.0)),
                                                    onPressed: () {
                                                      int sede=0;
                                                      if(emailController.text=="fe@calidad.com"){
                                                        sede=2;
                                                      }else{
                                                        sede=1;
                                                      }
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => HistoryPage(sede: sede)),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 15,bottom: 15),
                                                      child: Text(
                                                        'INGRESAR',
                                                        style:
                                                        TextStyle(color: Colors.white,fontWeight: FontWeight.w400),
                                                      ),
                                                    ),
                                                    color: Color(0xffFFB74D),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
