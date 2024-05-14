part of 'agenda_items_service.dart';

extension EditAgendaItemStatic on AgendaItemsService {
  Future editAgendaItemKnockout(
    AgendaItemModelKnockout agendaItem, {
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    String? competitor1Name,
    String? competitor2Name,
    Duration? timeLimitPerIntegral,
    Duration? timeLimitPerSpareIntegral,
    String? title,
  }) async {
    await agendaItem.reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'competitor1Name': competitor1Name,
      'competitor2Name': competitor2Name,
      'timeLimitPerIntegral': timeLimitPerIntegral?.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral?.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  Future editAgendaItemQualification(
    AgendaItemModelQualification agendaItem, {
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    Duration? timeLimitPerIntegral,
    Duration? timeLimitPerSpareIntegral,
    String? title,
  }) async {
    await agendaItem.reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'timeLimitPerIntegral': timeLimitPerIntegral?.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral?.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  Future editAgendaItemText(
    AgendaItemModelText agendaItem, {
    String? title,
    String? subtitle,
    String? imageUrl,
  }) async {
    await agendaItem.reference.update({
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
    }.deleteNullEntries());
  }
}
