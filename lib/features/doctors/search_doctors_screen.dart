import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/services/doctor_service.dart';
import 'package:grad_project/features/doctors/doctor_details_screen.dart';

class SearchDoctorsScreen extends StatefulWidget {
  const SearchDoctorsScreen({super.key});

  @override
  State<SearchDoctorsScreen> createState() => _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends State<SearchDoctorsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> allDoctors = [];
  List<dynamic> filteredDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    try {
      final data = await DoctorService().getDoctors(limit: 50);
      if (!mounted) return;
      setState(() {
        allDoctors = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _search(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        filteredDoctors = [];
      } else {
        filteredDoctors = allDoctors.where((doctor) {
          final name =
              doctor["userId"]?["fullName"]?.toString().toLowerCase() ?? "";
          final specialty = doctor["specialty"]?.toString().toLowerCase() ?? "";
          final query = value.toLowerCase();
          return name.contains(query) || specialty.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Search Doctors")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Search Field ──
            TextField(
              controller: searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search by name or specialty...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Results ──
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredDoctors.isEmpty
                  ? Center(
                      child: Text(
                        searchController.text.isEmpty
                            ? "Start typing to search..."
                            : "No doctors found",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        final name = doctor["userId"]?["fullName"] ?? "Unknown";
                        final specialty = doctor["specialty"] ?? "";
                        final photo = doctor["userId"]?["profilePhoto"] ?? "";

                        return Card(
                          color: Theme.of(context).cardColor,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFE8F1FB),
                              backgroundImage: photo.isNotEmpty
                                  ? NetworkImage(photo)
                                  : null,
                              child: photo.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Color(0xFF0E73B8),
                                    )
                                  : null,
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              specialty,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DoctorDetailsScreen(doctorData: doctor),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
