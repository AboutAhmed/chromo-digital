import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/config/routes/routes.gr.dart';
import 'package:chromo_digital/core/card/my_card.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/di/service_locator.dart';
import 'package:chromo_digital/core/extensions/build_context_extension.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/widgets/empty_state.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt/receipt.dart';
import 'package:chromo_digital/features/receipts/view_models/receipts/receipts_cubit.dart';
import 'package:chromo_digital/features/receipts/views/widgets/delete_receipt_confirmation.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

part '../widgets/receipt_tile.dart';

@RoutePage()
class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({super.key});

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  final ReceiptsCubit _receiptsCubit = sl<ReceiptsCubit>();

  @override
  void initState() {
    super.initState();
    _receiptsCubit.getAllReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: context.maybePop, icon: Icon(LucideIcons.chevronLeft))),
      body: BlocBuilder<ReceiptsCubit, ReceiptsState>(
        bloc: _receiptsCubit,
        builder: (context, state) {
          return state.match(
            onInitial: () => const Center(child: CircularProgressIndicator()),
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onError: (message) => EmptyState.fail(
              title: Text(message),
              icon: Icon(LucideIcons.fileText, size: 80.0, color: context.error),
              onRetry: () => _receiptsCubit.getAllReceipts(),
            ).center(),
            onReceiptsLoaded: (items) => CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(AppStrings.receipts),
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                ),
                if (items.isEmpty)
                  SliverFillRemaining(
                    child: EmptyState(
                      title: Text(AppStrings.noReceiptsFound),
                      subtitle: Text(AppStrings.yourReceiptsWillBeDisplayedHere),
                      icon: Icon(LucideIcons.fileText),
                    ).paddingOnly(bottom: 200.0).center(),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _ReceiptTile(
                          item: item,
                          onTap: (item) => context.pushRoute(ReceiptViewerRoute(filePath: item.filePath)),
                          sendEmail: _sendFileInEmailAsAttachment,
                          downloadFile: _downloadFile,
                          onReceiptDeleted: onReceiptDeleted,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12.00),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  void onReceiptDeleted(Receipt item) async {
    try {
      context.showAppGeneralDialog(title: AppStrings.deleteReceipt, child: DeleteReceiptConfirmation()).then((value) {
        if (value == null || value == false) return;
        _receiptsCubit.deleteReceipt(item.id).then((_) {
          // delete file from storage
          File(item.filePath).deleteSync();
        });
        context
          ..mounted
          ..showToast(AppStrings.receiptDeletedSuccessfully);
      });
    } catch (e) {
      context
        ..mounted
        ..showToast("${AppStrings.errorDeletingReceipt}: ${e.toString()}");
    }
  }

  // send file in email
  Future<void> _sendFileInEmailAsAttachment(Receipt item) async {
    try {
      String body = '''
      Hello,

I hope this message finds you well. Please find below the details of your receipt:

Receipt ID: ${item.id}
Name: ${item.name}
Created At: ${item.createdAt.format(format: 'dd-MM-yyyy hh:mm aa')}

If you have any questions or need further assistance, feel free to reach out.

Best regards,
Chromo Digital Team
      ''';
      Log.i(runtimeType, item.filePath);
      final Email email = Email(
        body: body,
        subject: '${AppStrings.receipts} - ${item.name}',
        attachmentPaths: [item.filePath],
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    } catch (e, s) {
      Log.e(runtimeType, e, s);
      context
        ..mounted
        ..showToast(e.toString());
    }
  }

  Future<void> _downloadFile(Receipt item) async {
    try {
      // Request storage permissions
      PermissionStatus status;

      if (Platform.isAndroid) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }
      } else {
        status = await Permission.storage.request();
      }

      if (!status.isGranted) {
        context
          ..mounted
          ..showToast(AppStrings.storagePermissionIsRequired);
        return;
      }

      // Let user pick directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        if (context.mounted) {
          context
            ..mounted
            ..showToast(AppStrings.noDirectorySelected);
        }
        return;
      }

      // Create a unique filename to avoid overwriting
      final String fileName = path.basenameWithoutExtension(item.name);
      String filePath = '$selectedDirectory/$fileName.pdf';

      // Add number suffix if file already exists
      int counter = 1;
      while (await File(filePath).exists()) {
        filePath = '$selectedDirectory/$fileName($counter).pdf';
        counter++;
      }

      // Copy the cached file to the new location
      final File sourceFile = File(item.filePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source PDF file not found: ${item.filePath}');
      }

      try {
        // Verify file is actually a PDF by checking header
        final List<int> headerBytes = await sourceFile.openRead(0, 4).first;
        final String header = String.fromCharCodes(headerBytes);
        if (!header.startsWith('%PDF')) {
          throw Exception('Invalid PDF file format');
        }
      } catch (e) {
        debugPrint('Warning: Could not verify PDF header: $e');
      }

      // Show progress dialog
      if (context.mounted) {
        showDialog(
          context: context..mounted,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Saving PDF...'),
                ],
              ),
            );
          },
        );
      }

      // Copy file
      await sourceFile.copy(filePath);

      // Close progress dialog
      if (context.mounted) {
        Navigator.of(context..mounted).pop();
      }

      // Show success message
      if (context.mounted) {
        context
          ..mounted
          ..showToast(AppStrings.pdfSavedTo + filePath);
      }
    } catch (e, s) {
      // Close progress dialog if it's showing
      if (context.mounted) {
        Navigator.of(context..mounted).pop();
      }
      context
        ..mounted
        ..showToast('${AppStrings.failedToSavePDF}: ${e.toString()}');
      debugPrint('Error saving PDF: $e\n$s');
    }
  }

// Future<void> _downloadFile(Receipt item) async {
//   try {
//     // Request storage permissions
//     PermissionStatus status;
//
//     if (Platform.isAndroid) {
//       // Use storage permission for all Android versions
//       status = await Permission.storage.request();
//
//       // For Android 11+ (API level 30+), also request manage external storage
//       if (!status.isGranted) {
//         status = await Permission.manageExternalStorage.request();
//       }
//     } else {
//       // For iOS
//       status = await Permission.storage.request();
//     }
//
//     if (status.isDenied) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Storage permission denied')),
//         );
//       }
//       return;
//     }
//
//     if (status.isPermanentlyDenied) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Storage permission permanently denied. Please enable in settings.'),
//             action: SnackBarAction(
//               label: 'Settings',
//               onPressed: openAppSettings,
//             ),
//           ),
//         );
//       }
//       return;
//     }
//
//     if (status.isGranted) {
//       // Get the download directory
//       Directory? directory;
//       if (Platform.isAndroid) {
//         // Try to use Documents directory first for PDFs
//         directory = Directory('/storage/emulated/0/Documents');
//         if (!await directory.exists()) {
//           directory = Directory('/storage/emulated/0/Download');
//           if (!await directory.exists()) {
//             directory = await getExternalStorageDirectory();
//           }
//         }
//       } else {
//         // Use the documents directory on iOS
//         directory = await getApplicationDocumentsDirectory();
//       }
//
//       if (directory == null) {
//         throw Exception('Could not access storage directory');
//       }
//
//       // Create a PDF directory if it doesn't exist
//       final pdfDirectory = Directory('${directory.path}/PDFs');
//       if (!await pdfDirectory.exists()) {
//         await pdfDirectory.create(recursive: true);
//       }
//
//       // Create a unique filename to avoid overwriting
//       final String fileName = path.basenameWithoutExtension(item.name);
//       String filePath = '${pdfDirectory.path}/$fileName.pdf';
//
//       // Add number suffix if file already exists
//       int counter = 1;
//       while (await File(filePath).exists()) {
//         filePath = '${pdfDirectory.path}/$fileName($counter).pdf';
//         counter++;
//       }
//
//       // Copy the cached file to the new location
//       final File sourceFile = File(item.filePath);
//       if (!await sourceFile.exists()) {
//         throw Exception('Source PDF file not found: ${item.filePath}');
//       }
//
//       try {
//         // Verify file is actually a PDF by checking header
//         final List<int> headerBytes = await sourceFile.openRead(0, 4).first;
//         final String header = String.fromCharCodes(headerBytes);
//         if (!header.startsWith('%PDF')) {
//           throw Exception('Invalid PDF file format');
//         }
//       } catch (e) {
//         // If we can't read the header, continue anyway as the extension check passed
//         debugPrint('Warning: Could not verify PDF header: $e');
//       }
//
//       await sourceFile.copy(filePath);
//
//       // Create .nomedia file in PDFs directory to prevent media scanning (Android only)
//       if (Platform.isAndroid) {
//         final nomediaFile = File('${pdfDirectory.path}/.nomedia');
//         if (!await nomediaFile.exists()) {
//           await nomediaFile.create();
//         }
//       }
//
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('PDF saved to: $filePath'),
//             action: SnackBarAction(
//               label: 'Open',
//               onPressed: () async {
//                 // You can implement PDF viewer launch logic here
//               },
//             ),
//           ),
//         );
//       }
//     }
//   } catch (e, s) {
//     debugPrint('Error saving PDF: $e\n$s');
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save PDF: ${e.toString()}')),
//       );
//     }
//   }
// }

// Future<void> _downloadFile(Receipt item) async {
//   try {
//     Log.i(runtimeType, 'downloading...');
//     final PermissionService service = sl<PermissionService>();
//     PermissionStatus permissionStatus = await Permission.storage.request();
//     if (permissionStatus.isDenied) {
//       context
//         ..mounted
//         ..showToast(AppStrings.permissionDenied);
//       return;
//     } else if (permissionStatus.isPermanentlyDenied) {
//       context
//         ..mounted
//         ..showToast(AppStrings.permissionPermanentlyDenied);
//       bool value = await service.openAppSettings();
//       if (value) {
//         _downloadFile(item);
//       }
//       return;
//     } else if (permissionStatus.isGranted) {
//       final directory = await getExternalStorageDirectory();
//       if (directory == null) {
//         Log.e(runtimeType, 'Failed to get external storage directory');
//         context
//           ..mounted
//           ..showToast('Failed to get external storage directory');
//         return;
//       }
//       final filePath = '${directory.path}/${item.name}';
//       final file = File(item.filePath);
//       if (!await file.exists()) {
//         Log.e(runtimeType, 'File does not exist: ${item.filePath}');
//         context
//           ..mounted
//           ..showToast('File does not exist: ${item.filePath}');
//         return;
//       }
//       await file.copy(filePath);
//     } else {
//       context
//         ..mounted
//         ..showToast(AppStrings.tryAgainLater);
//     }
//   } catch (e, s) {
//     debugPrint('_ReceiptsPageState._downloadFile: $e, $s');
//   }
// }
}
