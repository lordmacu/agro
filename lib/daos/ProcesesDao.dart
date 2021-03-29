
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:agrotest/models/Processes.dart';
import 'package:sqfly/sqfly.dart';

class ProcesesDao extends Dao<Processes> {
  ProcesesDao()
      : super(
    '''
       CREATE TABLE processes(id INTEGER PRIMARY KEY, name TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Processes.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}