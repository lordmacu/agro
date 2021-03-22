import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Comments {
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
          "CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_step INTEGER)",
        );
      },

      version: 1,
    );
  }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'comments',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Comments>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('comments');

     return List.generate(maps.length, (i) {
       Comments superv= Comments();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv.process_step=maps[i]['process_step'];
       return  superv;
     });
  }

    Future<Comments> findOneByName(name) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from comments where name = "${name}" order by name');
      if(maps.length>0){

        Comments superv= Comments();
        superv.id=maps[0]['id'];
        superv.name=maps[0]['name'];
        superv.process_step=maps[0]['process_step'];
        return  superv;
      }
      return null;
    }
    Future<List<Comments>> findOneByProcess(process) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from comments where process_step = ${process} order by name');

      return List.generate(maps.length, (i) {
        Comments superv= Comments();
        superv.id=maps[i]['id'];
        superv.name=maps[i]['name'];
        superv.process_step=maps[i]['process_step'];
        return  superv;
      });
    }

    int get process_step => _processStep;

  set process_step(int value) {
    _processStep = value;
  }

  @override
  String toString() {
    return 'comments{_id: $_id, _name: $_name, _plantation: $_processStep}';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}