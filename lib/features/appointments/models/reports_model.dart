class ReportModel {
  final String title;
  final String fileUrl;
  final String size;
  final String uploadedAt;

  ReportModel({
    required this.title,
    required this.fileUrl,
    required this.size,
    required this.uploadedAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json["title"] ?? "",
      fileUrl: json["fileUrl"] ?? "",
      size: json["size"] ?? "",
      uploadedAt: json["uploadedAt"] ?? "",
    );
  }
}