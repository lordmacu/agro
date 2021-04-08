
import 'package:agrotest/dialogs/muestraDialog.dart';
import 'package:agrotest/helpers.dart';
import 'package:agrotest/models/TipoMuestra.dart';
import 'package:agrotest/models/muestrasModel.dart';
import 'package:flutter/material.dart';
class SelectTipoMuestra extends StatefulWidget {
  SelectTipoMuestra({Key key,this.flower,this.sede_id,this.selectedItem,this.subControl,this.typesArray,this.muestra,this.muestrasArray}) : super(key: key);

  String flower;
  int sede_id;
  int selectedItem;
  int subControl;
  List<String> typesArray = [];
  int muestra;
  muestrasModel muestrasArray;

  @override
  _SelectTipoMuestra createState() => _SelectTipoMuestra();
}

class _SelectTipoMuestra extends State<SelectTipoMuestra> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        appBar: AppBar(
          title:Text("Seleccionar tipo de muestra"),
        ),
        body:Container(
          child: muestraDialog(
            flower: widget.flower,
            sede_id:  widget.sede_id,
            selectedItem:  widget.selectedItem,
            subControl:  widget.subControl,
            typesArray:  widget.typesArray,
            subTypesString:  widget.muestrasArray.subtypes,
            selectedType:   widget.muestrasArray.type,
            exportSubtypes: (List<TipoMuestra> muestras) {
              setState(() {
                widget.muestrasArray.name = "Muestra ${widget.muestra}";
                widget.muestrasArray.type = muestras[0].tipo;
                widget.muestrasArray.subtypes = muestras;
              });
               Navigator.pop(context, widget.muestrasArray);
            },
          ),
        )
    );
  }



}