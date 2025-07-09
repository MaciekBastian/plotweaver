class VersionHistory<T> {
  VersionHistory(T initialState)
      : _states = [initialState],
        _index = 0;

  final List<T> _states;
  int _index;

  T get current => _states[_index];

  bool get canUndo => _index > 0;
  bool get canRedo => _index < _states.length - 1;

  void addState(T newState) {
    if (_index < _states.length - 1) {
      _states.removeRange(_index + 1, _states.length);
    }
    _states.add(newState);
    _index++;
  }

  void undo() {
    if (canUndo) {
      _index--;
    }
  }

  void redo() {
    if (canRedo) {
      _index++;
    }
  }
}
