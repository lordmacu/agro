import 'package:agrotest/models/Dropdown.dart';

class TipoMuestra{


  String _tipo;
  String _desplegable;

  String get desplegable => _desplegable;

  @override
  String toString() {
    return 'TipoMuestra{_tipo: $_tipo, _desplegable: $_desplegable}';
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': _tipo,
      'desplegable': _desplegable,
    };
  }

  set desplegable(String value) {
    _desplegable = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }






}