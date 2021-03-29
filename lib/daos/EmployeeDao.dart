import 'package:agrotest/models/Employs.dart';
import 'package:sqfly/sqfly.dart';

class EmployeeDao extends Dao<Employs> {
  EmployeeDao()
      : super(
    '''
         CREATE TABLE employees(id INTEGER PRIMARY KEY, sede_id INTEGER, name TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Employs.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}