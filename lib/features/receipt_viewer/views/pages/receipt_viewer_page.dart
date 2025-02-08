import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

@RoutePage()
class ReceiptViewerPage extends StatelessWidget {
  final String filePath;

  const ReceiptViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: context.maybePop, icon: Icon(LucideIcons.chevronLeft)),
        title: Text(AppStrings.viewCreatedReceipts),
      ),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}

// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// PDFViewerScreen(pdfPath: receipt['path']!),
// ),
// );

// PDFView(
// filePath: pdfPath, // Provide the file path
// enableSwipe: true,
// swipeHorizontal: true,
// autoSpacing: true,
// pageFling: true,
// ),
