import 'package:flutter/material.dart';

class SearchDoctorsScreen extends StatefulWidget {
  const SearchDoctorsScreen({super.key});

  @override
  State<SearchDoctorsScreen> createState() => _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends State<SearchDoctorsScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> doctors = [
    "Dr. Ahmed Mohamed",
    "Dr. Mahmoud Ali",
    "Dr. Sara Hassan",
    "Dr. Mohamed Adel",
    "Dr. Omar Hassan",
    "Dr. Mariam Ahmed",
  ];

  List<String> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = [];
  }

  void searchDoctor(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        filteredDoctors = [];
      } else {
        filteredDoctors = doctors.where((doctor) {
          return doctor.toLowerCase().contains(value.toLowerCase());
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
            TextField(
              controller: searchController,
              onChanged: searchDoctor,

              decoration: InputDecoration(
                hintText: "Search doctor...",
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Theme.of(context).cardColor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,

                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).cardColor,

                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),

                      title: Text(filteredDoctors[index]),

                      trailing: const Icon(Icons.arrow_forward_ios),

                      onTap: () {
                        
                      },
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
