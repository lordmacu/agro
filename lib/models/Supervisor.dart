import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Supervisor {
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
       onCreate: (db, version) {
         return db.execute(
          "CREATE TABLE supervisor(id INTEGER PRIMARY KEY, name TEXT, factory INTEGER)",
        );
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'supervisor',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Supervisor>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('supervisor');

     return List.generate(maps.length, (i) {
       Supervisor superv= Supervisor();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.factory=maps[i]['plantation'];
       return  superv;
     });
  }

    int get factory => _factory;

  set factory(int value) {
    _factory = value;
  }

  @override
  String toString() {
    return 'Supervisor{_id: $_id, _name: $_name, _plantation: $_factory}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}