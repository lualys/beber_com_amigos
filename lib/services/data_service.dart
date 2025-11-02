import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/game_card.dart';
import '../models/game_category.dart';

class DataService {
  static const String dataPath = 'assets/data/dados_perguntas.json';

  Future<(List<GameCategory>, List<GameCard>, Map<String, dynamic>)> load() async {
    final raw = await rootBundle.loadString(dataPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final List<GameCategory> cats = (json['categorias'] as List<dynamic>)
        .map((e) => GameCategory.fromJson(e as Map<String, dynamic>))
        .toList();

    final List<GameCard> cards = GameCard.listFromJson(raw);

    final Map<String, dynamic> meta = json['meta'] as Map<String, dynamic>? ?? {};
    return (cats, cards, meta);
  }
}
