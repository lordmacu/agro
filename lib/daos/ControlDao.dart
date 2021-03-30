import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:sqfly/sqfly.dart';

class ControlDao extends Dao<Controls> {
  ControlDao()
      : super(
    '''
         CREATE TABLE controls(id INTEGER PRIMARY KEY, order_control INTEGER, process_id INTEGER, sede_id INTEGER, item_id INTEGER, flower_id INTEGER, name TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Controls.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}