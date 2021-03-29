import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dropdown {
    int _id;
    String _name;
    String _process;
    String _desplegable;

    String get desplegable => _desplegable;

  set desplegable(String value) {
    _desplegable = value;
  }

  String get process => _process;

  set process(String value) {
    _process = value;
  }

  int _flowerId;
    int _itemId;
    int _processId;

    int get flowerId => _flowerId;

  set flowerId(int value) {
    _flowerId = value;
  }

    Dropdown();

  int _sedeId;


    int get processId => _processId;

  set processId(int value) {
    _processId = value;
  }

    Dropdown.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _flowerId = map['flower_id'],
          _itemId = map['item_id'],
          _name = map['name'],
          _process = map['process'],
          _processId = map['process_id'],
          _desplegable = map['desplegable'],
        _sedeId = map['sede_id'];

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
       'flower_id': _flowerId,
      'item_id': _itemId,
      'process_id': _processId,
      'process': _process,
      'name': _name,
      'desplegable': _desplegable,
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
   return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE dropdowns(id INTEGER PRIMARY KEY, sede_id INTEGER, flower_id INTEGER, item_id INTEGER, process_id INTEGER, name TEXT, process TEXT)');
        });

  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'dropdowns',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


    Future<void> saveusers(List<Dropdown> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
          batch.rawInsert("INSERT INTO dropdowns(id, flower_id, item_id, process_id, sede_id) VALUES(${element.id}, ${element.flowerId}, ${element.itemId} , ${element.processId}, ${element.sedeId})");
        });

        await batch.commit();

      });
      await database.close();

    }

  Future<List<Dropdown>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('dropdowns');

     return List.generate(maps.length, (i) {
       Dropdown superv= Dropdown();
       superv.id=maps[i]['id'];
        superv._processId=maps[i]['process_id'];
       superv._flowerId=maps[i]['flower_id'];
       superv._itemId=maps[i]['item_id'];
       superv._sedeId=maps[i]['sede_id'];
       return  superv;
     });
  }



  String get name => _name;

  set name(String value) {
    _name = value;
  }

    int get itemId => _itemId;

  set itemId(int value) {
    _itemId = value;
  }

    int get sedeId => _sedeId;


    @override
  String toString() {
    return 'Dropdown{_id: $_id, _name: $_name, _process: $_process, _flowerId: $_flowerId, _itemId: $_itemId, _processId: $_processId, _sedeId: $_sedeId}';
  }

  set sedeId(int value) {
    _sedeId = value;
  }
}