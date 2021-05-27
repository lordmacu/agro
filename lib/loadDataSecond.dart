import 'dart:convert';

import 'package:agrotest/daos/CommentDao.dart';
import 'package:agrotest/daos/ControlDao.dart';
import 'package:agrotest/daos/DropdownDao.dart';
import 'package:agrotest/daos/EmployeeDao.dart';
import 'package:agrotest/daos/FlowerDao.dart';
import 'package:agrotest/daos/LaborDao.dart';
import 'package:agrotest/daos/ProcesesDao.dart';
import 'package:agrotest/daos/SedesDao.dart';
import 'package:agrotest/daos/VaritiesDao.dart';
import 'package:agrotest/history.dart';
import 'package:agrotest/login.dart';
import 'package:agrotest/mock.dart';
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Processes.dart';
import 'package:agrotest/models/Sedes.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/Types.dart';
import 'package:agrotest/models/Varieties.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:agrotest/DB.dart';
import 'package:sqfly/sqfly.dart';

class LoadDataSecondPage extends StatefulWidget {
  int sede;

   LoadDataSecondPage({Key key, this.title,this.sede}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoadDataSecondPage createState() => _LoadDataSecondPage();
}

class _LoadDataSecondPage extends State<LoadDataSecondPage> {

  String url = "https://calidad.smartcompanies.com.co";

  bool isgetDropdowns = false;
  bool isgetControls = false;
  bool isgetComments = false;
  bool isgetFlowers = false;
  bool isgetProceses = false;
  bool isgetSedes = false;
  bool isgetVarities = false;
  bool isgetEmployee = false;

  @override
  void initState() {
    //   loadData();

    checkCreation();
  }

  checkCreation() async {

    loadData();
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

  Future loadData() async {
    final sqfly = await Sqfly.initialize(
      /// database named
      name: 'datdacdddddddddddsdddsdd',
      // database version
      version: 2,
      logger: false,

      daos: [
        EmployeeDao(),
        DropdownDao(),
        ControlDao(),
        CommentDao(),
        ProcesesDao(),
        SedesDao(),
        FlowerDao(),
        VaritiesDao(),
        LaborDao()
      ],
    );

    await sqfly<EmployeeDao>().destroyAll(); // insertAll
    await sqfly<DropdownDao>().destroyAll(); // insertAll
    await sqfly<ControlDao>().destroyAll(); // insertAll
    await sqfly<CommentDao>().destroyAll(); // insertAll
    await sqfly<SedesDao>().destroyAll(); // insertAll
    await sqfly<FlowerDao>().destroyAll(); // insertAll
    await sqfly<VaritiesDao>().destroyAll(); // insertAll
    await sqfly<ProcesesDao>().destroyAll(); // insertAll

    SharedPreferences prefs = await SharedPreferences.getInstance();

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

    sqfly<EmployeeDao>().createAll(employs); // insertAll

    //await DB.saveEmploys(employs);

    setState(() {
      isgetEmployee = true;
    });

    var uriResponse = await client.get(Uri.parse('${url}/getDropdowns'));
    var response = jsonDecode(uriResponse.body);

    List<Dropdown> dropArray = [];
    for (var i = 0; i < response.length; i++) {
      try {
        Dropdown dropdown = Dropdown();
        if (response[i]["flower_id"] == "") {
          dropdown.flowerId = 0;
        } else {
          dropdown.flowerId = int.parse(response[i]["flower_id"]);
        }

        if (response[i]["desplegable"] == "") {
          dropdown.desplegable = "0";
        } else {
          dropdown.desplegable = response[i]["desplegable"];
        }
        dropdown.processId = int.parse(response[i]["process_id"]);
        dropdown.itemId = int.parse(response[i]["item_id"]);
        dropdown.sedeId = int.parse(response[i]["sede_id"]);
        dropdown.name = (response[i]["item"]["name"]);
        dropdown.process = (response[i]["process"]["name"]);
        dropArray.add(dropdown);
      } catch (e) {
        print("aquiii esta el error mano ${response[i]}");
      }
    }

    print("total  ${dropArray}");
    sqfly<DropdownDao>().createAll(dropArray); // insertAll

    // await DB.saveDropdowns(dropArray);

    setState(() {
      isgetDropdowns = true;
    });

    var getDropdowns = await client.get(Uri.parse('${url}/getControls'));
    var responsegetDropdowns = jsonDecode(getDropdowns.body);

    List<Controls> controlsArray = [];
    for (var i = 0; i < responsegetDropdowns.length; i++) {
      Controls dropdown = Controls();
      dropdown.orderControl = responsegetDropdowns[i]["order_control"];
      dropdown.processId = responsegetDropdowns[i]["process_id"];
      dropdown.sedeId = responsegetDropdowns[i]["sede_id"];
      dropdown.name = responsegetDropdowns[i]["name"];
      dropdown.itemId = responsegetDropdowns[i]["item_id"];
      dropdown.flowerId = responsegetDropdowns[i]["flower_id"];
      dropdown.id = responsegetDropdowns[i]["id"];
      controlsArray.add(dropdown);
    }

    sqfly<ControlDao>().createAll(controlsArray); // insertAll

    //  await DB.saveControls(controlsArray);

    setState(() {
      isgetControls = true;
    });

    var getComments = await client.get(Uri.parse('${url}/getComments'));
    var responsegetComments = jsonDecode(getComments.body);

    List<Comments> comments = [];
    for (var i = 0; i < responsegetComments.length; i++) {
      Comments dropdown = Comments();
      dropdown.name = responsegetComments[i]["name"];
      dropdown.id = responsegetComments[i]["id"];
      dropdown.processId = responsegetComments[i]["process_id"];
      comments.add(dropdown);
    }

    sqfly<CommentDao>().createAll(comments); // insertAll

    setState(() {
      isgetComments = true;
    });
    var getFlowers = await client.get(Uri.parse('${url}/getFlowers'));
    var responsegetFlowers = jsonDecode(getFlowers.body);
    List<Flowers> flowersArray = [];
    for (var i = 0; i < responsegetFlowers.length; i++) {
      Flowers dropdown = Flowers();
      dropdown.name = responsegetFlowers[i]["name"];
      dropdown.sedeId = "${responsegetFlowers[i]["sede_id"]}";
      dropdown.id = responsegetFlowers[i]["id"];

      flowersArray.add(dropdown);
    }
    sqfly<FlowerDao>().createAll(flowersArray); // insertAll

    //await DB.saveFlowers(flowersArray);

    setState(() {
      isgetFlowers = true;
    });

    var getProceses = await client.get(Uri.parse('${url}/getProceses'));
    var responsegetProceses = jsonDecode(getProceses.body);

    List<Processes> processArray = [];
    for (var i = 0; i < responsegetProceses.length; i++) {
      Processes dropdown = Processes();
      dropdown.name = responsegetProceses[i]["name"];
      dropdown.id = responsegetProceses[i]["id"];
      processArray.add(dropdown);
    }

    sqfly<ProcesesDao>().createAll(processArray); // insertAll

    // await DB.saveProcesess(processArray);

    setState(() {
      isgetProceses = true;
    });

    var getSedes = await client.get(Uri.parse('${url}/getSedes'));
    var responsegetSedes = jsonDecode(getSedes.body);

    List<Sedes> sedesArray = [];
    for (var i = 0; i < responsegetSedes.length; i++) {
      Sedes dropdown = Sedes();
      dropdown.name = responsegetSedes[i]["name"];
      dropdown.id = responsegetSedes[i]["id"];
      sedesArray.add(dropdown);
    }
    sqfly<SedesDao>().createAll(sedesArray); // insertAll

    //await DB.saveSedes(sedesArray);

    setState(() {
      isgetSedes = true;
    });

    var getVarities = await client.get(Uri.parse('${url}/getVarities'));
    var responsegetVarities = jsonDecode(getVarities.body);

    List<Varieties> varietiesArray = [];
    for (var i = 0; i < responsegetVarities.length; i++) {
      Varieties dropdown = Varieties();
      dropdown.name = responsegetVarities[i]["name"];
      dropdown.flowerId = responsegetVarities[i]["flower_id"];
      dropdown.id = responsegetVarities[i]["id"];
      dropdown.sedeId = responsegetVarities[i]["sede_id"];
      varietiesArray.add(dropdown);
    }
    sqfly<VaritiesDao>().createAll(varietiesArray); // insertAll

    setState(() {
      isgetVarities = true;
    });

    bool isLoadedTables =
        await prefs.setBool("loadGDddddddedfdfddneddradl1sd", true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage(sede: widget.sede,)),
    );
  }

  createComments(processStep) async {
    Mock mock = Mock();

    var comments = await mock.comments(processStep);
    comments.forEach((element) async {
      Comments employ = Comments();
      employ.name = element["name"];
      employ.processId = element["process_step"];
      await employ.save();
    });
    print("comments   created  step  ${processStep}");
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
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Desplegables", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetDropdowns
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Controles", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetControls
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Comentarios", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetComments
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Flores", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetFlowers
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("procesos", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetProceses
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("sedes", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetSedes
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("variedades", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetVarities
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Container(
                child: null,
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("empleados", style: TextStyle(color: Colors.white)),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: isgetEmployee
                        ? Text(
                            "Ok",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("...", style: TextStyle(color: Colors.white)),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
