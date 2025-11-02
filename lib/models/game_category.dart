class GameCategory {
  final String id;
  final String nome;
  final String descricao;

  const GameCategory({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String? ?? '',
    );
  }
}
