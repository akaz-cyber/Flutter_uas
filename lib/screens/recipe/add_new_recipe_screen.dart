import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/textfield_component.dart';
import 'package:uas_flutter/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Tambahresep extends StatefulWidget {
  const Tambahresep({super.key});

  @override
  State<Tambahresep> createState() => _TambahresepState();
}

class _TambahresepState extends State<Tambahresep> {
  File? _imageFile;
  List<File?> stepImages = [];
  List<TextEditingController> ingredientsControllers = [];
  List<TextEditingController> stepsControllers = [];
  final TextEditingController titleController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickStepImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        stepImages[index] = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ingredientsControllers.add(TextEditingController());
    stepsControllers.add(TextEditingController());
    stepImages.add(null);
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var controller in ingredientsControllers) {
      controller.dispose();
    }
    for (var controller in stepsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addIngredient() {
    setState(() {
      ingredientsControllers.add(TextEditingController());
    });
  }

  void removeIngredient(int index) {
    setState(() {
      ingredientsControllers[index].dispose();
      ingredientsControllers.removeAt(index);
    });
  }

  void addStep() {
    setState(() {
      stepsControllers.add(TextEditingController());
      stepImages.add(null);
    });
  }

  void removeStep(int index) {
    setState(() {
      stepsControllers[index].dispose();
      stepsControllers.removeAt(index);
      stepImages.removeAt(index);
    });
  }


void _publishRecipe() async {
  try {
    final supabase = Supabase.instance.client;
    final title = titleController.text;
    final ingredients =
        ingredientsControllers.map((controller) => controller.text).toList();
    final steps =
        stepsControllers.map((controller) => controller.text).toList();

    if (title.isEmpty || _imageFile == null || ingredients.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data")),
      );
      return;
    }

    // Upload Gambar Utama
    String? imageUrl;
    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      await supabase.storage.from('resep_images').uploadBinary(fileName, imageBytes);
      imageUrl = supabase.storage.from('resep_images').getPublicUrl(fileName);
    }

    // Upload Gambar Langkah-langkah
    List<String> stepImagesUrls = [];
    for (var image in stepImages) {
      if (image != null) {
        final imageBytes = await image.readAsBytes();
        final fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
        await supabase.storage.from('resep_images').uploadBinary(fileName, imageBytes);
        stepImagesUrls.add(supabase.storage.from('resep_images').getPublicUrl(fileName));
      } else {
        stepImagesUrls.add('');
      }
    }

    // Simpan Data ke Database
    final response = await supabase.from('Tambahresep').insert({
      'title': title,
      'image_utama': imageUrl,
      'ingredients': ingredients.join(', '),
      'steps': steps.join(', '),
      'steps_image': stepImagesUrls.join(', '),
      'created_at': DateTime.now().toIso8601String(),
    }).select();

    if (response == null || response.isEmpty) {
      throw Exception("Gagal menyimpan resep. Response null atau kosong.");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Resep berhasil disimpan!")),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi kesalahan: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: HeaderButtonComponent(
          title: "Add New Recipe",
          leadingIcon: const Icon(Icons.arrow_back),
          onLeadingIconPressed: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Utama
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: grayColor, width: 2),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image_outlined,
                                size: 40, color: Colors.black54),
                            const SizedBox(height: 8),
                            Text("photo", style: lightText14),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text("Title", style: mediumText14),
              const SizedBox(height: 8),
              TextfieldComponent(
                controller: titleController,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done,
                hint: "Masukkan judul",
              ),
              const SizedBox(height: 20),

              // Ingredients
              Text("Ingredients", style: mediumText14),
              const SizedBox(height: 8),

              Column(
                children: List.generate(ingredientsControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextfieldComponent(
                            controller: ingredientsControllers[index],
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            hint: "Masukkan bahan",
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeIngredient(index),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              TextButton.icon(
                onPressed: addIngredient,
                icon: const Icon(Icons.add, color: Colors.black),
                label: Text("Add more ingredients",
                    style: mediumText14.copyWith(color: Colors.black)),
              ),

              const SizedBox(height: 20),

              // Steps
              Text("Steps", style: mediumText14),
              const SizedBox(height: 8),

              Column(
                children: List.generate(stepsControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextfieldComponent(
                            controller: stepsControllers[index],
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            hint: "Masukkan langkah",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: stepImages[index] == null
                              ? IconButton(
                                  icon: const Icon(Icons.image,
                                      color: Colors.grey),
                                  onPressed: () => _pickStepImage(index),
                                )
                              : GestureDetector(
                                  onTap: () => _pickStepImage(index),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      stepImages[index]!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeStep(index),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              TextButton.icon(
                onPressed: addStep,
                icon: const Icon(Icons.add, color: Colors.black),
                label: Text("Add more steps",
                    style: mediumText14.copyWith(color: Colors.black)),
              ),

              const SizedBox(height: 20),

              // Save & Publish Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: backgroundPrimary),
                      ),
                      child: Text("Save",
                          style: semiBoldText16.copyWith(
                              color: backgroundPrimary)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _publishRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Publish",
                          style: semiBoldText16.copyWith(color: whiteColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
