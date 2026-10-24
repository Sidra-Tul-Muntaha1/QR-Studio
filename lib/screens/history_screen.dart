
import 'package:flutter/material.dart';
import 'package:qr_code_generator/models/qr_item.dart';
import 'package:qr_code_generator/screens/qr_preview_screen.dart';
import 'package:qr_code_generator/services/storage_service.dart';
import 'package:qr_code_generator/theme/app_theme.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

 @override
HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storage = StorageService();
  final TextEditingController _searchController =
      TextEditingController();
      Future<void> refreshHistory() async {
  if (!mounted) return;

  setState(() {
    _isLoading = true;
  });

  await _loadHistory();
}

  List<QRItem> _history = [];
  bool _isLoading = true;

  List<QRItem> get _filteredHistory {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _history;

    return _history.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.data.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadHistory() async {
    try {
      final items = await _storage.getHistory();

      if (!mounted) return;

      setState(() {
        _history = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      _showMessage('Could not load history.');
    }
  }

  Future<void> _openItem(QRItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QRPreviewScreen(item: item),
      ),
    );

    if (mounted) await _loadHistory();
  }

  Future<void> _deleteItem(QRItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove from history?'),
        content: const Text(
          'This removes the item from History. '
          'It will remain in Saved if you bookmarked it.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
 await _storage.deleteHistoryItem(item.id);
    if (!mounted) return;
     
    setState(() {
      _history.removeWhere((historyItem) => historyItem.id == item.id);
    });
    _showMessage('Removed from History.');
  }

  Future<void> _clearHistory() async {
    if (_history.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear all history?'),
        content: const Text(
          'Your Saved QR codes will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Clear history'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
await _storage.clearHistory();
    if (!mounted) return;
     
    setState(() => _history.clear());
    _showMessage('History cleared.');
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              tooltip: 'Clear history',
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your little trail of ideas.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search your QR codes...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: _searchController.clear,
                                icon: const Icon(Icons.close_rounded),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recently created',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${items.length} items',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: items.isEmpty
                          ? _EmptyHistory(
                              hasSearch:
                                  _searchController.text.isNotEmpty,
                            )
                          : ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = items[index];

                                return _HistoryCard(
                                  item: item,
                                  onTap: () => _openItem(item),
                                  onDelete: () => _deleteItem(item),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QRItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isUrl = item.data.startsWith('http://') ||
        item.data.startsWith('https://');

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEAFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isUrl
                      ? Icons.language_rounded
                      : Icons.qr_code_2_rounded,
                  color: AppTheme.primary,
                  size: 29,
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
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.data,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(item.createdAt),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from history',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';

    return '${local.day}/${local.month}/${local.year} • '
        '$hour:$minute $period';
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool hasSearch;

  const _EmptyHistory({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEAFF),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 43,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasSearch ? 'No matches found' : 'Your story starts here',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try another search term.'
                  : 'Create your first QR code and it will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
