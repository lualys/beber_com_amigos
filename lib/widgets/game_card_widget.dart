import 'package:flutter/material.dart';
import '../models/game_card.dart';

class GameCardWidget extends StatelessWidget {
  final GameCard card;
  const GameCardWidget({super.key, required this.card});

  String _titleForType(CardType t) {
    return switch (t) {
      CardType.euNunca => 'Eu Nunca',
      CardType.verdade => 'Verdade',
      CardType.desafio => 'Desafio',
      CardType.acao => 'Ação',
      CardType.regra => 'Regra',
      CardType.voto => 'Votação',
    };
  }

  List<Widget> _extraInfo(TextStyle? style) {
    final info = <Widget>[];
    if (card.goles != null) info.add(Text('Goles: ${card.goles}', style: style));
    if (card.golesSePular != null) info.add(Text('Se pular: ${card.golesSePular}', style: style));
    if (card.golesPenalidade != null) info.add(Text('Penalidade: ${card.golesPenalidade}', style: style));
    if (card.golesAfetados != null) info.add(Text('Afeta: ${card.golesAfetados}', style: style));
    if (card.golesDistribuir != null) info.add(Text('Distribuir: ${card.golesDistribuir}', style: style));
    if (card.efeito != null) info.add(Text('Efeito: ${card.efeito}', style: style));
    if (card.duracao != null && card.tipo == CardType.regra) info.add(Text('Duração: ${card.duracao}', style: style));
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = BorderRadius.circular(24);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: border,
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: border,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(_titleForType(card.tipo),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  card.texto,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: _extraInfo(theme.textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
