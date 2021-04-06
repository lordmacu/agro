
import 'package:agrotest/helpers.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Container(
          child: TextFormField(
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