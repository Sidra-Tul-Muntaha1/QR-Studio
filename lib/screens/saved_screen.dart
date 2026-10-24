
import 'package:flutter/material.dart';
import 'package:qr_code_generator/models/qr_item.dart';
import 'package:qr_code_generator/screens/qr_preview_screen.dart';
import 'package:qr_code_generator/services/storage_service.dart';
import 'package:qr_code_generator/theme/app_theme.dart';



class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => SavedScreenState();
}

class SavedScreenState extends State<SavedScreen> {
  Future<void> refreshSaved() async {
  if (!mounted) return;

  setState(() {
    _isLoading = true;
  });

  await _loadSaved();
}
  final StorageService _storage = StorageService();

  List<QRItem> _savedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    try {
      final items = await _storage.getSaved();

      if (!mounted) return;

      setState(() {
        _savedItems = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Could not load your Saved QR codes.');
    }
  }

  Future<void> _openItem(QRItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QRPreviewScreen(item: item),
      ),
    );

    if (mounted) await _loadSaved();
  }

  Future<void> _removeItem(QRItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove saved QR code?'),
        content: const Text(
          'This removes the bookmark, but the item can remain in History.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
      await _storage.removeFromSaved(item.id);
    if (!mounted) return;

    setState(() {
      _savedItems.removeWhere((savedItem) => savedItem.id == item.id);
    });
    _showMessage('Removed from Saved.');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Saved QR codes'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _savedItems.isEmpty
                ? const _EmptySaved()
                : RefreshIndicator(
                    onRefresh: _loadSaved,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        24,
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(21),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFEDEAFF),
                                Color(0xFFF8F5FF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.bookmark_rounded,
                                size: 38,
                                color: AppTheme.primary,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Keep your favorites close.',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Your bookmarked codes are ready whenever you need them.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.4,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Your collection',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${_savedItems.length} saved',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ..._savedItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SavedCard(
                              item: item,
                              onTap: () => _openItem(item),
                              onRemove: () => _removeItem(item),
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

class _SavedCard extends StatelessWidget {
  final QRItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SavedCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isUrl = item.data.startsWith('https://') ||
        item.data.startsWith('http://');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  color: AppTheme.primary,
                  size: 31,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.data,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          isUrl
                              ? Icons.language_rounded
                              : Icons.notes_rounded,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isUrl ? 'Website' : 'Text',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove bookmark',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.bookmark_remove_outlined,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySaved extends StatelessWidget {
  const _EmptySaved();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEAFF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                color: AppTheme.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Nothing saved just yet',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'When you find a QR code worth keeping, tap the bookmark icon on its preview.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
