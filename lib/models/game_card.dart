import 'dart:convert';

enum CardType { euNunca, verdade, desafio, acao, regra, voto }

CardType _parseType(String raw) {
  switch (raw.toLowerCase()) {
    case 'eu_nunca':
      return CardType.euNunca;
    case 'verdade':
      return CardType.verdade;
    case 'desafio':
      return CardType.desafio;
    case 'acao':
      return CardType.acao;
    case 'regra':
      return CardType.regra;
    case 'voto':
      return CardType.voto;
    default:
      return CardType.acao;
  }
}

class GameCard {
  final String id;
  final String categoria; // id da categoria
  final String nivel;     // leve | medio | pesado
  final CardType tipo;
  final String texto;

  // opcionais:
  final int? goles;
  final int? golesSePular;
  final int? golesPenalidade;
  final String? golesAfetados;
  final int? golesDistribuir;
  final String? restricao; // ex: "18+"
  final String? duracao;   // ex: "3_rodadas", "ate_cancelar"
  final String? efeito;

  GameCard({
    required this.id,
    required this.categoria,
    required this.nivel,
    required this.tipo,
    required this.texto,
    this.goles,
    this.golesSePular,
    this.golesPenalidade,
    this.golesAfetados,
    this.golesDistribuir,
    this.restricao,
    this.duracao,
    this.efeito,
  });

  factory GameCard.fromJson(Map<String, dynamic> json) {
    return GameCard(
      id: json['id'] as String,
      categoria: json['categoria'] as String,
      nivel: json['nivel'] as String,
      tipo: _parseType(json['tipo'] as String),
      texto: json['texto'] as String,
      goles: json['goles'] as int?,
      golesSePular: json['goles_se_pular'] as int?,
      golesPenalidade: json['goles_penalidade'] as int?,
      golesAfetados: json['goles_afetados'] as String?,
      golesDistribuir: json['goles_distribuir'] as int?,
      restricao: json['restricao'] as String?,
      duracao: json['duracao'] as String?,
      efeito: json['efeito'] as String?,
    );
  }

  static List<GameCard> listFromJson(String source) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    final List<dynamic> cards = map['cartas'] as List<dynamic>;
    return cards.map((e) => GameCard.fromJson(e as Map<String, dynamic>)).toList();
  }
}
