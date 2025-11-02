import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import 'package:audioplayers/audioplayers.dart';

import '../models/game_card.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _player = AudioPlayer();
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _flipped = !_flipped;
      _flipped ? _controller.forward() : _controller.reverse();
    });
  }

  Future<void> _playRuleSound() async {
    try {
      await _player.play(AssetSource('sounds/bell.mp3'));
    } catch (e) {
      debugPrint("Erro ao tocar som: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final card = game.currentCard;
    final hasActiveRule = game.activeRules.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rodada"),
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔔 Barra de regra ativa
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: hasActiveRule
                    ? Padding(
                        key: const ValueKey("activeRule"),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.white70, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: game.activeRules.map((r) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  "🔔 Regra ativa: ${r.ruleCard.texto} "
                                  "${r.remainingRounds < 0 ? '(até cancelar)' : '(restam ${r.remainingRounds} rodadas)'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : const SizedBox(height: 10),
              ),

              const Spacer(),

              // 🃏 Card
              if (card != null)
                GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final angle = _controller.value * math.pi;
                      return Transform(
                        alignment: Alignment.center,
                        transform: vm.Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: Container(
                          width: 320,
                          height: 420,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _controller.value < 0.5
                                  ? Text(
                                      card.categoria.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7C4DFF),
                                      ),
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform:
                                          vm.Matrix4.rotationY(math.pi),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                card.texto,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // selo de goles
                                          if (card.goles != null ||
                                              card.golesPenalidade != null)
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF7C4DFF)
                                                          .withOpacity(0.9),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(24),
                                                  ),
                                                ),
                                                child: Text(
                                                  _formatGolesInfo(card),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const Spacer(),

              // 🎯 Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (card?.tipo == CardType.regra)
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.rule),
                      label: const Text("Aplicar Regra"),
                      onPressed: () {
                        game.applyCurrentIfRule();
                        _playRuleSound();
                      },
                    ),
                  if (hasActiveRule) ...[
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancelar Regras"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                      ),
                      onPressed: () => game.cancelAllRules(),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.shuffle),
                label: const Text("PRÓXIMA CARTA"),
                onPressed: () => game.drawNext(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7C4DFF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _formatGolesInfo(GameCard card) {
    final parts = <String>[];
    if (card.goles != null) parts.add("${card.goles} goles");
    if (card.golesPenalidade != null) {
      parts.add("Penalidade: ${card.golesPenalidade}");
    }
    if (parts.isEmpty) return "";
    return parts.join(" • ");
  }
}
