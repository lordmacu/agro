import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Labor {
  int id;
  String _type;
  String _supervisor;
  String _colaborator;
  String _asegurator;
   String _flowerType;
  int _process;
  String _muestras;
  String _comments;
  String _blocks;
  String _subtype;
  String _date;
  int _state;
  String _variety;


  String get variety => _variety;

  set variety(String value) {
    _variety = value;
  }

  int get state => _state;

  set state(int value) {
    _state = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int  _subProcess;


  int get subProcess => _subProcess;

  set subProcess(int value) {
    _subProcess = value;
  }

  String get subtype => _subtype;

  set subtype(String value) {
    _subtype = value;
  }

  Labor();
  Labor.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        _type = map['type'],
        _state = map['state'],
        _subtype = map['subtype'],
        _asegurator = map['asegurator'],
        _colaborator = map['colaborator'],
        _variety = map['variety'],
        _flowerType = map['flowerType'],
        _process = map['process'],
        _muestras = map['muestras'],
        _comments = map['comments'],
        _blocks = map['blocks'],
        _date = map['date'],
        _subProcess = map['subprocess'],
        _supervisor = map['supervisor'];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': _type,
      'supervisor': _supervisor,
      'colaborator': _colaborator,
      'asegurator': _asegurator,
      'variety': _variety,
      'flowerType': _flowerType,
      'process': _process,
      'muestras': _muestras,
      'subtype': _subtype,
      'date': _date,
      'state': _state,
      'subprocess': _subProcess,
      'comments': _comments,
      'blocks': _blocks,

    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': _type,
      'supervisor': _supervisor,
      'colaborator': _colaborator,
      'asegurator': _asegurator,
      'flowerType': _flowerType,
      'process': _process,
      'muestras': _muestras,
      'subtype': _subtype,
      'variety': _variety,
      'date': _date,
      'state': _state,
      'subprocess': _subProcess,
      'comments': _comments,
      'blocks': _blocks,

    };
  }

  Future openDatabaseLocal() async{


    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbAgrsoOness.db');

    await deleteDatabase(path);
    return  await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE labores(id INTEGER PRIMARY KEY, type TEXT, supervisor TEXT, colaborator TEXT, asegurator TEXT, blocks TEXT, flowerType TEXT, process INTEGER, muestras TEXT, comments TEXT)');
        });
  }

  Future<void> save() async {
    final Database db = await openDatabaseLocal();
    print("aqui el map ${this.toMap()}");
   await db.insert(
      'labores',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Labor>> findAll() async {
    final Database db = await openDatabaseLocal();

     final List<Map<String, dynamic>> maps = await db.rawQuery('select * from labores order by id desc');

    print("todo los cosos  ${maps}");
    return List.generate(maps.length, (i) {
      Labor superv= Labor();
      superv.id=maps[i]['id'];
      superv.type=maps[i]['type'];
      superv.supervisor=maps[i]['supervisor'];
      superv.colaborator=maps[i]['colaborator'];
      superv.asegurator=maps[i]['asegurator'];
      superv.blocks=maps[i]['blocks'];
      superv.flowerType=maps[i]['flowerType'];
      superv.process=maps[i]['process'];
      superv.muestras=maps[i]['muestras'];
      superv.comments=maps[i]['comments'];

      return  superv;
    });
  }


  @override
  String toString() {
    return 'Labor{id: $id, _type: $_type, _supervisor: $_supervisor, _colaborator: $_colaborator, _asegurator: $_asegurator, _flowerType: $_flowerType, _process: $_process, _muestras: $_muestras, _comments: $_comments, _blocks: $_blocks, _subtype: $_subtype, _date: $_date, _subProcess: $_subProcess}';
  }

  String get blocks => _blocks;


  set blocks(String value) {
    _blocks = value;
  }

  int get process => _process;

  set process(int value) {
    _process = value;
  }

  String get comments => _comments;


  set comments(String value) {
    _comments = value;
  }

  String get muestras => _muestras;

  set muestras(String value) {
    _muestras = value;
  }


  String get flowerType => _flowerType;

  set flowerType(String value) {
    _flowerType = value;
  }



  String get asegurator => _asegurator;

  set asegurator(String value) {
    _asegurator = value;
  }

  String get colaborator => _colaborator;

  set colaborator(String value) {
    _colaborator = value;
  }

  String get supervisor => _supervisor;

  set supervisor(String value) {
    _supervisor = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}