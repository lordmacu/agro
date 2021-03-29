
import 'package:agrotest/models/Comments.dart';
import 'package:agrotest/models/Controls.dart';
import 'package:agrotest/models/Dropdown.dart';
import 'package:agrotest/models/Employs.dart';
import 'package:sqfly/sqfly.dart';

class CommentDao extends Dao<Comments> {
  CommentDao()
      : super(
    '''
        CREATE TABLE comments(id INTEGER PRIMARY KEY, name TEXT, process_id INTEGER)
          ''',
    // use to decode and encode person
    converter: Converter(
      encode: (person) => Comments.fromMap(person),
      decode: (person) => person.toMap(),
    ),
  );
}