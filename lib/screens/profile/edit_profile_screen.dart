import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/textfield_component.dart';
import 'package:uas_flutter/themes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "Sigit Rendang");
  final TextEditingController bioController =
      TextEditingController(text: "Penikmat rendang");

  File? _image; // Variabel untuk menyimpan gambar yang dipilih

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitProfile() {
    final name = nameController.text;
    final bio = bioController.text;

    print('Name: $name');
    print('Bio: $bio');

    if (_image != null) {
      print('Profile Image: ${_image!.path}');
    } else {
      print('No profile image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: HeaderButtonComponent(title: "Edit Profile", leadingIcon: 
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Profil dengan GestureDetector untuk memilih gambar
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt,
                        size: 30, color: Colors.black54)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Input Nama
            TextfieldComponent(
              controller: nameController,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              hint: "Enter your name",
            ),
            const SizedBox(height: 20),

            // Input Bio
            TextfieldComponent(
              controller: bioController,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              hint: "Enter your bio",
            ),
            const SizedBox(height: 30),

            // Tombol Save
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Save",
                  style: semiBoldText20.copyWith(color: whiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
