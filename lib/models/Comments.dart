import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Comments {
    int _id;
    String _name;
    int _processId;


    int get processId => _processId;

  set processId(int value) {
    _processId = value;
  }

    Comments();

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'process_id': _processId,
    };
  }

    Comments.fromMap(Map<String, dynamic> map)
        : _id = map['id'],
          _name = map['name'],
          _processId = map['process_id'];


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
              'CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_id INTEGER)');
        });
  }

    Future open() async{
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'dbAgrsoOness.db');


      return  await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_id INTEGER)');
          });
    }

  Future<void> save() async {
     final Database db = await openDatabaseLocal();
    await db.insert(
      'comments',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



    Future<void> saveusers(List<Comments> employs) async {

      var database  = await openDatabaseLocal();

      await database.transaction((txn) async {
        var batch = txn.batch();
        employs.forEach((element) {
          batch.rawInsert("INSERT INTO comments(id, name, process_id) VALUES(${element.id}, '${element.name}', ${element.processId})");
        });

        await batch.commit();

      });
      await database.close();

    }

  Future<List<Comments>> findAll() async {
     final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.query('comments');

     return List.generate(maps.length, (i) {
       Comments superv= Comments();
       superv.id=maps[i]['id'];
       superv.name=maps[i]['name'];
       superv._processId=maps[i]['process_id'];
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
        superv._processId=maps[0]['process_id'];
        return  superv;
      }
      return null;
    }
    Future<List<Comments>> findOneByProcess(process) async {
      final Database db = await openDatabaseLocal();

      final List<Map<String, dynamic>> maps = await db.rawQuery('select * from comments where process_id = ${process} order by name');

      return List.generate(maps.length, (i) {
        Comments superv= Comments();
        superv.id=maps[i]['id'];
        superv.name=maps[i]['name'];
        superv._processId=maps[i]['process_step'];
        return  superv;
      });
    }



  String get name => _name;

  set name(String value) {
    _name = value;
  }


}