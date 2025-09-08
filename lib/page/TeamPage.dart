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
            child: Obx(() {
              nameController.text = controller.teamName.value;
              return TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Team Name",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (val) => controller.saveTeamName(val),
              );
            }),
          ),

          const SizedBox(height: 10),
          const Text(
            "Pokémon ทั้งหมด (กดเลือก/ลบได้)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Grid แสดง Pokémon ทั้งหมด
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredPokemons;
              if (list.isEmpty) {
                return const Center(child: Text("No Pokémon found"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];

                  return Obx(() {
                    final isSelected = controller.selected.contains(p.id);

                    return GestureDetector(
                      onTap: () => controller.toggle(p, context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Colors.blue.shade50 : Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
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
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.blue),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),

          // ปุ่มบันทึก
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.saveTeamName(nameController.text);
                      controller.saveTeam();
                      Get.to(() => TeamDetailPage()); // ไปหน้าโชว์ทีม
                    },
                    child: const Text("Save & View Team"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
