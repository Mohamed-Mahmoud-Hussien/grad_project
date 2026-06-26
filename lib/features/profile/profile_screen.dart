import 'package:flutter/material.dart';
import 'package:grad_project/features/auth/screens/login_screen.dart';
import 'package:grad_project/features/profile/edit_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Widget _infoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF0E73B8)),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E73B8), Color(0xFF4F7DFF)],
                ),
              ),

              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (profileImage != null) {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.file(profileImage!),
                                ),
                              ),
                            );
                          }
                        },

                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,

                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,

                          child: profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Color(0xFF0E73B8),
                                )
                              : null,
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: GestureDetector(
                          onTap: pickImage,

                          child: Container(
                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              color: const Color(0xFF0E73B8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),

                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Abdulrahman",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text("PT-2035-001", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Age",
                          "20",
                          Icons.cake,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Blood",
                          "A+",
                          Icons.bloodtype,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Gender",
                          "Male",
                          Icons.person,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Phone",
                          "+20",
                          Icons.phone,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Medical Information",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.health_and_safety),
                          title: Text("Allergies"),
                          subtitle: Text("No allergies"),
                        ),

                        Divider(),

                        ListTile(
                          leading: Icon(Icons.medical_services),
                          title: Text("Chronic Diseases"),
                          subtitle: Text("None"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Emergency Contact",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Ahmed Mostafa"),
                          subtitle: Text("Father"),
                        ),

                        Divider(),

                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text("+20 100 987 6543"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.lock_outline),
                          title: Text("Change Password"),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        ),

                        Divider(height: 1),

                        ListTile(
                          leading: Icon(Icons.language),
                          title: Text("Language"),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        ),

                        Divider(height: 1),

                        ListTile(
                          leading: Icon(Icons.help_outline),
                          title: Text("Help Center"),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),

                      label: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E73B8),
                        foregroundColor: Colors.white,
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
