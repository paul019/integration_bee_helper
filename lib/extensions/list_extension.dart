extension ListExtension<T> on List<T> {
  List<T> deleteEmptyEntries() {
    return where((element) => element != '').toList();
  }
}
