
import 'dart:typed_data';
import 'dart:ui' as ui;

//import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRService {
  static Future<Uint8List> generateQrImage(
    String data, {
    double size = 800,
  }) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      color: const ui.Color(0xFF000000),
      emptyColor: const ui.Color(0xFFFFFFFF),
    );

    final image = await painter.toImage(size);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    image.dispose();

    if (byteData == null) {
      throw Exception('Could not generate QR image.');
    }

    return byteData.buffer.asUint8List();
  }

  static Future<void> saveToGallery(String data) async {
    final bytes = await generateQrImage(data);

    await Gal.putImageBytes(
      bytes,
      name: 'qr_studio_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  static Future<void> shareQr(String data) async {
    final bytes = await generateQrImage(data);

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'image/png',
            name: 'qr_studio.png',
          ),
        ],
        text: 'QR code created with QR Studio',
      ),
    );
  }
}
/* 
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRService {
  QRService._();

  static Future<Uint8List> generateImage(
    String data, {
    Color foregroundColor = Colors.black,
    Color backgroundColor = Colors.white,
    int imageSize = 800,
  }) async {
    if (data.trim().isEmpty) {
      throw ArgumentError('QR data cannot be empty.');
    }

    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foregroundColor,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foregroundColor,
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    final imageData = await painter.toImageData(
      imageSize.toDouble(),
      format: ui.ImageByteFormat.png,
    );

    if (imageData == null) {
      throw Exception('Could not generate QR image.');
    }

    // Paint a solid background behind the QR image.
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = imageSize.toDouble();

    canvas.drawColor(backgroundColor, BlendMode.src);

    final qrImage = await decodeImageFromList(
      imageData.buffer.asUint8List(),
    );

    final source = Rect.fromLTWH(
      0,
      0,
      qrImage.width.toDouble(),
      qrImage.height.toDouble(),
    );
    final destination = Rect.fromLTWH(0, 0, size, size);

    canvas.drawImageRect(
      qrImage,
      source,
      destination,
      Paint(),
    );

    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(
      imageSize,
      imageSize,
    );

    final finalData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    qrImage.dispose();
    finalImage.dispose();
    picture.dispose();

    if (finalData == null) {
      throw Exception('Could not export QR image.');
    }

    return finalData.buffer.asUint8List();
  }

  static Future<void> saveToGallery(
    String data, {
    Color foregroundColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) async {
    final bytes = await generateImage(
      data,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );

    await Gal.putImageBytes(
      bytes,
      name: 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png',
    );
  }

  static Future<void> shareQR(
    String data, {
    Color foregroundColor = Colors.black,
    Color backgroundColor = Colors.white,
  }) async {
    final bytes = await generateImage(
      data,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );

    await SharePlus.instance.share(
      ShareParams(
        title: 'My QR Code',
        text: 'QR code for: $data',
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'image/png',
            name: 'qr_code.png',
          ),
        ],
        fileNameOverrides: ['qr_code.png'],
      ),
    );
  }
}
 */