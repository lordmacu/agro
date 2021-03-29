import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:sqfly/sqfly.dart';

class DropdownDao extends Dao<Dropdown> {
  DropdownDao()
      : super(
    '''
         CREATE TABLE dropdowns(id INTEGER PRIMARY KEY, sede_id INTEGER, flower_id INTEGER, item_id INTEGER, process_id INTEGER, name TEXT, process TEXT, desplegable TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Dropdown.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}