import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

enum Score {
  notSetYet(-1),
  tie(0),
  competitor1(1),
  competitor2(2);

  const Score(this.value);
  final int value;

  factory Score.fromValue(int value) {
    var type = notSetYet;

    for (var element in Score.values) {
      if (value == element.value) {
        type = element;
      }
    }

    return type;
  }

  static List<AgendaItemType> selectable = [
    AgendaItemType.qualification,
    AgendaItemType.knockout,
    AgendaItemType.text
  ];
}

extension ScoreModelListExtension on List<Score> {
  int get competitor1Score {
    return where((element) => element == Score.competitor1).length;
  }

  int get competitor2Score {
    return where((element) => element == Score.competitor2).length;
  }
}
