import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/textfield_component.dart';
import 'package:uas_flutter/services/user/user_services_implementation.dart';
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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController serveController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final UserService = UserServiceImplementation();
  String? userId;

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
     _fetchLoggedUser();
      ingredientsControllers.add(TextEditingController());
      stepsControllers.add(TextEditingController());
      stepImages.add(null);
   
  }

    void _fetchLoggedUser() {
      UserService.getUserData().then((user) => {
            setState(() {
              userId = user?.id!;
            })
          });
    }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    serveController.dispose();
    timeController.dispose();
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
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Anda harus login terlebih dahulu!")),
        );
        return;
      }
      final supabase = Supabase.instance.client;
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final serveAmount = num.tryParse(serveController.text.trim()) ?? 1;
      final timeConsumed = timeController.text.trim();
      final ingredients = ingredientsControllers
          .map((controller) => controller.text.trim())
          .toList();
      final steps =
          stepsControllers.map((controller) => controller.text.trim()).toList();

      if (title.isEmpty ||
          _imageFile == null ||
          ingredients.isEmpty ||
          steps.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon lengkapi semua data")),
        );
        return;
      }

      String? imageUrl;
      if (_imageFile != null) {
        final imageBytes = await _imageFile!.readAsBytes();
        final fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
        await supabase.storage
            .from('recipe_images')
            .uploadBinary(fileName, imageBytes);
        imageUrl =
            supabase.storage.from('recipe_images').getPublicUrl(fileName);
      }

      List<String> stepImagesUrls = [];
      for (var image in stepImages) {
        if (image != null) {
          final imageBytes = await image.readAsBytes();
          final fileName =
              'images/${DateTime.now().millisecondsSinceEpoch}.png';
          await supabase.storage
              .from('recipe_images')
              .uploadBinary(fileName, imageBytes);
          stepImagesUrls.add(
              supabase.storage.from('recipe_images').getPublicUrl(fileName));
        } else {
          stepImagesUrls.add('');
        }
      }

      final response = await supabase.from('tb_recipes').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'serve_amount': serveAmount,
        'time_consumed': timeConsumed,
        'image': imageUrl,
        'ingredients': ingredients.join(', '),
        'steps': steps.join(', '),
        'steps_image': stepImagesUrls.join(', ')
      }).select();

      if (response.isEmpty) {
        throw Exception("Gagal menyimpan resep. Data tidak masuk ke database.");
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resep berhasil disimpan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
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

              // Description
              Text("Description", style: mediumText14),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 10, // Maksimal 5 baris
                minLines: 7, // Minimal 3 baris
                decoration: const InputDecoration(
                  hintText: "Masukkan deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Serve
              Text("Serve", style: mediumText14),
              const SizedBox(height: 8),
              TextField(
                controller: serveController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: "Masukkan serve"),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),

              // Time consumed
              Text("Time consumed", style: mediumText14),
              const SizedBox(height: 8),
              TextfieldComponent(
                controller: timeController,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done,
                hint: "Masukkan waktu di buat",
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
