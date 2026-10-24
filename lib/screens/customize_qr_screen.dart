import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gal/gal.dart';

import 'package:qr_code_generator/models/qr_item.dart';
import 'package:qr_code_generator/screens/success_screen.dart';
import 'package:qr_code_generator/theme/app_theme.dart';

class CustomizeQRScreen extends StatefulWidget {
  final QRItem item;

  const CustomizeQRScreen({
    super.key,
    required this.item,
  });

  @override
  State<CustomizeQRScreen> createState() => _CustomizeQRScreenState();
}

class _CustomizeQRScreenState extends State<CustomizeQRScreen> {
  final GlobalKey _qrKey = GlobalKey();

  Color _foreground = const Color(0xFF6C4AB6);
  Color _background = Colors.white;
  bool _roundDots = false;
  Uint8List? _logoBytes;
  bool _isSaving = false;

  final List<Color> _colors = const [
    Color(0xFF6C4AB6),
    Color(0xFF222222),
    Color(0xFF176B55),
    Color(0xFF2457C5),
    Color(0xFFB83280),
    Color(0xFFB45309),
  ];

  Future<void> _pickLogo() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() => _logoBytes = bytes);
  }

  Future<void> _saveCustomizedQR() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      // Capture the QR preview, including its selected colors and logo.
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );

      final boundary = _qrKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('QR preview is not ready.');
      }

      final ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      if (byteData == null) {
        throw Exception('Could not create the QR image.');
      }

      final bytes = byteData.buffer.asUint8List();

      // Save the actual customized PNG to the device gallery.
      await Gal.putImageBytes(
        bytes,
        name: 'qr_studio_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessScreen(item: widget.item),
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
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize QR'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Make it yours 💜',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize your QR code before saving it.',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // This is the exact area captured and saved as a PNG.
            Center(
              child: RepaintBoundary(
                key: _qrKey,
                child: Container(
                  width: 280,
                  height: 280,
                  color: _background,
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      QrImageView(
                        data: widget.item.data,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        foregroundColor: _foreground,
                        backgroundColor: _background,
                        eyeStyle: QrEyeStyle(
                          eyeShape: _roundDots
                              ? QrEyeShape.circle
                              : QrEyeShape.square,
                          color: _foreground,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: _roundDots
                              ? QrDataModuleShape.circle
                              : QrDataModuleShape.square,
                          color: _foreground,
                        ),
                      ),
                      if (_logoBytes != null)
                        Container(
                          width: 58,
                          height: 58,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _logoBytes!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'QR foreground color',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _foreground = color),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _foreground == color
                            ? AppTheme.textPrimary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: _foreground == color
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'QR background color',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                Colors.white,
                const Color(0xFFF1EAFE),
                const Color(0xFFFFF0F5),
                const Color(0xFFEAF7F0),
                const Color(0xFFFFF8E7),
              ].map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _background = color),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _background == color
                            ? AppTheme.primary
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: _background == color
                        ? const Icon(
                            Icons.check,
                            size: 18,
                            color: AppTheme.primary,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Rounded QR dots'),
              subtitle: const Text('Change the shape of QR modules and eyes'),
              value: _roundDots,
              activeThumbColor: AppTheme.primary,
              onChanged: (value) {
                setState(() => _roundDots = value);
              },
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _pickLogo,
              icon: const Icon(Icons.image_outlined),
              label: Text(
                _logoBytes == null
                    ? 'Add center logo or image'
                    : 'Change center logo',
              ),
            ),

            if (_logoBytes != null)
              TextButton.icon(
                onPressed: () => setState(() => _logoBytes = null),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove logo'),
              ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _isSaving ? null : _saveCustomizedQR,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_alt_rounded),
              label: Text(
                _isSaving ? 'Saving QR...' : 'Save Customized QR',
              ),
            ),
          ],
        ),
      ),
    );
  }
}