import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Varieties {
    int _id;
    String _name;
    int _sedeId;
    int _flowerId;

    Varieties.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _name = map['name'],
          _flowerId = map['flower_id'],
          _sedeId = map['sede_id'];
    Varieties();


  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'sede_id': _sedeId,
      'flower_id': _flowerId,
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
              'CREATE TABLE variedad(id INTEGER PRIMARY KEY, flower_id INTEGER, sede_id INTEGER, name TEXT)');
        });
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'variedad',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    Future<void> saveusers(List<Varieties> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
          batch.rawInsert("INSERT INTO variedad(id, flower_id, sede_id, name) VALUES(${element.id}, ${element.flowerId}, ${element.sedeId}, '${element.name}')");

        });
        await batch.commit();

      });
      await database.close();

    }

    @override
  String toString() {
    return 'Varieties{_id: $_id, _name: $_name, _sedeId: $_sedeId, _flowerId: $_flowerId}';
  }

  Future<List<Varieties>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('variedad');

     return List.generate(maps.length, (i) {
       Varieties superv= Varieties();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.sedeId=maps[i]['sede_id'];
       superv.flowerId=maps[i]['flower_id'];
       return  superv;
     });
  }


    int get flowerId => _flowerId;

  set flowerId(int value) {
    _flowerId = value;
  }

  int get sedeId => _sedeId;

  set sedeId(int value) {
    _sedeId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}