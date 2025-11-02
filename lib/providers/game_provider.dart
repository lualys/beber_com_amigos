import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/game_card.dart';
import '../models/game_category.dart';
import '../services/data_service.dart';

class ActiveRule {
  final GameCard ruleCard;
  int remainingRounds; // -1 = até cancelar
  ActiveRule({required this.ruleCard, required this.remainingRounds});
}

class GameProvider extends ChangeNotifier {
  final _random = Random();

  // Dados
  List<GameCategory> categories = <GameCategory>[];
  List<GameCard> allCards = <GameCard>[];
  Map<String, dynamic> meta = <String, dynamic>{};

  // Filtros
  Set<String> selectedCategoryIds = <String>{};
  Set<String> selectedLevels = <String>{'leve', 'medio', 'pesado'};
  bool show18Plus = true;

  // Estado
  GameCard? currentCard;
  final List<ActiveRule> activeRules = <ActiveRule>[];

  bool get isReady => allCards.isNotEmpty;

  Future<void> init() async {
    final (cats, cards, meta) = await DataService().load();
    categories = cats;
    allCards = cards;
    this.meta = meta;

    // Seleciona todas as categorias por padrão
    selectedCategoryIds = categories.map((c) => c.id).toSet();
    drawNext();
  }

  void toggleCategory(String id) {
    if (selectedCategoryIds.contains(id)) {
      selectedCategoryIds.remove(id);
    } else {
      selectedCategoryIds.add(id);
    }
    notifyListeners();
  }

  void toggleLevel(String lvl) {
    if (selectedLevels.contains(lvl)) {
      selectedLevels.remove(lvl);
    } else {
      selectedLevels.add(lvl);
    }
    notifyListeners();
  }

  void setShow18Plus(bool value) {
    show18Plus = value;
    notifyListeners();
  }

  List<GameCard> _filtered() {
    return allCards.where((c) {
      if (!selectedCategoryIds.contains(c.categoria)) return false;
      if (!selectedLevels.contains(c.nivel)) return false;
      if (!show18Plus && (c.restricao?.contains('18') ?? false)) return false;
      return true;
    }).toList();
  }

  void drawNext() {
    final pool = _filtered();
    currentCard = pool.isEmpty ? null : pool[_random.nextInt(pool.length)];
    _decrementActiveRules();
    notifyListeners();
  }

  void applyCurrentIfRule() {
    final c = currentCard;
    if (c == null || c.tipo != CardType.regra) return;

    final int remaining = switch (c.duracao) {
      'ate_cancelar' => -1,
      final String s when s.endsWith('_rodadas') =>
        int.tryParse(s.split('_').first) ?? 3,
      _ => 3,
    };

    activeRules.add(ActiveRule(ruleCard: c, remainingRounds: remaining));
    notifyListeners();
  }

  void cancelAllRules() {
    activeRules.clear();
    notifyListeners();
  }

  void _decrementActiveRules() {
    for (final ar in activeRules) {
      if (ar.remainingRounds > 0) ar.remainingRounds -= 1;
    }
    activeRules.removeWhere((ar) => ar.remainingRounds == 0);
  }
}
