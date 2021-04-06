import 'package:agrotest/models/TipoMuestra.dart';

class muestrasModel{
  String _name;
  int _id;
  String _type;
  List<TipoMuestra> _subtypes;
  List<String> _subtypesString;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  List<TipoMuestra> get subtypes => _subtypes;


  List<String> get subtypesString => _subtypesString;

  set subtypesString(List<String> value) {
    _subtypesString = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'id': _id,
      'type': _type,
      'typeString': _subtypesString
     };
  }

  @override
  String toString() {
    return 'muestrasModel{_name: $_name, _id: $_id, _type: $_type, _subtypes: $_subtypes, _subtypesString: $_subtypesString}';
  }

  set subtypes(List<TipoMuestra> value) {
    _subtypes = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  set id(int value) {
    _id = value;
  }
}