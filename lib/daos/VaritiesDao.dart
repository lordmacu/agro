
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Processes.dart';
import 'package:agrotest/models/Sedes.dart';
import 'package:agrotest/models/Varieties.dart';
import 'package:sqfly/sqfly.dart';

class VaritiesDao extends Dao<Varieties> {
  VaritiesDao()
      : super(
    '''
       CREATE TABLE variedad(id INTEGER PRIMARY KEY, flower_id INTEGER, sede_id INTEGER, name TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Varieties.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}