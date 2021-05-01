import 'dart:convert';

import 'package:agrotest/daos/CommentDao.dart';
import 'package:agrotest/daos/ControlDao.dart';
import 'package:agrotest/daos/EmployeeDao.dart';
import 'package:agrotest/daos/FlowerDao.dart';
import 'package:agrotest/daos/LaborDao.dart';
import 'package:agrotest/daos/VaritiesDao.dart';
import 'package:agrotest/dialogs/muestraDialog.dart';
import 'package:agrotest/helpers.dart';
import 'package:agrotest/listPeople.dart';
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Labor.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/Supervisor.dart';
import 'package:agrotest/models/TipoMuestra.dart';
import 'package:agrotest/models/Types.dart';
import 'package:agrotest/models/Varieties.dart';
import 'package:agrotest/models/muestrasModel.dart';
import 'package:agrotest/selectTipoMuestra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:group_button/group_button.dart';
import 'package:after_layout/after_layout.dart';
import 'package:toast/toast.dart';
import 'package:agrotest/DB.dart';
import 'package:sqfly/sqfly.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.sede}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final int sede;

  @override
  _HistoryPage createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage>
    with AfterLayoutMixin<HistoryPage> {
  PanelController _panelController;
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible;
  bool isPanelOpen = false;
  var sqfly = null;

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

  int sede_id = 0;
  List<String> suggestionsSupervisor = [];
  List<String> suggestionsOperario = [];
  List<String> suggestions = [];
  List<String> selectedButtons = [];
  List<Varieties> varieties = [];
  String selectedVariety = "Variedad";
  List<Labor> labores = [];
  List<Labor> actualLabores = [];

  Future initDb() async {
    sqfly = await Sqfly.initialize(
      /// database named
      name: 'datdacdddddddddddsdddsdd',
      // database version
      version: 2,
      logger: false,

      daos: [
        EmployeeDao(),
        VaritiesDao(),
        FlowerDao(),
        ControlDao(),
        CommentDao(),
        LaborDao(),
      ],
    );

    getAllEmploys();
  }

  @override
  void initState() {
    sede_id = widget.sede;

    print("esta es la sede final ${sede_id}");
    _passwordVisible = false;
    _panelController = PanelController();
    myFocusNode = FocusNode();
    initializeDateFormatting();
    Intl.defaultLocale = "es_Es"; //sets global,
    var newFormat = new DateFormat.yMMMMd('es_Es');
    initDb();
  }

  List<String> typesArray = [];

  List<int> SelectedTypes = [];
  List<int> selectedComments = [];
  List<String> subtypesArray = [];
  List<String> commentsArray = [];

  List<muestrasModel> muestrasArray = [];

  int currentStep = 0;
  int selectedItem = 0;
  int muestrasCount = 0;

  String block = "Bloque";
  String flower = "Tipo de flor";

  int subControl = 0;
  String subControlText = "";

  int modificable = 0;

  final TextEditingController _supervisorTextEdition = TextEditingController();
  String _selectedType;

  final TextEditingController _typeTextEdition = TextEditingController();
  String _selectedSupervisor;

  final TextEditingController _colaboradorTextEdition = TextEditingController();
  String _selectedColaborador;

  final TextEditingController _aseguradorTextEdition = TextEditingController();
  String _selectedAsegurador;
  FocusNode myFocusNode;

  showPickerFlowers(BuildContext context) async {
    List<Flowers> flowers =
        await sqfly<FlowerDao>().where({'sede_id': '${sede_id}'}).toList();

    List<String> bloques = [];
    flowers.forEach((element) {
      bloques.add("${element.name}");
    });

    new Picker(
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        adapter: PickerDataAdapter<String>(pickerdata: bloques),
        hideHeader: true,
        title: new Text("Seleccione Flor"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            flower = picker.getSelectedValues()[0];
          });
          getAllTypes();
          getVaries(flower);
        }).showDialog(context);
  }

  showPickerVarieties(BuildContext context) async {
    List<String> bloques = [];
    varieties.forEach((element) {
      bloques.add("${element.name}");
    });

    new Picker(
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        adapter: PickerDataAdapter<String>(pickerdata: bloques),
        hideHeader: true,
        title: new Text("Seleccione Flor"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            selectedVariety = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }

  getVaries(flower) async {
    List<Flowers> flowers = await sqfly<FlowerDao>()
        .where({'sede_id': '${sede_id}', 'name': '${flower}'}).toList();
    var allVariess =
        await sqfly<VaritiesDao>().where({"flower_id": flowers[0].id}).toList();
    setState(() {
      selectedVariety = "Variedad";

      varieties = allVariess;
    });
  }

  showPickerItemControl(BuildContext context) async {
    List<String> control = [];
    control.add("Empaque");
    control.add("Surtido");
    control.add("Suncho");

    new Picker(
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        adapter: PickerDataAdapter<String>(pickerdata: control),
        hideHeader: true,
        title: new Text("Seleccione Control"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            var selected = picker.getSelectedValues()[0];
            subControlText = selected;
            if (selected == "Empaque") {
              subControl = 3;
            }
            if (selected == "Surtido") {
              subControl = 4;
            }
            if (selected == "Suncho") {
              subControl = 5;
            }
            getAllTypes();
          });
        }).showDialog(context);
  }

  showPickerBlocks(BuildContext context) {
    List<String> bloques = [];

    for (var i = 1; i < 101; i++) {
      bool blockExist = false;

      for (var b = 0; b < actualLabores.length; b++) {
        if ("Bloque ${i}" == actualLabores[b].blocks) {
          blockExist = true;
        }
      }

      /*  if (!blockExist) {

      }*/
      bloques.add("Bloque ${i}");
    }

    new Picker(
        cancelText: "Cancelar",
        confirmText: "Confirmar",
        adapter: PickerDataAdapter<String>(pickerdata: bloques),
        hideHeader: true,
        title: new Text("Seleccione Bloque"),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            block = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }

  Widget StepOne() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        // Create the SelectionScreen in the next step.
                        MaterialPageRoute(
                            builder: (context) => ListPeople(
                                listPeopleArray: suggestionsSupervisor)),
                      );
                      if (result != null) {
                        setState(() {
                          this._selectedSupervisor = result;
                        });
                      } else {
                        setState(() {
                          this._selectedSupervisor = null;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: this._selectedSupervisor == null
                        ? Text("Supervisor")
                        : Text("${this._selectedSupervisor}"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        // Create the SelectionScreen in the next step.
                        MaterialPageRoute(
                            builder: (context) =>
                                ListPeople(listPeopleArray: suggestions)),
                      );
                      if (result != null) {
                        setState(() {
                          this._selectedColaborador = result;
                        });
                      } else {
                        setState(() {
                          this._selectedColaborador = null;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: this._selectedColaborador == null
                        ? Text("Colaborador")
                        : Text("${this._selectedColaborador}"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        // Create the SelectionScreen in the next step.
                        MaterialPageRoute(
                            builder: (context) =>
                                ListPeople(listPeopleArray: suggestions)),
                      );
                      if (result != null) {
                        setState(() {
                          this._selectedAsegurador = result;
                        });
                      } else {
                        setState(() {
                          this._selectedAsegurador = null;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: this._selectedAsegurador == null
                        ? Text("Asegurador")
                        : Text("${this._selectedAsegurador}"),
                  ),
                ),
                selectedItem == 4
                    ? Container(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color:
                              subControl == 0 ? Colors.grey : Color(0xff85a335),
                          child: Text(
                            subControl == 0
                                ? "Item de control"
                                : subControlText,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showPickerItemControl(context);
                          },
                        ),
                      )
                    : Container(),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          selectedItem < 3
                              ? RaisedButton(
                                  color: block == "Bloque"
                                      ? Colors.grey
                                      : Color(0xff85a335),
                                  onPressed: () {
                                    showPickerBlocks(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Text(
                                    "${block}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                          selectedItem < 3
                              ? RaisedButton(
                                  color: flower == "Tipo de flor"
                                      ? Colors.grey
                                      : Color(0xff85a335),
                                  onPressed: () async {
                                    await showPickerFlowers(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Text(
                                    "${flower}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      varieties.length > 0
                          ? RaisedButton(
                              color: selectedVariety == "Variedad"
                                  ? Colors.grey
                                  : Color(0xff85a335),
                              onPressed: () async {
                                await showPickerVarieties(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text(
                                "${selectedVariety}",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                child: MaterialButton(
                  onPressed: () {
                    goback();
                  },
                  textColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                ),
              ),
              Container(
                child: RaisedButton(
                  color: Color(0xffFFB74D),
                  onPressed: () {
                    if (selectedItem == 6) {
                      if (this._formKey.currentState.validate()) {
                        this._formKey.currentState.save();
                        gonext();
                      }
                    } else if (selectedItem == 4) {
                      if (subControl != 0) {
                        if (this._formKey.currentState.validate()) {
                          this._formKey.currentState.save();
                          gonext();
                        }
                      }
                    } else {
                      if (flower != "Tipo de flor") {
                        if (this._formKey.currentState.validate()) {
                          this._formKey.currentState.save();
                          gonext();
                        }
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    "Siguiente",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  goback() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  gonext() {
    setState(() {
      currentStep = currentStep + 1;
    });

    print("asdfsd fa ${currentStep}");
  }

  formatDate(date) {
    var now = new DateTime.now();
    var parsedDate = DateTime.parse(date);

    var formatter = new DateFormat('dd MMMM yyyy - hh:mm');
    return formatter.format(parsedDate);
    return "adsfas";
/*
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted);*/
  }

  String url = "https://calidad.smartcompanies.com.co";

  loadDataServer() async {
    var client = http.Client();

    List<Labor> labores = await sqfly<LaborDao>().where({"state": 0}).toList();

    var getEmployee = await client.post(Uri.parse('${url}/saveData'),
        body: {"data": jsonEncode(labores)});

    labores.forEach((element) async {
      sqfly<LaborDao>().updateLabor(element.id);
    });

    print("esta es la cantidad ${labores}");
    getAllLabores();
  }

  borrarLabor(Labor labor) async {
    var client = http.Client();

    var getEmployee = await client.post(Uri.parse('${url}/deleteLabor'),
        body: {"id": "${labor.id}", "user_id": "1"});
  }

  showDialogMuestra(int muestra) async {
    SelectedTypes = [];
    subtypesArray = [];

    muestrasModel result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectTipoMuestra(
                flower: flower,
                muestra: muestra,
                muestrasArray: muestrasArray[muestra],
                sede_id: sede_id,
                selectedItem: selectedItem,
                subControl: subControl,
                typesArray: typesArray,
              )),
    );

    if (result != null) {
      muestrasArray[muestra] = result;
      print("aqui este es el resultado ${muestrasArray}");
    }
  }

  List<Widget> showItemsControl() {
    List<Widget> muestras = [];

    for (var i = 0; i < muestrasCount; i++) {
      muestras.add(GestureDetector(
        onTap: () {
          this._typeTextEdition.text = "";

          this._selectedType = "";
          showDialogMuestra(i);
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Muestra"),
                  Text(
                    "${i + 1}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            muestrasArray[i] != null
                ? Container(
                    child: muestrasArray[i].type == "Ramo conforme"
                        ? Icon(
                            Icons.check_circle,
                            color: Color(0xff85a335),
                          )
                        : null,
                  )
                : null
          ],
        ),
      ));
    }

    muestras.add(GestureDetector(
      onTap: () {
        setState(() {
          muestrasCount = muestrasCount + 1;
          muestrasModel muestra = muestrasModel();
          muestra.type = "";
          muestra.subtypes = [];
          muestrasArray.add(muestra);
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff85a335)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Agregar",
              style: TextStyle(color: Color(0xff85a335)),
            ),
            Icon(
              Icons.add,
              color: Color(0xff85a335),
            )
          ],
        ),
      ),
    ));

    return muestras;
  }

  formatMuestrasArray(List<muestrasModel> muestras) {
    List<muestrasModel> muestrasString = [];

    muestras.forEach((element) {
      List<String> tipos = [];
      element.subtypes.forEach((elements) {
        tipos.add("${elements.tipo} - ${elements.desplegable}");
      });
      element.subtypesString = tipos;

      muestrasString.add(element);
    });

    return muestrasString;
  }

  Widget StepFour() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Comentarios",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                child: GroupButton(
                  isRadio: false,
                  spacing: 10,
                  selectedButtons: selectedButtons,
                  onSelected: (index, isSelected) {
                    final person = selectedComments
                        .firstWhere((element) => element == index, orElse: () {
                      return null;
                    });

                    if (person != null) {
                      selectedComments.remove(person);
                    } else {
                      selectedComments.add(index);
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  buttons: commentsArray,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                child: MaterialButton(
                  onPressed: () {
                    goback();
                  },
                  textColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                ),
              ),
              Container(
                child: RaisedButton(
                  color: Color(0xffFFB74D),
                  onPressed: () {
                    Labor labor = Labor();
                    labor.comments = jsonEncode(selectedComments);
                    labor.muestras =
                        jsonEncode(formatMuestrasArray(muestrasArray));
                    labor.flowerType = flower;
                    labor.blocks = block;
                    labor.asegurator = _selectedAsegurador;
                    labor.colaborator = _selectedColaborador;
                    labor.supervisor = _selectedSupervisor;
                    labor.process = selectedItem;
                    labor.variety = selectedVariety;
                    labor.state = 0;
                    labor.subProcess = subControl;
                    labor.date = DateTime.now().toString();

                    sqfly<LaborDao>().create(labor); // insertAll

                    getAllLabores();

                    setState(() {
                      _selectedSupervisor = null;
                      _selectedColaborador = null;
                      _selectedAsegurador = null;
                      block = "Bloque";
                      flower = "Tipo de flor";
                      muestrasArray = [];
                      selectedComments = [];
                      selectedButtons = [];
                      currentStep = 0;
                      selectedItem = 0;
                      muestrasCount = 0;
                    });

                    _panelController.close();
                    loadDataServer();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget StepThree() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                "Items de Control",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Container(
              child: Expanded(
                child: GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 4,
                  // Generate 100 widgets that display their index in the List.
                  children: showItemsControl(),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                child: MaterialButton(
                  onPressed: () {
                    goback();
                  },
                  textColor: Colors.white,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                ),
              ),
              selectedItem == 1 || selectedItem == 2
                  ? Container(
                      child: RaisedButton(
                        color: Color(0xffFFB74D),
                        onPressed: () {
                          int canNext = 0;
                          muestrasArray.forEach((element) {
                            if (element.type.length == 0) {
                              print("muestras array ${element}");

                              canNext = canNext + 1;
                            }
                          });
                          gonext();
                          /* if (canNext == 0) {
                            gonext();
                          } else {
                            Toast.show(
                                "Por favor complete las muestras", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }*/
                          //
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Siguiente",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      child: RaisedButton(
                        color: Color(0xffFFB74D),
                        onPressed: () {
                          Labor labor = Labor();
                          labor.comments = jsonEncode(selectedComments);
                          labor.muestras = jsonEncode(muestrasArray);
                          labor.flowerType = flower;
                          labor.blocks = block;
                          labor.asegurator = _selectedAsegurador;
                          labor.colaborator = _selectedColaborador;
                          labor.supervisor = _selectedSupervisor;
                          labor.process = selectedItem;
                          labor.subProcess = subControl;
                          labor.date = DateTime.now().toString();
                          labor.state = 0;

                          sqfly<LaborDao>().create(labor); // insertAll

                          getAllLabores();

                          setState(() {
                            _selectedSupervisor = null;
                            _selectedColaborador = null;
                            _selectedAsegurador = null;
                            block = "Bloque";
                            flower = "Tipo de flor";
                            muestrasArray = [];
                            selectedComments = [];
                            selectedButtons = [];
                            currentStep = 0;
                            selectedItem = 0;
                            muestrasCount = 0;
                          });

                          _panelController.close();
                          loadDataServer();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Guardar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget parseSubType(subtypes) {
    /// var subtypesJson= jsonDecode(subtypes);
    print("estos son los subtypes ${subtypes}");
    return Text("${subtypes}", style: TextStyle(fontSize: 16));
  }

  Widget StepTwo() {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 20, right: 30),
      child: Center(
        child: GridView.count(
          shrinkWrap: true,

          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedItem = 1;
                  currentStep = 1;
                });
                getAllTypes();

                findLaboresByProcess();
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedItem == 1
                                ? Color(0xffFFB74D)
                                : Colors.grey,
                            width: selectedItem == 1 ? 3 : 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Image.asset(
                            "assets/cut.png",
                            width: 60,
                          ),
                        ),
                        Container(
                          child: AutoSizeText("Corte",
                              minFontSize: 14,
                              maxLines: 4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                  ),
                  selectedItem == 1
                      ? Positioned(
                          right: 20,
                          top: 10,
                          child: Container(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xffFFB74D),
                            ),
                          ))
                      : Container()
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedItem = 2;
                  currentStep = 1;

                  _selectedSupervisor = null;
                  _selectedColaborador = null;
                  _selectedAsegurador = null;
                });

                getAllTypes();
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedItem == 2
                                ? Color(0xffFFB74D)
                                : Colors.grey,
                            width: selectedItem == 2 ? 3 : 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Image.asset(
                            "assets/reception.png",
                            width: 60,
                          ),
                        ),
                        Container(
                          child: AutoSizeText("Recepción de flores",
                              minFontSize: 14,
                              maxLines: 4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                  ),
                  selectedItem == 2
                      ? Positioned(
                          right: 20,
                          top: 10,
                          child: Container(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xffFFB74D),
                            ),
                          ))
                      : Container()
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedItem = 6;
                  currentStep = 1;
                });
                getAllTypes();
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedItem == 6
                                ? Color(0xffFFB74D)
                                : Colors.grey,
                            width: selectedItem == 6 ? 6 : 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Image.asset(
                            "assets/manufacture.png",
                            width: 60,
                          ),
                        ),
                        Container(
                          child: AutoSizeText("Manufactura ramo banda",
                              minFontSize: 14,
                              maxLines: 4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                  ),
                  selectedItem == 3
                      ? Positioned(
                          right: 20,
                          top: 10,
                          child: Container(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xffFFB74D),
                            ),
                          ))
                      : Container()
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  selectedItem = 4;
                  currentStep = 1;
                });

                getAllTypes();
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: selectedItem == 4
                                ? Color(0xffFFB74D)
                                : Colors.grey,
                            width: selectedItem == 4 ? 3 : 1),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Image.asset(
                            "assets/truck.png",
                            width: 60,
                          ),
                        ),
                        Container(
                          child: AutoSizeText("Empaque - Surtido Zuncho",
                              minFontSize: 14,
                              maxLines: 4,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.center),
                          margin: EdgeInsets.only(top: 10),
                        ),
                      ],
                    ),
                  ),
                  selectedItem == 4
                      ? Positioned(
                          right: 20,
                          top: 10,
                          child: Container(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xffFFB74D),
                            ),
                          ))
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkStep() {
    if (currentStep == 0) {
      return StepTwo();
    }
    if (currentStep == 1) {
      return StepOne();
    }
    if (currentStep == 2) {
      return StepThree();
    }

    if (currentStep == 3) {
      return StepFour();
    }
  }

  getLabor(Labor labor) {
    print("son todas ${labor.subProcess}");
    if (labor.process == 1) {
      return "Corte";
    }
    if (labor.process == 2) {
      return "Recepción de flores";
    }
    if (labor.process == 6) {
      return "Manufactura ramo banda";
    }
    if (labor.process == 4) {
      if (labor.subProcess == 3) {
        return "Empaque";
      }
      if (labor.subProcess == 4) {
        return "Surtido";
      }
      if (labor.subProcess == 5) {
        return "Zuncho";
      }
    }
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
        body: SlidingUpPanel(
          minHeight: 0,
          controller: _panelController,
          onPanelOpened: () {
            setState(() {
              isPanelOpen = true;
            });
          },
          onPanelClosed: () {
            setState(() {
              isPanelOpen = false;
            });
          },
          backdropEnabled: true,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          panel: Container(
            child: checkStep(),
          ),
          body: Stack(
            children: [
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.all(10),
                              color: Color(0xff85a335),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      "Historial",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    margin: EdgeInsets.only(top: 5),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              child: Material(
                                color: Color(0xff85a335),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: InkWell(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    loadDataServer();
                                  },
                                ),
                              ),
                              top: 35,
                              left: 20,
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 7,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              color: Colors.white,
                            ),
                            child: labores.length > 0
                                ? Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(bottom: 100),
                                        itemCount: labores.length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          return Container(
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  child: Container(
                                                      child: Text(
                                                        "${labores[index].flowerType}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10))),
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5)),
                                                  right: 0,
                                                  top: 0,
                                                ),
                                                Positioned(
                                                  child: labores[index].state ==
                                                          0
                                                      ? Icon(
                                                          Icons.circle,
                                                          color: Colors
                                                              .redAccent
                                                              .withOpacity(0.8),
                                                          size: 15,
                                                        )
                                                      : Icon(
                                                          Icons.circle,
                                                          color: Colors
                                                              .greenAccent
                                                              .withOpacity(0.8),
                                                          size: 15,
                                                        ),
                                                  top: 5,
                                                  left: 5,
                                                ),
                                                Positioned(
                                                  child: GestureDetector(
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.grey
                                                          .withOpacity(0.8),
                                                    ),
                                                    onTap: () async {
                                                      await sqfly<LaborDao>()
                                                          .deleteLabor(
                                                              labores[index]
                                                                  .id);

                                                      borrarLabor(
                                                          labores[index]);
                                                      getAllLabores();
                                                    },
                                                  ),
                                                  bottom: 10,
                                                  right: 10,
                                                ),
                                                GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 20, bottom: 20),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          child: Image.asset(
                                                            "assets/hoja.png",
                                                            width: 30,
                                                          ),
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 20),
                                                        ),
                                                        Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child:
                                                                    AutoSizeText(
                                                                  "Labor: ${getLabor(labores[index])} ",
                                                                  minFontSize:
                                                                      14,
                                                                  maxLines: 4,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5),
                                                              ),
                                                              labores[index]
                                                                          .blocks !=
                                                                      "Bloque"
                                                                  ? Container(
                                                                      child:
                                                                          Text(
                                                                        "${labores[index].blocks}",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              5),
                                                                    )
                                                                  : Container(),
                                                              Container(
                                                                child: Text(
                                                                  "${formatDate(labores[index].date)}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    print(labores[index]);
                                                    var muestraDecode =
                                                        jsonDecode(
                                                            labores[index]
                                                                .muestras);
                                                    String subtypes =
                                                        muestraDecode[0]
                                                                ["typeString"]
                                                            .join(", ");
                                                    String type =
                                                        muestraDecode[0]
                                                            ["type"];
                                                    List commentConverted =
                                                        jsonDecode(
                                                            labores[index]
                                                                .comments);

                                                    setState(() {
                                                      selectedItem =
                                                          labores[index]
                                                              .process;
                                                    });

                                                    await getAllComments();
                                                    var comments = [];
                                                    for (var c = 0;
                                                        c <
                                                            commentsArray
                                                                .length;
                                                        c++) {
                                                      for (var e = 0;
                                                          e <
                                                              commentConverted
                                                                  .length;
                                                          e++) {
                                                        if (commentConverted[
                                                                e] ==
                                                            c) {
                                                          comments.add(
                                                              commentsArray[c]);
                                                        }
                                                      }
                                                    }
                                                    print(
                                                        "estos son los comentarios ${comments}");
                                                    String commentsString =
                                                        comments.join(", ");

                                                    Alert(
                                                        context: context,
                                                        title:
                                                            "${getLabor(labores[index])}",
                                                        content: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Supervisor",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                  Container(
                                                                    child: Text(
                                                                      "${labores[index].supervisor}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                            ),
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Colaborador",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                  Container(
                                                                    child: Text(
                                                                      "${labores[index].colaborator}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                            ),
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Asegurador",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                  Container(
                                                                    child: Text(
                                                                      "${labores[index].asegurator}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                            ),
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Item de control",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                  Container(
                                                                    child: Text(
                                                                      "${type}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                            ),
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "${labores[index].blocks}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16)),
                                                                  Container(
                                                                    child: parseSubType(
                                                                        subtypes),
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                            ),
                                                            commentsString
                                                                        .length >
                                                                    0
                                                                ? Container(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "Comentarios",
                                                                            style:
                                                                                TextStyle(fontSize: 16)),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "${commentsString}",
                                                                            style:
                                                                                TextStyle(color: Colors.grey, fontSize: 15),
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.only(top: 5),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              Colors.grey,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    margin: EdgeInsets.only(
                                                                        bottom:
                                                                            5),
                                                                  )
                                                                : Container()
                                                          ],
                                                        ),
                                                        buttons: []).show();
                                                  },
                                                )
                                              ],
                                            ),
                                            margin: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                right: 30,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                : Center(
                                    child: Text(
                                      "Por favor ingrese un proceso",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 20),
                                    ),
                                  )))
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      _panelController.open();
                      setState(() {
                        isPanelOpen = true;
                        selectedItem = 0;
                        subControl = 0;
                        currentStep = 0;
                        block = "Bloque";
                        muestrasCount = 0;
                        muestrasArray = [];
                        flower = "Tipo de flor";
                        varieties = [];
                        _selectedSupervisor = null;
                        _selectedColaborador = null;
                        _selectedAsegurador = null;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        'AGREGAR NUEVO',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                    color: Color(0xffFFB74D),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  getAllTypes() async {
    typesArray = [];
    List<Controls> controls = [];
    if (selectedItem == 4) {
      controls = await sqfly<ControlDao>().where({
        'process_id': subControl,
        'sede_id': sede_id,
        'flower_id': 0
      }).toList();
    } else {
      if (flower != "Tipo de flor") {
        Flowers flowerItem = await sqfly<FlowerDao>()
            .findBy({'name': '${flower}', 'sede_id': sede_id});

        controls = await sqfly<ControlDao>().where({
          'process_id': selectedItem,
          'sede_id': sede_id,
          'flower_id': flowerItem.id
        }).toList();

        print("eyyyy aquiiii ${selectedItem}  ${sede_id}  ${flowerItem.id}");
      } else {
        controls = await sqfly<ControlDao>()
            .where({'process_id': selectedItem, 'sede_id': sede_id}).toList();
      }
    }

    print("getALlTypes  ${selectedItem} ${subControl}  ${controls}");
    controls.forEach((element) {
      if (element.name != null) {
        typesArray.add("${element.name}");
      }
    });

    getAllComments();
  }

  getAllSubtypesByType(name) async {
    List<String> subtypesArrayLocal = [];

    Types type = Types();
    Types typeSIncular = await type.findOneByName(name);

    SubTypes superv = SubTypes();

    List<SubTypes> types = await superv.findOneByType(typeSIncular.id);

    types.forEach((element) {
      subtypesArrayLocal.add(element.name);
    });

    setState(() {
      subtypesArray = subtypesArrayLocal;
      modificable = 3;
      FocusScope.of(context).requestFocus(FocusNode());
    });

    print("estos son los types ${subtypesArray}");
    setState(() {});
  }

  getAllComments() async {
    setState(() {
      commentsArray = [];
    });
    List<Comments> comments = await sqfly<CommentDao>()
        .where({'process_id': '${selectedItem}'}).toList();

    print("todos los comentaiors  ${comments}");
    comments.forEach((element) {
      commentsArray.add(element.name);
    });
  }

  findLaboresByProcess() async {
    setState(() {
      actualLabores = [];
    });
    List<Labor> labor =
        await sqfly<LaborDao>().where({'process': '${selectedItem}'}).toList();
    setState(() {
      actualLabores = labor;
    });
  }

  getAllLabores() async {
    setState(() {
      labores = [];
    });
    List<Labor> labor = await sqfly<LaborDao>().getLaborsOrdered();

    labor.forEach((element) {
      setState(() {
        labores.add(element);
      });
    });

    print(labores);
  }

  getAllEmploys() async {
    setState(() {
      suggestionsSupervisor = [];
      suggestions = [];
    });
    List<Employs> emplo =
        await sqfly<EmployeeDao>().where({"sede_id": sede_id}).toList();
    emplo.forEach((element) {
      suggestions.add(element.name);
    });
    List<Employs> supervisors = await sqfly<EmployeeDao>()
        .where({"type": "Supervisor", "sede_id": sede_id}).toList();
    supervisors.forEach((element) {
      suggestionsSupervisor.add(element.name);
    });

    print("aqui esta el supervidor   ${supervisors}");

    await getAllLabores();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print("asfasdf");
    // TODO: implement afterFirstLayout
    getAllEmploys();
  }
}
