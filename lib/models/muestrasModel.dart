class muestrasModel{
  String _name;
  int _id;
  String _type;
  List<String> _subtypes;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  List<String> get subtypes => _subtypes;

  @override
  String toString() {
    return 'muestrasModel{_name: $_name, _id: $_id, _type: $_type, _subtypes: $_subtypes}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'id': _id,
      'type': _type,
      'subtypes':_subtypes
    };
  }

  set subtypes(List<String> value) {
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