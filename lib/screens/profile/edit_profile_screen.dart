import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/textfield_component.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/services/user/user_services_implementation.dart';
import 'package:uas_flutter/themes.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userService = UserServiceImplementation();
  UserModel? _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna saat ini
  Future<void> _loadUserData() async {
    final userData = await userService.getUserData();
    if (userData != null) {
      setState(() {
        _user = userData;
        nameController.text = _user?.username ?? '';
        bioController.text = _user?.bio ?? ''; 
      });
    }
  }

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

  // Fungsi untuk mengupdate profil pengguna
  Future<void> _submitProfile() async {
    final name = nameController.text.trim();
    final bio = bioController.text.trim();
    final email = userService.supabase.auth.currentUser?.email;

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated!')),
      );
      return;
    }

    try {
      String? profileImageUrl;
      if (_image != null) {
        final fileExt = _image!.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = 'profile_images/$fileName';

        await userService.supabase.storage
            .from('profile_images')
            .upload(filePath, File(_image!.path));

        profileImageUrl = userService.supabase.storage
            .from('profile_images')
            .getPublicUrl(filePath);
      }

      await userService.supabase.from('tb_users').update({
        if (profileImageUrl != null) 'profile_image': profileImageUrl,
        'username': name,
        'bio': bio, // Update bio
      }).eq('email', email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      // Perbarui data setelah menyimpan
      _loadUserData();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: HeaderButtonComponent(
        title: "Edit Profile",
        leadingIcon: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : _user?.profileImage != null
                        ? NetworkImage(_user!.profileImage!)
                        : null,
                child: _image == null && _user?.profileImage == null
                    ? const Icon(Icons.camera_alt,
                        size: 30, color: Colors.black54)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            TextfieldComponent(
              controller: nameController,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              hint: "Enter your name",
            ),
            const SizedBox(height: 20),

            TextfieldComponent(
              controller: bioController,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              hint: "Enter your bio",
            ),
            const SizedBox(height: 30),

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
