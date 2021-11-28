///Triple StreamStore cant receive nullable state
class TripleState<T> {
  T? value;

  TripleState.initial() : value = null;

  TripleState.fromData(T value) : this.value = value;
}
