import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_category.dart';
import '../widgets/filter_chips.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7C4DFF), Color(0xFF00BCD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: game.isReady
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Text(
                          "🍻 Beber com Amigos",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Prepare-se para desafios, verdades e muita diversão!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 20),

                        // Meta
                        if (game.meta.isNotEmpty)
                          Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${game.meta['nome'] ?? 'Jogo'} • v${game.meta['versao'] ?? '1.0'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Filtros: Categorias
                        Card(
                          elevation: 0,
                          color: Colors.white.withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: FilterChips(
                              title: 'Categorias',
                              values: game.categories
                                  .map((GameCategory c) => FilterOption(c.id, c.nome))
                                  .toList(),
                              selected: game.selectedCategoryIds,
                              onToggle: game.toggleCategory,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Filtros: Nível  (AGORA FUNCIONA)
                        Card(
                          elevation: 0,
                          color: Colors.white.withOpacity(0.12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: FilterChips(
                              title: 'Nível',
                              values: const [
                                FilterOption('leve', 'Leve'),
                                FilterOption('medio', 'Médio'),
                                FilterOption('pesado', 'Pesado'),
                              ],
                              selected: game.selectedLevels,   // <-- usa o estado do provider
                              onToggle: game.toggleLevel,      // <-- chama o método do provider
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 18+
                        Row(
                          children: [
                            Switch(
                              value: game.show18Plus,
                              onChanged: game.setShow18Plus,
                            ),
                            const Text('Mostrar conteúdo 18+', style: TextStyle(color: Colors.white)),
                          ],
                        ),

                        const Spacer(),

                        // Botão iniciar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF7C4DFF),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            ),
                            icon: const Icon(Icons.play_arrow_rounded, size: 28),
                            label: const Text(
                              "COMEÇAR A JOGAR",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 450),
                                  pageBuilder: (_, __, ___) => const GameScreen(),
                                  transitionsBuilder: (_, anim, __, child) =>
                                      FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut), child: child),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Beba com moderação 🍷",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
