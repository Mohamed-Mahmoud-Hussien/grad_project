import 'package:flutter/material.dart';
import 'package:grad_project/core/api/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController    = TextEditingController();
  final phoneController   = TextEditingController();
  final addressController = TextEditingController();
  String gender   = "male";
  bool isLoading  = false;
  bool isSaving   = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text    = prefs.getString('fullName') ?? '';
      phoneController.text   = prefs.getString('phone') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      gender = prefs.getString('gender') ?? 'male';
      isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Name cannot be empty")));
      return;
    }

    setState(() => isSaving = true);

    try {
      // ✅ بعت التعديل للـ Backend مباشرة بدون AuthService
      await DioClient.dio.put(
        '/auth/me',
        data: {
          "fullName": nameController.text.trim(),
          "phone":    phoneController.text.trim(),
          "address":  addressController.text.trim(),
        },
      );

      // ✅ حدّث الـ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', nameController.text.trim());
      await prefs.setString('phone',    phoneController.text.trim());
      await prefs.setString('address',  addressController.text.trim());
      await prefs.setString('gender',   gender);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // ✅ true = فيه تغيير
    } on DioException catch (e) {
      if (!mounted) return;
      final msg = e.response?.data["message"] ?? "Update failed";
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Edit Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFF0E73B8),
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    items: const [
                      DropdownMenuItem(value: "male",   child: Text("Male")),
                      DropdownMenuItem(value: "female", child: Text("Female")),
                    ],
                    onChanged: (value) => setState(() => gender = value!),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E73B8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes",
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}