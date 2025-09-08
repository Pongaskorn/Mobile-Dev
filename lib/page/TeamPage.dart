// TeamPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiledev/page/playersseletion.dart';
import 'package:mobiledev/page/TeamDetailPage.dart';


class TeamPage extends StatelessWidget {
  final controller = Get.find<PokemonController>();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: controller.teamName.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Team"),
      ),
      body: Column(
        children: [
          // ช่องแก้ไขชื่อทีม
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Team Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 10),
          const Text(
            "Pokémon ที่เลือก",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // แสดง Pokémon ที่เลือก
          Expanded(
            child: Obx(() {
              final selectedPokemons = controller.pokemons
                  .where((p) => controller.selected.contains(p.id))
                  .toList();

              if (selectedPokemons.isEmpty) {
                return const Center(child: Text("ยังไม่ได้เลือก Pokémon"));
              }

              return GridView.builder(
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
                  return GestureDetector(
                    onTap: () {
                      // ถ้ากดที่ตัวนี้ ให้ toggle (เอาออก)
                      controller.toggle(p, context);
                    },
                    child: Container(
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
                          const SizedBox(height: 6),
                          const Icon(Icons.close, color: Colors.red),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // ปุ่มบันทึก
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
  onPressed: () {
    controller.saveTeamName(nameController.text);
    controller.saveTeam(); // บันทึกทีมด้วย
    Get.to(() => TeamDetailPage()); // ไปหน้าโชว์ทีม
  },
  child: const Text("Save"),
),
          ),
        ],
      ),
    );
  }
}
