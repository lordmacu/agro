import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Processes {
    int _id;
    String _name;

    Processes();

    Processes.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _name = map['name'];



  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
     };
  }

    int get id => _id;

  set id(int value) {
    _id = value;
  }

  Future openDatabaseLocal() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbAgrsoOness.db');

    await deleteDatabase(path);
    return  await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE processes(id INTEGER PRIMARY KEY, name TEXT)');
        });
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'processes',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


    Future<void> saveusers(List<Processes> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
           batch.rawInsert("INSERT INTO processes(id, name) VALUES(${element.id}, '${element.name}')");

        });
        await batch.commit();

      });
      await database.close();

    }

  Future<List<Processes>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('processes');

     return List.generate(maps.length, (i) {
       Processes superv= Processes();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
        return  superv;
     });
  }



  String get name => _name;

  set name(String value) {
    _name = value;
  }


}