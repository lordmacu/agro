import 'package:agrotest/daos/ControlDao.dart';
import 'package:agrotest/daos/DropdownDao.dart';
import 'package:agrotest/daos/FlowerDao.dart';
import 'package:agrotest/helpers.dart';
import 'package:agrotest/listPeople.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/TipoMuestra.dart';
import 'package:agrotest/models/Types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:group_button/group_button.dart';
import 'package:sqfly/sqfly.dart';

class muestraDialog extends StatefulWidget {
  List<String> typesArray = [];
  List<TipoMuestra> subTypesString = [];
  int selectedValue;

  int selectedItem;
  int sede_id;
  String flower;
  Function exportSubtypes;
  String selectedType;
  int subControl;

  muestraDialog(
      {this.flower,
      this.sede_id,
        this.subControl,
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

  String selectedDesplegable;

  bool isLoaded = false;

  bool addNewTipo=false;
  var sqfly = null;
  List<TipoMuestra> muestras=[];



  getAllSubtypesByType(name, index) async {

    if (index != 0) {


      isLoaded = false;
      List<String> subtypesArrayLocal = [];



      if(widget.selectedItem==4){
        List<Dropdown> controls = await sqfly<DropdownDao>().where({
          'name': '${name}',
           'sede_id': widget.sede_id,

          //  'flower_id': flower.id,
          'process_id': widget.subControl
        }).toList();

        controls.forEach((element) {
          subtypesArrayLocal.add(element.desplegable);
        });

      }else{
        Flowers flower = await sqfly<FlowerDao>()
            .findBy({'name': '${widget.flower}', 'sede_id': widget.sede_id});
        List<Dropdown> control = await sqfly<DropdownDao>().where({
          'name': '${name}',
          'sede_id': widget.sede_id,
          'flower_id': flower.id,
          'process_id': widget.selectedItem
        }).toList();

        control.forEach((element) {
          subtypesArrayLocal.add(element.desplegable);
        });
      }


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
      name: 'datdacdddddddddddsdddsdd',
      // database version
      version: 2,
      logger: false,

      daos: [DropdownDao(), ControlDao(), FlowerDao()],
    ).init();
    if (widget.selectedType.length > 0) {
      getAllSubtypesByType(widget.selectedType, widget.selectedValue);
    }
  }

  addTipoMuestra() async{
    setState(() {
      isLoaded = false;

    });
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => ListPeople(listPeopleArray: widget.typesArray)),
    );
    if(result!=null){

      setState(() {
        isLoaded = true;

        SelectedTypes = [];
        widget.subTypesString = [];

        this._selectedSupervisor=result;
      });

      this._selectedType = result;
      this._typeTextEdition.text = result;
      var valorIndex = widget.typesArray.indexOf(result);

      getAllSubtypesByType(result, valorIndex);

    }else{
      setState(() {
        this._typeTextEdition.text = "";

        this._selectedType = "";


        this._typeTextEdition.clear();
        isLoaded = false;
        SelectedTypes = [];

        widget.subTypesString = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          color: Color(0xffFFB74D),
          onPressed: muestras.length>0 ? (){
              widget.exportSubtypes(muestras);
          } : null,
          child: Text("Guardar",style: TextStyle(color: Colors.white),),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            !addNewTipo ? Column(
              children: [
                ListView.builder
                  (
                    shrinkWrap: true,
                    itemCount: muestras.length,

                    itemBuilder: (BuildContext ctxt, int index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                            child: Row(
                              children: [
                                Expanded(child: Text("${muestras[index].tipo} - ${muestras[index].desplegable}",style: TextStyle(fontSize: 18),)),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      muestras.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Icon(Icons.delete,color: Colors.redAccent,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 0),
                  child:Container(
                    child: RaisedButton(
                      color:Color(0xff85a335) ,
                      onPressed: (){
                        setState(() {
                          addNewTipo=!addNewTipo;
                          subtypesArray=[];
                          this._selectedSupervisor=null;
                        });

                        addTipoMuestra();

                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),

                      child: Text("Agregar tipo de muestra",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )
              ],
            ): Container(),
            addNewTipo ? Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),

                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async{
                      addTipoMuestra();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: this._selectedSupervisor==null ? Text("Tipo de muestra") :Text("${this._selectedSupervisor}") ,
                  ),
                ),
                isLoaded
                    ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListView.builder
                      (
                        shrinkWrap: true,
                        itemCount: subtypesArray.length,

                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                            padding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                            child: RaisedButton(
                              color: selectedDesplegable==subtypesArray[index] ?  Color(0xff85a335): Colors.white,
                              onPressed: (){
                                setState(() {
                                  selectedDesplegable=subtypesArray[index];

                                });


                                List<String> stringTypes = [];

                                SelectedTypes.forEach((element) {
                                  stringTypes.add(subtypesArray[element]);
                                });

                                TipoMuestra tipo=TipoMuestra();
                                tipo.desplegable=selectedDesplegable;
                                tipo.tipo=_typeTextEdition.text;
                                muestras.add(tipo);

                                setState(() {
                                  addNewTipo=false;
                                });


                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Text(subtypesArray[index],style: TextStyle(fontSize: 17,color: selectedDesplegable==subtypesArray[index] ? Colors.white:  Color(0xff85a335)),),
                              ),
                            ),
                          );
                        }
                    ))
                    : Container(),
              ],
            ): Container()


          ],
        ),
      ),
    );
  }
}
