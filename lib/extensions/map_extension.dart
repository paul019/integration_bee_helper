extension MapExtension<A, B> on Map<A, B> {
  Map<A, B> deleteNullEntries() {
    return Map<A, B>.fromEntries(
      entries.where((element) => element.value != null),
    );
  }
}
