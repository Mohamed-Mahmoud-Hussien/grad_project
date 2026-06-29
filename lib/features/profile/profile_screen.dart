/*import 'package:flutter/material.dart';
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
*/ /*
import 'package:flutter/material.dart';
import 'package:grad_project/features/profile/edit_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? address;
  final String? dateOfBirth;

  const ProfileScreen({
    super.key,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.dateOfBirth,
  });

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.02 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF0E73B8)),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;

  String? cachedName;
  String? cachedEmail;
  String? cachedPhone;
  String? cachedGender;
  String? cachedAddress;
  String? cachedDob;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cachedName = prefs.getString('fullName') ?? widget.fullName;
      cachedEmail = prefs.getString('email') ?? widget.email;
      cachedPhone = prefs.getString('phone') ?? widget.phone;
      cachedGender = prefs.getString('gender') ?? widget.gender;
      cachedAddress = prefs.getString('address') ?? widget.address;
      cachedDob = prefs.getString('dob') ?? widget.dateOfBirth;
    });
  }

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

  String _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return "--";
    try {
      DateTime birthDate = DateTime.parse(dobString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    String age = _calculateAge(cachedDob);

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
                  const SizedBox(height: 15),
                  Text(
                    cachedName ?? "No Name Provided",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    cachedEmail ?? "No Email",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
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
                          "$age Years",
                          Icons.cake_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Gender",
                          // الـ null-safety هنا بيحمي التطبيق لو القيمة راجعة بـ null
                          cachedGender != null
                              ? cachedGender!.toUpperCase()
                              : "NOT SPECIFIED",
                          Icons.person_outline,
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
                          "Phone",
                          cachedPhone ?? "No Phone Number",
                          Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileScreen._infoCard(
                          context,
                          "Address",
                          cachedAddress ?? "No Address Provided",
                          Icons.location_on_outlined,
                        ),
                      ),
                    ],
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
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
*/
import 'package:flutter/material.dart';
import 'package:grad_project/features/profile/edit_profile_screen.dart';
import 'package:grad_project/features/profile/profile_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? address;
  final String? dateOfBirth;

  const ProfileScreen({
    super.key,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.address,
    this.dateOfBirth,
  });

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.02 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF0E73B8)),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;
  bool _isLoading = true; // ✅ loading state

  String? cachedName;
  String? cachedEmail;
  String? cachedPhone;
  String? cachedGender;
  String? cachedAddress;
  String? cachedDob;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    // ✅ أولاً: اعرض البيانات المحفوظة بسرعة لو موجودة
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cachedName = prefs.getString('fullName') ?? widget.fullName;
      cachedEmail = prefs.getString('email') ?? widget.email;
      cachedPhone = prefs.getString('phone') ?? widget.phone;
      cachedGender = prefs.getString('gender') ?? widget.gender;
      cachedAddress = prefs.getString('address') ?? widget.address;
      cachedDob = prefs.getString('dob') ?? widget.dateOfBirth;
    });

    // ✅ ثانياً: اجيب من الـ API عشان تحدث البيانات
    final freshData = await ProfileService.fetchAndCacheProfile();
    if (freshData != null && mounted) {
      setState(() {
        cachedName = freshData['fullName'] ?? cachedName;
        cachedEmail = freshData['email'] ?? cachedEmail;
        cachedPhone = freshData['phone'] ?? cachedPhone;
        cachedGender = freshData['gender'] ?? cachedGender;
        cachedAddress = freshData['address'] ?? cachedAddress;
        cachedDob = freshData['dateOfBirth']?.toString() ?? cachedDob;
      });
    }

    if (mounted) setState(() => _isLoading = false);
  }

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

  String _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return "--";
    try {
      DateTime birthDate = DateTime.parse(dobString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    String age = _calculateAge(cachedDob);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      extendBodyBehindAppBar: true,
      body: _isLoading && cachedName == null
          // ✅ لو أول مرة وفي loading، اعرض indicator
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0E73B8)),
            )
          : RefreshIndicator(
              // ✅ pull to refresh
              color: const Color(0xFF0E73B8),
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
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
                          const SizedBox(height: 15),
                          Text(
                            cachedName ?? "No Name Provided",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            cachedEmail ?? "No Email",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: ProfileScreen._infoCard(
                                  context,
                                  "Age",
                                  age == "--" ? "--" : "$age Years",
                                  Icons.cake_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ProfileScreen._infoCard(
                                  context,
                                  "Gender",
                                  cachedGender != null &&
                                          cachedGender!.isNotEmpty
                                      ? cachedGender!.toUpperCase()
                                      : "NOT SPECIFIED",
                                  Icons.person_outline,
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
                                  "Phone",
                                  cachedPhone != null && cachedPhone!.isNotEmpty
                                      ? cachedPhone!
                                      : "No Phone",
                                  Icons.phone_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ProfileScreen._infoCard(
                                  context,
                                  "Address",
                                  cachedAddress != null &&
                                          cachedAddress!.isNotEmpty
                                      ? cachedAddress!
                                      : "No Address",
                                  Icons.location_on_outlined,
                                ),
                              ),
                            ],
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                final updated = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfileScreen(),
                                  ),
                                );
                                if (updated == true) _loadUserData();
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
            ),
    );
  }
}
