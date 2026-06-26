import 'package:flutter/material.dart';
import 'package:grad_project/features/appointments/models/reports_model.dart';
//import 'package:grad_project/features/reports/models/report_model.dart';
import 'package:grad_project/features/reports/pdf_viewer_screen.dart';
import 'package:grad_project/features/reports/report_download_service.dart';
import 'package:grad_project/features/reports/reports_service.dart';
//import 'package:grad_project/features/reports/services/reports_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isLoading = true;

  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final data = await ReportsService().getReports();

    setState(() {
      reports = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 70,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF3563E9),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medical Reports",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "All your lab results and scans",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : reports.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 90,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 20),

                        Text(
                          "No Reports Available",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Your doctor hasn't uploaded any reports yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(18),
                                  ),

                                  child: const Icon(
                                    Icons.description_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "PDF · ${report.size}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        report.uploadedAt,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,

                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PdfViewerScreen(
                                              url: report.fileUrl,
                                            ),
                                          ),
                                        );
                                      },

                                      icon: const Icon(
                                        Icons.remove_red_eye_outlined,
                                      ),

                                      label: const Text("View"),

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFDDEEFF,
                                        ),
                                        foregroundColor: const Color(
                                          0xFF3563E9,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: SizedBox(
                                    height: 50,

                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final success =
                                            await ReportDownloadService()
                                                .downloadFile(
                                                  url: report.fileUrl,
                                                  fileName: report.title,
                                                );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              success
                                                  ? "Downloaded Successfully"
                                                  : "Download Failed",
                                            ),
                                          ),
                                        );
                                      },

                                      icon: const Icon(Icons.download),

                                      label: const Text("Download"),

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF3563E9,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
