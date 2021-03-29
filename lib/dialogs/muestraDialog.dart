import 'package:agrotest/daos/ControlDao.dart';
import 'package:agrotest/daos/DropdownDao.dart';
import 'package:agrotest/daos/FlowerDao.dart';
import 'package:agrotest/helpers.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/Types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:group_button/group_button.dart';
import 'package:sqfly/sqfly.dart';

class muestraDialog extends StatefulWidget {
  List<String> typesArray = [];
  List<String> subTypesString = [];
  int selectedValue;

  int selectedItem;
  int sede_id;
  String flower;
  Function exportSubtypes;
  String selectedType;

  muestraDialog(
      {this.flower,
      this.sede_id,
      this.selectedItem,
      this.typesArray,
      this.exportSubtypes,
      this.selectedType,
      this.subTypesString,
      this.selectedValue});

  @override
  _muestraDialogState createState() => new _muestraDialogState();
}

class _muestraDialogState extends State<muestraDialog> {
  Color _c = Colors.redAccent;
  String _selectedType;
  List<int> SelectedTypes = [];
  List<String> subtypesArray = [];
  List<String> subTypesStringLocal = [];

  bool isLoaded = false;
  var sqfly = null;

  getAllSubtypesByType(name, index) async {
    if (index != 0) {
      //
      Flowers flower = await sqfly<FlowerDao>()
          .findBy({'name': '${widget.flower}', 'sede_id': widget.sede_id});

      isLoaded = false;
      List<String> subtypesArrayLocal = [];

      List<Dropdown> control = await sqfly<DropdownDao>().where({
        'name': '${name}',
        'sede_id': widget.sede_id,
        'flower_id': flower.id,
        'process_id': widget.selectedItem
      }).toList();

      control.forEach((element) {
        subtypesArrayLocal.add(element.desplegable);
      });

      setState(() {
        subtypesArray = subtypesArrayLocal;
      });
      isLoaded = true;

      for (var i = 0; i < subtypesArray.length; i++) {
        for (var o = 0; o < widget.subTypesString.length; o++) {
          if (widget.subTypesString[o] == subtypesArray[i]) {
            SelectedTypes.add(i);
          }
        }
      }
    }
  }

  final TextEditingController _typeTextEdition = TextEditingController();
  String _selectedSupervisor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._typeTextEdition.text = "${widget.selectedType}";
    initDb();
  }

  Future initDb() async {
    sqfly = await Sqfly(
      /// database named
      name: 'datacdsdd',
      // database version
      version: 2,
      logger: false,

      daos: [DropdownDao(), ControlDao(), FlowerDao()],
    ).init();
    if (widget.selectedType.length > 0) {
      getAllSubtypesByType(widget.selectedType, widget.selectedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15, top: 20),
          child: Stack(
            children: [
              TypeAheadFormField(
                noItemsFoundBuilder: (BuildContext context) {
                  return null;
                },
                textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeTextEdition,
                  decoration: new InputDecoration(
                    labelText: "Tipo de muestra",
                    fillColor: Colors.grey.withOpacity(0.1),
                    filled: true,
                    focusColor: Color(0xff85a335),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff85a335)),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
                suggestionsCallback: (pattern) {
                  Helpers helpers = Helpers();
                  return helpers.filterStringsAll(widget.typesArray, pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  this._typeTextEdition.text = suggestion;

                  var valorIndex = widget.typesArray.indexOf(suggestion);

                  getAllSubtypesByType(suggestion, valorIndex);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Selecciona un supervisor';
                  }
                },
                onSaved: (value) {
                  print("aqui esta la cosa");
                  this._selectedType = value;
                  this._typeTextEdition.text = value;
                  var valorIndex = widget.typesArray.indexOf(value);

                  getAllSubtypesByType(value, valorIndex);
                },
              ),
              Positioned(
                top: 20,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    print("asdfasd fasdf ");
                    setState(() {
                      this._typeTextEdition.text = "";

                      this._selectedType = "";

                      FocusScope.of(context).requestFocus(FocusNode());
                      this._typeTextEdition.clear();
                      isLoaded = false;
                      SelectedTypes = [];

                      widget.subTypesString = [];
                    });
                  },
                  child: Container(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoaded
            ? GroupButton(
                isRadio: false,
                selectedButtons: widget.subTypesString,
                spacing: 10,
                onSelected: (index, isSelected) {
                  print('$index button is selected');

                  final person = SelectedTypes.firstWhere(
                      (element) => element == index, orElse: () {
                    return null;
                  });

                  if (person != null) {
                    SelectedTypes.remove(person);
                  } else {
                    SelectedTypes.add(index);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                buttons: subtypesArray,
              )
            : Container(),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Color(0xffFFB74D),
          onPressed: () {
            List<String> stringTypes = [];

            SelectedTypes.forEach((element) {
              stringTypes.add(subtypesArray[element]);
            });

            widget.exportSubtypes(stringTypes, _typeTextEdition.text);
          },
          child: Text(
            "Seleccionar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    );
  }
}
