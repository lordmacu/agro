import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Types {
    int _id;
    String _name;
    int _processStep;


  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'process_step': _processStep,
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
          "CREATE TABLE types(id INTEGER PRIMARY KEY, name TEXT, process_step INTEGER)",
        );
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'types',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Types>> findAll() async {
     final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from types where name <> ""  order by name group by name');
      print("estos son los tipos ${maps}");
     return List.generate(maps.length, (i) {

         Types superv= Types();
         superv.id=maps[i]['id'];
         superv.name=maps[i]['name'];
         superv.process_step=maps[i]['process_step'];
         return  superv;


     });
  }


    Future<List<Types>> findAllByProcess(process) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from types where name <> "" and process_step= ${process} group by name  order by name ');
      print("estos son los tipos ${maps}");
      return List.generate(maps.length, (i) {

        Types superv= Types();
        superv.id=maps[i]['id'];
        superv.name=maps[i]['name'];
        superv.process_step=maps[i]['process_step'];
        return  superv;


      });
    }

    Future<Types> findOneByName(name) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from types where name = "${name}" order by name');
      if(maps.length>0){

        Types superv= Types();
        superv.id=maps[0]['id'];
        superv.name=maps[0]['name'];
        superv.process_step=maps[0]['process_step'];
        return  superv;
      }
      return null;
    }




    int get process_step => _processStep;

  set process_step(int value) {
    _processStep = value;
  }

  @override
  String toString() {
    return 'typesd{_id: $_id, _name: $_name, _plantation: $_processStep}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}