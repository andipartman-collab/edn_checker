import '../../models/edn_model.dart';

class EdnRepository {
  static final EdnRepository instance = EdnRepository._();

  EdnRepository._();

  EdnModel? _currentEdn;

  EdnModel? get currentEdn => _currentEdn;

  bool get hasData => _currentEdn != null;

  void save(EdnModel edn) {
    _currentEdn = edn;
  }

  void clear() {
    _currentEdn = null;
  }
}