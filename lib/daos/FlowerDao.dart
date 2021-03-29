
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:agrotest/models/Flowers.dart';
import 'package:sqfly/sqfly.dart';

class FlowerDao extends Dao<Flowers> {
  FlowerDao()
      : super(
    '''
       CREATE TABLE flowers(id INTEGER PRIMARY KEY, sede_id TEXT, name TEXT)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Flowers.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}