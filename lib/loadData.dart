import 'package:agrotest/login.dart';
import 'package:agrotest/mock.dart';
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/SubTypes.dart';
import 'package:agrotest/models/Types.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadDataPage extends StatefulWidget {
  LoadDataPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoadDataPagePage createState() => _LoadDataPagePage();
}

class _LoadDataPagePage extends State<LoadDataPage> {


  @override
  void initState() {
 //   loadData();

    checkCreation();

  }

  checkCreation() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoadedTables=prefs.getBool("isLoadedTable");

    if(isLoadedTables==null){
      loadData();
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await createEmploysOne();
    await createEmploysTwo();


    await createTypes(1);
    await createTypes(2);
    await createTypes(3);
    await createTypes(4);
    await createTypes(5);
    await createTypes(6);


    await createSubtype(1);
    await createSubtype(2);
    await createSubtype(4);
    await createSubtype(5);
    await createSubtype(6);


    await createComments(1);
    await createComments(3);
    prefs.setBool("isLoadedTable",true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
return "aqui";
  /*  Types employ= Types();
    var all = await employ.findAll();

    print(all);*/
/*
    Types employ= Types();

    //var fincaDos=await mock.fincaDos();
      var all = await employ.findAll();
     print("todos   ${all.length}");*/
  }

  createComments(processStep) async{
    Mock mock= Mock();

    var comments=await mock.comments(processStep);
    comments.forEach((element) async{
      Comments employ= Comments();
      employ.name=element["name"];
      employ.process_step=element["process_step"];
      await  employ.save();
    });
    print("comments   created  step  ${processStep}");

  }

  createEmploysOne() async{
    Mock mock= Mock();

    var fincaUno=await mock.fincaUno();
    fincaUno.forEach((element) async{
      Employs employ= Employs();
      employ.name=element["name"];
      employ.factory=1;
      await  employ.save();
    });
    print("employsOne  created ");
  }

  createEmploysTwo() async{
    Mock mock= Mock();

    var fincaUno=await mock.fincaDos();
    fincaUno.forEach((element) async{
      Employs employ= Employs();
      employ.name=element["name"];
      employ.factory=2;
      await  employ.save();
    });
    print("employsTwo  created ");
  }

  createTypes(processStep) async{
    Mock mock= Mock();
    Types typem= Types();
    await typem.openDatabaseLocal();
    var TypeOne=await mock.types(processStep);
    TypeOne.forEach((element) async{
      Types employ= Types();

      if(element["type"]!=null){
        var typeFInd= await employ.findOneByName(element["type"]);
        if(typeFInd==null){
          employ.name=element["type"].trim();
          employ.process_step=element["process_step"];
        }
        await  employ.save();
      }

    });

    print("type Created ${processStep}");
  }

  createSubtype(processStep) async{
    Mock mock= Mock();

    SubTypes subtypes= SubTypes();
    await subtypes.openDatabaseLocal();
    var SubTypeOne=await mock.subtypes(processStep);
    SubTypeOne.forEach((element) async{
      Types types= Types();
      Types typeSincular= await types.findOneByName(element["control_type"].trim());
      Types typeFinal= null;
      if(typeSincular!=null){
        typeFinal=typeSincular;
      }else{
        Types employ= Types();
        employ.name=element["control_type"];
        employ.process_step=processStep;
        await  employ.save();
        Types typeSincular= await types.findOneByName(element["control_type"].trim());
        typeFinal=typeSincular;
      }
      SubTypes employ= SubTypes();
      SubTypes typesIndi= await employ.findOneByName(element["name"]);
      if(typesIndi==null){
        employ.name=element["name"];
        employ.controlType=typeFinal.id;
        await  employ.save();
      }

    });

    print("subtype Created ${processStep}");

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

        body:Center(
          child:  Text(" "),
        ));
  }
}
