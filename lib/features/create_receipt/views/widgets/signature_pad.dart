import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:chromo_digital/core/bloc/helper.dart';
import 'package:chromo_digital/core/constants/app_strings.dart';
import 'package:chromo_digital/core/services/logger/logger.dart';
import 'package:chromo_digital/core/widgets/app_button.dart';
import 'package:extensions_plus/extensions_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final _signatureKey = GlobalKey<SfSignaturePadState>();
  final _stateHandler = Handler<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 12.0,
      children: [
        SizedBox(
          height: 230,
          child: SfSignaturePad(
            key: _signatureKey,
            backgroundColor: Colors.white,
            strokeColor: Colors.black,
          ),
        ),
        Row(
          spacing: 12,
          children: [
            // clear and done button
            AppButton.outline(
              child: Text(AppStrings.clear),
              onPressed: () => _signatureKey.currentState?.clear(),
            ).expanded(),
            BlocBuilder<Handler<bool>, bool>(
              bloc: _stateHandler,
              builder: (context, state) {
                return AppButton(
                  onPressed: _attemptToSaveSignature,
                  isProcessing: state,
                  child: Text(AppStrings.insert),
                );
              },
            ).expanded(),
          ],
        ).paddingAll(12.0),
        const SizedBox(),
      ],
    );
  }

  Future<void> _attemptToSaveSignature() async {
    try {
      _stateHandler.update(true);
      final signature = await _signatureKey.currentState?.toImage();
      if (signature != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(filePath);

        await file.writeAsBytes(
          await signature.toByteData(format: ImageByteFormat.png).then((value) => value!.buffer.asUint8List()),
        );

        if (mounted) {
          context.maybePop(filePath);
        }
      } else {
        if (mounted) {
          context.maybePop();
        }
      }
    } catch (e, s) {
      Log.e(runtimeType, e.toString(), s);
    } finally {
      _stateHandler.update(false);
    }
  }
}
