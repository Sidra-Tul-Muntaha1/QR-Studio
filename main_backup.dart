
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const QRGeneratorApp());
}

class QRGeneratorApp extends StatelessWidget {
  const QRGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Studio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6558E8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FC),
      ),
      home: const QRHomeScreen(),
    );
  }
}

class QRHomeScreen extends StatefulWidget {
  const QRHomeScreen({super.key});

  @override
  State<QRHomeScreen> createState() => _QRHomeScreenState();
}

class _QRHomeScreenState extends State<QRHomeScreen> {
  final TextEditingController _textController =
      TextEditingController();

  String _enteredText = '';
  bool _isSaving = false;

  void _generateQR() {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text or a URL.'),
        ),
      );
      return;
    }

    setState(() {
      _enteredText = text;
    });
  }

  void _clearInput() {
    _textController.clear();

    setState(() {
      _enteredText = '';
    });
  }

  Future<Uint8List> _createQRImage() async {
    final painter = QrPainter(
      data: _enteredText,
      version: QrVersions.auto,
      gapless: false,
      color: Colors.black,
      emptyColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    final imageData = await painter.toImageData(
      800,
      format: ui.ImageByteFormat.png,
    );

    if (imageData == null) {
      throw Exception('Could not create QR image.');
    }

    return imageData.buffer.asUint8List();
  }

  Future<void> _saveQR() async {
    if (_enteredText.isEmpty || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final bytes = await _createQRImage();

      await Gal.putImageBytes(
        bytes,
        name: 'qr_code.png',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR code saved to your gallery!'),
          backgroundColor: Color(0xFF25865A),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save QR code: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  Future<void> _shareQR() async {
  if (_enteredText.isEmpty || _isSaving) return;

  setState(() {
    _isSaving = true;
  });

  try {
    final bytes = await _createQRImage();

    await SharePlus.instance.share(
      ShareParams(
        title: 'My QR Code',
        text: 'QR code for: $_enteredText',
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
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not share QR code: $e'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }
}

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7FC),
        title: const Row(
          children: [
            Icon(
              Icons.qr_code_2,
              color: Color(0xFF6558E8),
              size: 32,
            ),
            SizedBox(width: 10),
            Text(
              'QR Studio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear',
            onPressed: _clearInput,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create your QR code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Turn your text or website link into a QR code.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 28),

              // Input card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE7E7F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter text or URL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _textController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'https://example.com',
                        prefixIcon: const Icon(Icons.link),
                        filled: true,
                        fillColor: const Color(0xFFF9F9FD),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _generateQR,
                        icon: const Icon(Icons.qr_code_2),
                        label: const Text('Generate QR Code'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6558E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'QR code preview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // QR preview and save button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE7E7F0),
                  ),
                ),
                child: _enteredText.isEmpty
                    ? Column(
                        children: [
                          const Icon(
                            Icons.qr_code_2,
                            size: 76,
                            color: Color(0xFF6558E8),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Your QR code will appear here',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          QrImageView(
                            data: _enteredText,
                            version: QrVersions.auto,
                            size: 230,
                            backgroundColor: Colors.white,
                            errorCorrectionLevel:
                                QrErrorCorrectLevel.H,
                          ),
                          const SizedBox(height: 16),
                          SelectableText(
                            _enteredText,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Save QR button
                          
Row(
  children: [
    Expanded(
      child: OutlinedButton.icon(
        onPressed: _isSaving ? null : _saveQR,
        icon: const Icon(Icons.download_outlined),
        label: const Text('Save'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: FilledButton.icon(
        onPressed: _isSaving ? null : _shareQR,
        icon: const Icon(Icons.share_outlined),
        label: const Text('Share'),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6558E8),
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
  ],
)

                        ],
                      ),
              ),

              /* const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Made with Flutter 💜',
                  style: TextStyle(color: Colors.grey),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
