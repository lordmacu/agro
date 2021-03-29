import 'dart:async';

import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Processes.dart';
import 'package:agrotest/models/Sedes.dart';
import 'package:agrotest/models/Varieties.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'examsplddes';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_id INTEGER)');
    await db.execute('CREATE TABLE controls(id INTEGER PRIMARY KEY, order_control INTEGER, process_id INTEGER, sede_id INTEGER, item_id INTEGER)');
    await db.execute('CREATE TABLE dropdowns(id INTEGER PRIMARY KEY, sede_id INTEGER, flower_id INTEGER, item_id INTEGER, process_id INTEGER, name TEXT)');
    await db.execute('CREATE TABLE employees(id INTEGER PRIMARY KEY, sede_id INTEGER, name TEXT)');
    await db.execute('CREATE TABLE flowers(id INTEGER PRIMARY KEY, sede_id TEXT, name TEXT)');
    await db.execute('CREATE TABLE labores(id INTEGER PRIMARY KEY, type TEXT, supervisor TEXT, colaborator TEXT, asegurator TEXT, blocks TEXT, flowerType TEXT, process INTEGER, muestras TEXT, comments TEXT)');
    await db.execute('CREATE TABLE processes(id INTEGER PRIMARY KEY, name TEXT)');
    await db.execute('CREATE TABLE sedes(id INTEGER PRIMARY KEY, name TEXT)');
    await db.execute('CREATE TABLE variedad(id INTEGER PRIMARY KEY, flower_id INTEGER, sede_id INTEGER, name TEXT)');
  }


  static  Future<void> saveComments(List<Comments> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO comments(id, name, process_id) VALUES(${element.id}, '${element.name}', ${element.processId})");
      });

      await batch.commit();

    });
   // await _db.close();

  }


  static Future<void> saveControls(List<Controls> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO controls(id, order_control, process_id, sede_id, item_id) VALUES(${element.id}, ${element.processId}, ${element.sedeId} , ${element.orderControl}, ${element.itemId})");
      });

      await batch.commit();

    });
  //  await _db.close();

  }


  static Future<void> saveDropdowns(List<Dropdown> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO dropdowns(id, flower_id, item_id, process_id, sede_id) VALUES(${element.id}, ${element.flowerId}, ${element.itemId} , ${element.processId}, ${element.sedeId})");
      });

      await batch.commit();

    });
   // await _db.close();

  }

  static Future<void> saveEmploys(List<Employs> employs) async {

    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {

        batch.rawInsert(
            'INSERT INTO employees(id, sede_id, name) VALUES(?, ?, ?)',
            [element.id, element.sede, '${element.name}']);
      });

      await batch.commit();
    });
  //  await _db.close();

  }

  static Future<void> saveFlowers(List<Flowers> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO flowers(id, sede_id, name) VALUES(${element.id}, '${element.sedeId}', '${element.name}')");
      });
      await batch.commit();

    });
    //await _db.close();

  }

  static Future<void> saveProcesess(List<Processes> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO processes(id, name) VALUES(${element.id}, '${element.name}')");

      });
      await batch.commit();

    });
   // await _db.close();

  }

  static Future<void> saveSedes(List<Sedes> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO sedes(id, name) VALUES(${element.id}, '${element.name}')");

      });
      await batch.commit();

    });
  //  await _db.close();

  }

  static Future<void> saveVarieties(List<Varieties> employs) async {


    await _db.transaction((txn) async {
      var batch = txn.batch();
      employs.forEach((element) {
        batch.rawInsert("INSERT INTO variedad(id, flower_id, sede_id, name) VALUES(${element.id}, ${element.flowerId}, ${element.sedeId}, '${element.name}')");

      });
      await batch.commit();

    });
//
  }

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String SQL) async =>
      await _db.rawInsert(SQL);


}