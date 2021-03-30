import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Flowers {
    int _id;
    String _name;
    String _sedeId;

    Flowers();
    Flowers.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _name = map['name'],
          _sedeId = map['sede_id'];



  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'sede_id': _sedeId,
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
              'CREATE TABLE flowers(id INTEGER PRIMARY KEY, sede_id TEXT, name TEXT)');
        });
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'flowers',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    Future<void> saveusers(List<Flowers> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
          batch.rawInsert("INSERT INTO flowers(id, sede_id, name) VALUES(${element.id}, '${element.sedeId}', '${element.name}')");
        });
         await batch.commit();

      });
      await database.close();

    }

  Future<List<Flowers>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('flowers');

     return List.generate(maps.length, (i) {
       Flowers superv= Flowers();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.sedeId=maps[i]['sede_id'];
       return  superv;
     });
  }


    @override
  String toString() {
    return 'Flowers{_id: $_id, _name: $_name, _sedeId: $_sedeId}';
  }

  String get sedeId => _sedeId;

  set sedeId(String value) {
    _sedeId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}