
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Labor.dart';
import 'package:agrotest/models/Processes.dart';
import 'package:agrotest/models/Sedes.dart';
import 'package:agrotest/models/Varieties.dart';
import 'package:sqfly/sqfly.dart';

class LaborDao extends Dao<Labor> {
  LaborDao()
      : super(
    '''
       CREATE TABLE labores(id INTEGER PRIMARY KEY, type TEXT, supervisor TEXT, colaborator TEXT, asegurator TEXT, blocks TEXT, flowerType TEXT, process INTEGER, muestras TEXT, comments TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Labor.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );

  Future deleteLabor(labor) async {

       final results = await database.rawQuery('DELETE from labores where id = ${labor}');
      print("borrando labor numero tal ${labor}  ${results}");
     }
}