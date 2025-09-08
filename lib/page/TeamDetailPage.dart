import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiledev/page/playersseletion.dart';

class TeamDetailPage extends StatelessWidget {
  final controller = Get.find<PokemonController>();

  @override
  Widget build(BuildContext context) {
    final selectedPokemons = controller.pokemons
        .where((p) => controller.selected.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.teamName.value),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "Team: ${controller.teamName.value}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: selectedPokemons.isEmpty
                ? const Center(child: Text("ยังไม่ได้เลือก Pokémon"))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: selectedPokemons.length,
                    itemBuilder: (context, index) {
                      final p = selectedPokemons[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue.shade50,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(p.imageUrl),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
