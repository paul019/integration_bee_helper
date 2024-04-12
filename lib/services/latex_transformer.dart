class LatexTransformer {
  static String transform(String latex) {
    latex = latex.replaceAll('\\dd{', '\\text{d}{');

    return '\$\$$latex\$\$';
  }
}