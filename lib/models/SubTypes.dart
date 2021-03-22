import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SubTypes {
    int _id;
    String _name;
    int _controlType;


  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'control_type': _controlType,
    };
  }

    int get id => _id;

  set id(int value) {
    _id = value;
  }

  Future openDatabaseLocal() async{
    return  openDatabase(
       join(await getDatabasesPath(), 'dbTesdtssddddsssddddddssdsssds.db'),
       onCreate: (db, version) {

         return db.execute(
          "CREATE TABLE subtypes(id INTEGER PRIMARY KEY, name TEXT, control_type INTEGER)",
        );
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'subtypes',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SubTypes>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('subtypes');

     return List.generate(maps.length, (i) {
       SubTypes superv= SubTypes();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.controlType=maps[i]['control_type'];
       return  superv;
     });
  }


    Future<List<SubTypes>> findOneByType(controlType) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from subtypes where control_type = ${controlType} group by name  order by name');


      return List.generate(maps.length, (i) {
        SubTypes superv= SubTypes();
        superv.id=maps[i]['id'];
        superv.name=maps[i]['name'];
        superv.controlType=maps[i]['control_type'];
        return  superv;
      });
    }

    Future<SubTypes> findOneByName(name) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from types where name = "${name}" order by name');
      if(maps.length>0){

        SubTypes superv= SubTypes();
        superv.id=maps[0]['id'];
        superv.name=maps[0]['name'];
        superv.controlType=maps[0]['control_type'];
        return  superv;
      }
      return null;
    }

    int get controlType => _controlType;

  set controlType(int value) {
    _controlType = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}