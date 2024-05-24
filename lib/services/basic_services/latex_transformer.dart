class LatexTransformer {
  static String transform(String raw) {
    final transformed = raw.replaceAll('\\dd{', '\\text{d}{');

    return transformed;
  }

  static String transformWithDollarSigns(String raw) {
    return '\$\$${transform(raw)}\$\$';
  }
}