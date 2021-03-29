import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Controls {
    int _id;
    String _name;
    int _sedeId;
    int _orderControl;
    int _processId;
    int _itemId;


  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'sede_id': _sedeId,
      'name': _name,
      'order_control': _orderControl,
      'process_id': _processId,
      'item_id': _itemId
    };
  }

    Controls.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
           _orderControl = map['order_control'],
          _processId = map['process_id'],
          _itemId = map['item_id'],
          _name = map['name'],
          _sedeId = map['sede_id'];

  Controls();

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
              'CREATE TABLE controls(id INTEGER PRIMARY KEY, order_control INTEGER, process_id INTEGER, sede_id INTEGER, item_id INTEGER)');
        });
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'controls',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



    Future<void> saveusers(List<Controls> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
          batch.rawInsert("INSERT INTO controls(id, order_control, process_id, sede_id, item_id) VALUES(${element.id}, ${element.processId}, ${element.sedeId} , ${element.orderControl}, ${element.itemId})");
        });

        await batch.commit();

      });
      await database.close();

    }


    Future<List<Controls>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('controls');

     return List.generate(maps.length, (i) {
       Controls superv= Controls();
       superv.id=maps[i]['id'];
        superv.processId=maps[i]['process_id'];
       superv.sedeId=maps[i]['sede_id'];
       superv.orderControl=maps[i]['order_control'];
       superv.itemId=maps[i]['item_id'];
       return  superv;
     });
  }


    @override
  String toString() {
    return 'Controls{_id: $_id, _name: $_name, _sedeId: $_sedeId, _orderControl: $_orderControl, _processId: $_processId, _itemId: $_itemId}';
  }

  String get name => _name;

    int get sedeId => _sedeId;

  set sedeId(int value) {
    _sedeId = value;
  }

  set name(String value) {
    _name = value;
  }

    int get orderControl => _orderControl;

  set orderControl(int value) {
    _orderControl = value;
  }

    int get processId => _processId;

  set processId(int value) {
    _processId = value;
  }

    int get itemId => _itemId;

  set itemId(int value) {
    _itemId = value;
  }
}