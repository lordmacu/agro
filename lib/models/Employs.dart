import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:agrotest/DB.dart';

class Employs {
    int _id;
    String _name;
    int _sede;


    Employs();

    Employs.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _name = map['name'],
          _sede = map['sede_id'];

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'sede_id': _sede,
    };
  }



    int get id => _id;

  set id(int value) {
    _id = value;
  }


  Future opens() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbAgrsoOness.db');
    await deleteDatabase(path);


    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE employees(id INTEGER PRIMARY KEY, sede_id INTEGER, name TEXT)');
        });
  }
  Future openDatabaseLocal() async{

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbAgrsoOness.db');


    return  openDatabase(
      path,
       onCreate: (db, version)  async{
         Batch batch = db.batch();


         batch.execute(
           "CREATE TABLE controls(id INTEGER PRIMARY KEY, order_control INTEGER, process_id INTEGER, sede_id INTEGER, item_id INTEGER)",
         );

         batch.execute(
           "CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_id INTEGER)",
         );

         batch.execute(
           "CREATE TABLE dropdowns(id INTEGER PRIMARY KEY, flower_id INTEGER, item_id INTEGER, process_id INTEGER, sede_id INTEGER, item TEXT)",
         );


         batch.execute(
           "CREATE TABLE flowers(id INTEGER PRIMARY KEY, sede_id TEXT, name TEXT)",
         );

         batch.execute(
           "CREATE TABLE sedes(id INTEGER PRIMARY KEY, name TEXT)",
         );

         batch.execute(
           "CREATE TABLE variedad(id INTEGER PRIMARY KEY, flower_id INTEGER, sede_id INTEGER, name TEXT)",
         );



         batch.execute(
           "CREATE TABLE employees(id INTEGER PRIMARY KEY, sede_id INTEGER, name TEXT)",
         );
         batch.execute(
           "CREATE TABLE processes(id INTEGER PRIMARY KEY, name TEXT)",
         );
         List<dynamic> result = await batch.commit();

          return ;
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await opens();
    await db.insert(
      'employees',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


    Future<void> saveusers(List<Employs> employs) async {
      final Database db = await opens();

      await db.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {

          batch.rawInsert(
              'INSERT INTO employees(id, sede_id, name) VALUES(?, ?, ?)',
              [element.id, element.sede, '${element.name}']);
        });

        await batch.commit();
      });

    }

  Future<List<Employs>> findAll() async {

      final List<Map<String, dynamic>> maps =   await DB.query("SELECT * FROM employees");

     return List.generate(maps.length, (i) {
       Employs superv= Employs();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.sede=maps[i]['sede_id'];
       return  superv;
     });
  }


    int get sede => _sede;

  set sede(int value) {
    _sede = value;
  }

  @override
  String toString() {
    return 'emplyois{_id: $_id, _name: $_name, _plantation: $_sede}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}