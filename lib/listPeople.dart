
import 'package:agrotest/helpers.dart';
import 'package:agrotest/daos/EmployeeDao.dart';
import 'package:agrotest/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfly/sqfly.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:agrotest/models/Employs.dart';

import 'package:flutter/material.dart';
class ListPeople extends StatefulWidget {
  ListPeople({Key key,this.listPeopleArray}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  List<String> listPeopleArray = [];


  @override
  _ListPeople createState() => _ListPeople();
}

class _ListPeople extends State<ListPeople> {
  List<String> savedListPeopleArray = [];

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      savedListPeopleArray=widget.listPeopleArray;
    });


    print("aqui esta la lista de cosas   ${widget.listPeopleArray}");
  }
  Future loadData() async {
    String url = "https://calidad.smartcompanies.com.co";

    final sqfly = await Sqfly.initialize(
      /// database named
      name: 'datdacdddddddddddsdddsdd',
      // database version
      version: 2,
      logger: false,

      daos: [
        EmployeeDao(),

      ],
    );

    _onLoading();

    var client = http.Client();

    var getEmployee = await client.get(Uri.parse('${url}/getEmployee'));
    var responsegetEmployee = jsonDecode(getEmployee.body);

    List<Employs> employs = [];
    for (var i = 0; i < responsegetEmployee.length; i++) {
      Employs dropdown = Employs();
      dropdown.name = responsegetEmployee[i]["name"];
      dropdown.sede = responsegetEmployee[i]["sede_id"];
      dropdown.id = responsegetEmployee[i]["id"];
      dropdown.type = responsegetEmployee[i]["type_position"];
      dropdown.position = responsegetEmployee[i]["position"];
      employs.add(dropdown);
    }

    sqfly<EmployeeDao>().destroyAll();// insertAll

   await sqfly<EmployeeDao>().createAll(employs); // insertAll


    SharedPreferences prefs = await SharedPreferences.getInstance();

    int sede=prefs.getInt("sede");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage(sede: sede)),
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Cargando",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Expanded(child: TextFormField(
                onChanged: (value){
                  Helpers helpers = Helpers();

                  List<String> people= helpers.filterStrings(widget.listPeopleArray, value);
                  setState(() {
                    if(people.length>0){
                      savedListPeopleArray=people;
                    }else{
                      savedListPeopleArray=widget.listPeopleArray;
                    }
                  });

                },
              ),
              flex: 7,),
              Expanded(child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                  child: Icon(Icons.refresh),
                ),
                onTap: (){
                  loadData();

                },
              ),flex: 1,)
            ],
          ),
        ),
      ),
      body:ListView.builder
        (
          itemCount: savedListPeopleArray.length,

          itemBuilder: (BuildContext ctxt, int index) {
            return InkWell(
              onTap: (){
                Navigator.pop(context, savedListPeopleArray[index]);
              },
              child: Container(
                padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child: Text(savedListPeopleArray[index],style: TextStyle(fontSize: 17),),
              ),
            );
          }
      )
    );
  }



}