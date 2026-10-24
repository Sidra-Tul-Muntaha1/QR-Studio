
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_generator/models/qr_item.dart';
import 'package:qr_code_generator/screens/customize_qr_screen.dart';
import 'package:qr_code_generator/services/qr_service.dart';
import 'package:qr_code_generator/services/storage_service.dart';
import 'package:qr_code_generator/theme/app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';



class QRPreviewScreen extends StatefulWidget {
  final QRItem item;

  const QRPreviewScreen({
    super.key,
    required this.item,
  });

  @override
  State<QRPreviewScreen> createState() => _QRPreviewScreenState();
}

class _QRPreviewScreenState extends State<QRPreviewScreen> {
  @override
void initState() {
  super.initState();
  _loadSavedStatus();
}
  final StorageService _storage = StorageService();

  bool _isSaved = false;
  bool _isSaving = false;
  bool _isSharing = false;

  Future<void> _toggleSaved() async {
    try {
      await _storage.toggleSaved(widget.item);

      if (!mounted) return;

      setState(() {
        _isSaved = !_isSaved;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isSaved ? 'Added to Saved 💜' : 'Removed from Saved',
          ),
        ),
      );
    } catch (e) {
      _showMessage('Could not update Saved: $e');
    }
  }

  Future<void> _saveQR() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      await QRService.saveToGallery(widget.item.data);

      if (!mounted) return;

      _showMessage('QR code saved to your gallery!');
    } catch (e) {
      _showMessage('Could not save QR code: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
  
Future<void> _loadSavedStatus() async {
  try {
    final saved = await _storage.isSaved(widget.item.id);

    if (!mounted) return;

    setState(() {
      _isSaved = saved;
    });
  } catch (e) {
    _showMessage('Could not check Saved status: $e');
  }
}


  
Future<void> _shareQR() async {
  if (_isSharing) return;

  setState(() => _isSharing = true);

  try {
    await QRService.shareQr(widget.item.data);
  } catch (e) {
    _showMessage('Could not share QR code: $e');
  } finally {
    if (mounted) {
      setState(() => _isSharing = false);
    }
  }
}


  Future<void> _copyContent() async {
    await Clipboard.setData(
      ClipboardData(text: widget.item.data),
    );

    if (!mounted) return;

    _showMessage('Content copied to clipboard.');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your QR code'),
        actions: [
          IconButton(
            tooltip: _isSaved ? 'Remove from Saved' : 'Save to Saved',
            onPressed: _toggleSaved,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Looking good!',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your QR code is ready to save or share.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 26),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QrImageView(
                          data: item.data,
                          version: QrVersions.auto,
                          size: 245,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SelectableText(
                          item.data,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _copyContent,
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          label: const Text('Copy content'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isSaving ? null : _saveQR,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.download_rounded),
                      label: Text(_isSaving ? 'Saving...' : 'Save'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _isSharing ? null : _shareQR,
                      icon: _isSharing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.share_rounded),
                      label: Text(_isSharing ? 'Sharing...' : 'Share'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CustomizeQRScreen(
                              item: widget.item,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.palette_outlined),
                      label: const Text('Customize QR'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton.icon(
                  onPressed: _toggleSaved,
                  icon: Icon(
                    _isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_add_outlined,
                  ),
                  label: Text(
                    _isSaved ? 'Saved to your collection' : 'Add to Saved',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
