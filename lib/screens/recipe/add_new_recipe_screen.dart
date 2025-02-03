import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    stepImages.add(null); // Inisialisasi pertama kali
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 40, color: Colors.black54),
                            SizedBox(height: 8),
                            Text("photo",
                                style: TextStyle(color: Colors.black54)),
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
              const Text("Title",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  hintText: "Masukkan judul",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ),
              const SizedBox(height: 20),

              // Ingredients
              const Text("Ingredients",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Column(
                children: List.generate(ingredientsControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ingredientsControllers[index],
                            decoration: const InputDecoration(
                              hintText: "Masukkan bahan",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
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
                label: const Text("Add more ingredient",
                    style: TextStyle(color: Colors.black)),
              ),

              const SizedBox(height: 20),

              // Steps
              const Text("Steps",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Column(
                children: List.generate(stepsControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: stepsControllers[index],
                            decoration: const InputDecoration(
                              hintText: "Masukkan langkah",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
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
                label: const Text("Add more step",
                    style: TextStyle(color: Colors.black)),
              ),

              const SizedBox(height: 20),

              // Save & Publish Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
          
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Colors.orange),
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.orange)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Publish",
                        style: TextStyle(color: Colors.white)),
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
