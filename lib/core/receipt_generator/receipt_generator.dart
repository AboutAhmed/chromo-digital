import 'dart:io';

import 'package:chromo_digital/core/constants/app_const.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/features/company/data/models/company.dart';
import 'package:chromo_digital/features/create_receipt/data/models/receipt_data/receipt_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

@LazySingleton()
class ReceiptGenerator {
  Future<File> generate({
    required flutter.BuildContext context,
    final String restaurantBillImagePath = '',
    required ReceiptData item,
    required final String path,
    required final String fileName,
    final Company? company,
  }) async {
    final pdf = Document();

    final regularFont = await rootBundle.load("assets/fonts/Montserrat-Regular.ttf");
    final boldFont = await rootBundle.load("assets/fonts/Montserrat-Bold.ttf");

    final ttfRegular = Font.ttf(regularFont);
    final ttfBold = Font.ttf(boldFont);

    Uint8List? waiterSignature;
    if (item.waiterSignaturePath?.isNotEmpty ?? false) waiterSignature = File(item.waiterSignaturePath!).readAsBytesSync();
    final directorSignature = File(item.managingDirectorSignaturePath).readAsBytesSync();

    final restaurantBillImageUint8List = restaurantBillImagePath.isNotEmpty ? File(restaurantBillImagePath).readAsBytesSync() : null;

    pdf.addPage(
      MultiPage(
        theme: ThemeData.withFont(base: ttfRegular, bold: ttfBold),
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.all(16),
        build: (_) => [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    context.tr(AppStrings.receiptTitle),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        context.tr(AppStrings.germanText),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    if (company?.showOnReceipt == true)
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(company!.name, style: TextStyle(fontSize: 10)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${company.street}, ', style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 4),
                                  Text(company.houseNumber, style: TextStyle(fontSize: 10)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${company.postId}, ', style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 4),
                                  Text(company.city, style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.0),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.tr(AppStrings.visitDayLabel), style: TextStyle(decoration: TextDecoration.underline)),
                                Text(
                                  item.visitDate.format(format: AppConst.dateFormat),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.tr(AppStrings.restaurantDataLabel), style: TextStyle(decoration: TextDecoration.underline)),
                                Text(
                                  '${item.restaurant.name} ${item.restaurant.address}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 2, width: double.infinity, color: PdfColor.fromInt(0xff000000)),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 20.0,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.tr(AppStrings.participantsLabel), style: TextStyle(decoration: TextDecoration.underline)),
                        ),
                        ...item.participants.map(
                          (participant) => Container(
                            height: 20.0,
                            decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(participant.name),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 20.0,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.tr(AppStrings.purposeLabel), style: TextStyle(decoration: TextDecoration.underline)),
                        ),
                        Container(
                          height: 20.0,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(item.purpose.value),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.tr(AppStrings.noteLabel), style: TextStyle(decoration: TextDecoration.underline)),
                          if (item.notes != null) Text('${item.notes}'),
                        ],
                      ),
                    ),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Container(height: 20.0, decoration: BoxDecoration(border: Border(bottom: BorderSide()))),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.tr(AppStrings.amountLabel)),
                                Text(context.tr(AppStrings.restaurantBillLabel)),
                                Text(
                                  '${item.billAmount} ${context.tr(AppStrings.euroSuffix)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.tr(AppStrings.otherCasesLabel)),
                                Text(context.tr(AppStrings.tipLabel)),
                                if (item.tipAmount != null)
                                  Text(
                                    '${item.tipAmount} ${context.tr(AppStrings.euroSuffix)}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(context.tr(AppStrings.waiterSignatureLabel)),
                                if (item.waiterSignaturePath != null && waiterSignature != null)
                                  Image(
                                    MemoryImage(waiterSignature),
                                    height: 50,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(context.tr(AppStrings.dateSignatureLabel)),
                            Text(
                              '\n${DateTime.now().format(format: AppConst.dateFormat)}',
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        SizedBox(width: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(context.tr(AppStrings.signatureLabel), style: TextStyle(decoration: TextDecoration.underline)),
                            Text(context.tr(AppStrings.managingDirectorLabel)),
                          ],
                        ),
                        SizedBox(width: 12.0),
                        Container(
                          height: 50.0,
                          alignment: Alignment.centerRight,
                          child: Image(MemoryImage(directorSignature)),
                          margin: EdgeInsets.only(bottom: 4.0, right: 4.0),
                        ),
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );

    if (restaurantBillImageUint8List != null) {
      pdf.addPage(
        Page(
          build: (context) {
            return Center(
              child: Image(MemoryImage(restaurantBillImageUint8List)),
            );
          },
        ),
      );
    }

    final file = File('$path/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<String?> getDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory('${directory.path}/${AppConst.receiptsFolder}');

      if (!await receiptsDir.exists()) {
        await receiptsDir.create(recursive: true);
      }

      return receiptsDir.path;
    } catch (e, s) {
      Log.e('Receipt Generator', e.toString(), s);
    }
    return null;
  }
}
