import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Employs {
    int _id;
    String _name;
    int _factory;


  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'factory': _factory,
    };
  }

    int get id => _id;

  set id(int value) {
    _id = value;
  }

  Future openDatabaseLocal() async{
    return  openDatabase(
       join(await getDatabasesPath(), 'dbTesdtssddddsssddddddssdsssds.db'),
       onCreate: (db, version)  async{

         await db.execute(
           "DROP TABLE IF EXISTS  from types",
         );

         await db.execute(
           "DROP TABLE IF EXISTS from comments",
         );
         await  db.execute(
           "DROP TABLE IF EXISTS from labores",
         );

         await db.execute(
           "DROP TABLE IF EXISTS from subtypes",
         );


         await db.execute(
           "CREATE TABLE types(id INTEGER PRIMARY KEY, name TEXT, process_step INTEGER)",
         );

         await  db.execute(
           "CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_step INTEGER)",
         );

         await db.execute(
           "CREATE TABLE labores(id INTEGER PRIMARY KEY, type TEXT, supervisor TEXT, colaborator TEXT, asegurator TEXT, blocks TEXT, flowerType TEXT, process INTEGER, muestras TEXT, comments TEXT)",
         );


         await db.execute(
           "CREATE TABLE subtypes(id INTEGER PRIMARY KEY, name TEXT, control_type INTEGER)",
         );
         return db.execute(
          "CREATE TABLE emplyois(id INTEGER PRIMARY KEY, name TEXT, factory INTEGER)",
        );
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'emplyois',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employs>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('emplyois');

     return List.generate(maps.length, (i) {
       Employs superv= Employs();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.factory=1;
       return  superv;
     });
  }

    int get factory => _factory;

  set factory(int value) {
    _factory = value;
  }

  @override
  String toString() {
    return 'emplyois{_id: $_id, _name: $_name, _plantation: $_factory}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}