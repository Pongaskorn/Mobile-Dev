import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobiledev/page/TeamPage.dart';

class Pokemon {
  final int id;
  final String name;

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  Pokemon({required this.id, required this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json, int index) {
    return Pokemon(id: index + 1, name: json['name']);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class PokemonController extends GetxController {
  final pokemons = <Pokemon>[].obs;
  final selected = <int>{}.obs;
  final isLoading = false.obs;
  final teamName = ''.obs;
  final searchQuery = ''.obs;

  final storage = GetStorage();
  final int maxSelected = 3;

  @override
  void onInit() {
    super.onInit();
    fetchPokemons().then((_) => loadTeam());
  }

  Future<void> fetchPokemons() async {
    isLoading.value = true;
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=30");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = (data['results'] as List)
          .asMap()
          .entries
          .map((e) => Pokemon.fromJson(e.value, e.key))
          .toList();
      pokemons.assignAll(list);
    }
    isLoading.value = false;
  }

  bool toggle(Pokemon p, BuildContext context) {
    if (selected.contains(p.id)) {
      selected.remove(p.id);
      saveTeam();
      return true;
    } else {
      if (selected.length < maxSelected) {
        selected.add(p.id);
        saveTeam();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("เลือกได้สูงสุด 3 ตัวเท่านั้น"),
            duration: Duration(seconds: 1),
          ),
        );
        return false;
      }
    }
  }

  void reset() {
    selected.clear();
    teamName.value = "My Team"; // รีเซ็ตชื่อทีมด้วย
    saveTeam();
  }

  void loadTeam() {
    final savedName = storage.read('teamName');
    final savedIds = storage.read<List>('teamSelected');

    teamName.value = savedName ?? "My Team";
    if (savedIds != null) selected.addAll(savedIds.cast<int>());
  }

  void saveTeam() {
    storage.write('teamName', teamName.value);
    storage.write('teamSelected', selected.toList());
  }

  void saveTeamName(String name) {
    teamName.value = name;
    saveTeam();
  }

  List<Pokemon> get filteredPokemons {
    if (searchQuery.value.isEmpty) return pokemons;
    return pokemons
        .where(
          (p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }
}

/// ================== Widgets ==================

class TeamNameField extends StatelessWidget {
  final PokemonController controller;
  final TextEditingController nameController;
  const TeamNameField({
    super.key,
    required this.controller,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final PokemonController controller;
  final TextEditingController searchController;
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.searchController,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          labelText: "Search Pokémon",
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (val) => controller.searchQuery.value = val,
      ),
    );
  }
}

class SelectedPokemonsRow extends StatelessWidget {
  final PokemonController controller;
  const SelectedPokemonsRow({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedPokemons = controller.pokemons
          .where((p) => controller.selected.contains(p.id))
          .toList();
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                "Selected: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...selectedPokemons.map((p) {
              return GestureDetector(
                onTap: () => controller.toggle(p, context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: "pokemon_${p.id}",
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(p.imageUrl),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          p.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

class PokemonGridItem extends StatelessWidget {
  final Pokemon p;
  final bool isSelected;
  final VoidCallback onTap;
  const PokemonGridItem({
    super.key,
    required this.p,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Hero(
                tag: "pokemon_${p.id}",
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(p.imageUrl),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              p.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      key: ValueKey(1),
                    )
                  : const SizedBox(key: ValueKey(0)),
            ),
          ],
        ),
      ),
    );
  }
}

///  Main
class PlayersSelection extends StatelessWidget {
  const PlayersSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PokemonController());
    final searchController = TextEditingController();
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Players Selection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Save Team",
            onPressed: () {
              controller.saveTeam();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Team saved successfully!")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Team",
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("ยืนยัน"),
                  content: const Text(
                    "คุณต้องการรีเซ็ตทีมและล้างชื่อทั้งหมดหรือไม่?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("ยกเลิก"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.reset();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ทีมถูกรีเซ็ตแล้ว")),
                        );
                      },
                      child: const Text("ตกลง"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แสดงชื่อทีมด้านบน
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Team: ${controller.teamName.value}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Get.to(() => TeamPage());
                    },
                  ),
                ],
              ),
            ),
          ),

          SelectedPokemonsRow(controller: controller),
          TeamNameField(controller: controller, nameController: nameController),
          SearchBarWidget(
            controller: controller,
            searchController: searchController,
          ),
          const Divider(),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final p = list[index];
                  return Obx(() {
                    final isSelected = controller.selected.contains(p.id);
                    return PokemonGridItem(
                      p: p,
                      isSelected: isSelected,
                      onTap: () => controller.toggle(p, context),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
