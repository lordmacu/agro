import 'package:agrotest/helpers.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/Types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:group_button/group_button.dart';

class muestraDialog extends StatefulWidget {
  List<String> typesArray = [];
  List<String> subTypesString = [];

  Function exportSubtypes;
  String selectedType;

  muestraDialog({this.typesArray,this.exportSubtypes,this.selectedType,this.subTypesString});
  @override
  _muestraDialogState createState() => new _muestraDialogState();
}

class _muestraDialogState extends State<muestraDialog> {
  Color _c = Colors.redAccent;
  String _selectedType;
  List<int> SelectedTypes = [];
  List<String> subtypesArray = [];
  List<String> subTypesStringLocal = [];

  bool isLoaded=false;

  getAllSubtypesByType(name) async{

    if(name!="Ramo conforme"){


    isLoaded=false;
    List<String> subtypesArrayLocal = [];

    Types type = Types();
    Types typeSIncular = await type.findOneByName(name);

    SubTypes superv= SubTypes();

    List<SubTypes> types= await superv.findOneByType(typeSIncular.id);

    types.forEach((element) {
      subtypesArrayLocal.add(element.name);
    });

    setState(() {
      subtypesArray=subtypesArrayLocal;
    });
    isLoaded=true;

    print("asdf as ${subtypesArray}  ${widget.subTypesString}");

    for(var i =0 ; i<subtypesArray.length; i++){
        for(var o =0 ;o< widget.subTypesString.length; o++){
          if(widget.subTypesString[o]==subtypesArray[i]){
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

    this._typeTextEdition.text="${widget.selectedType}";

    if(widget.selectedType.length>0){
      getAllSubtypesByType(widget.selectedType);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15,top: 20),
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
                  getAllSubtypesByType(suggestion);

                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Selecciona un supervisor';
                  }
                },
                onSaved: (value) {

                  print("aqui esta la cosa");
                  this._selectedType = value;
                  this._typeTextEdition.text=value;
                  getAllSubtypesByType(value);
                },
              ),
              Positioned(
                top: 20,
                right: 10,
                child: GestureDetector(
                  onTap: (){
                    print("asdfasd fasdf ");
                    setState(() {
                      this._typeTextEdition.text = "";

                      this._selectedType = "";

                      FocusScope.of(context).requestFocus(FocusNode());
                      this._typeTextEdition.clear();
                      isLoaded=false;
                      SelectedTypes=[];

                      widget.subTypesString=[];
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
        isLoaded ? GroupButton(
          isRadio: false,
          selectedButtons: widget.subTypesString,

          spacing: 10,
          onSelected: (index, isSelected) {
            print('$index button is selected');


            final person =
            SelectedTypes.firstWhere((element) =>
            element == index,
                orElse: () {
                  return null;
                });

            if(person!=null){
              SelectedTypes.remove(person);
            }else{
              SelectedTypes.add(index);

            }
            FocusScope.of(context).requestFocus(FocusNode());



          },


          buttons: subtypesArray,
        ):Container(),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
           color: Color(0xffFFB74D),
          onPressed: () {
              List<String> stringTypes=[];

             SelectedTypes.forEach((element) {
               stringTypes.add(subtypesArray[element]);
             });



               widget.exportSubtypes(stringTypes,_typeTextEdition.text);
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