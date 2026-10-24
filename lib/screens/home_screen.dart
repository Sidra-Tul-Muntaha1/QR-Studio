
import 'package:flutter/material.dart';
import 'package:qr_code_generator/models/qr_item.dart';
import 'package:qr_code_generator/screens/qr_preview_screen.dart';
import 'package:qr_code_generator/services/storage_service.dart';
import 'package:qr_code_generator/theme/app_theme.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  String _selectedType = 'Website';
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _quickStarts = [
    {
      'title': 'Website',
      'icon': Icons.language_rounded,
      'hint': 'https://example.com',
    },
    {
      'title': 'Text',
      'icon': Icons.notes_rounded,
      'hint': 'Type your message here...',
    },
  ];

  void _selectType(String type, String hint) {
    setState(() {
      _selectedType = type;
    });

    if (_controller.text.trim().isEmpty) {
      _controller.text = '';
    }

    FocusScope.of(context).unfocus();
  }

  String _makeTitle(String data) {
    if (_selectedType == 'Website') {
      return 'Website QR';
    }

    final firstLine = data.split('\n').first.trim();

    if (firstLine.isEmpty) {
      return 'Text QR';
    }

    return firstLine.length > 30
        ? '${firstLine.substring(0, 30)}...'
        : firstLine;
  }

  
Future<void> _generateQR() async {
  final data = _controller.text.trim();

  if (data.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter some text or a URL first.'),
      ),
    );
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() => _isGenerating = true);

  final item = QRItem(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    data: data,
    title: _makeTitle(data),
    createdAt: DateTime.now(),
  );

  try {
    // Save the generated QR to History first.
    await StorageService().saveToHistory(item);

    if (!mounted) return;

    // Open the QR preview.
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QRPreviewScreen(item: item),
      ),
    );

    // Clear the input after returning to Home.
    if (mounted) {
      _controller.clear();
    }
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not generate QR code: $e'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isGenerating = false);
    }
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 22,
        title: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFEAE7FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                color: AppTheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 11),
            const Text('QR Studio'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFEDEAFF),
                      Color(0xFFF7F4FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'YOUR LITTLE CREATIVE SPACE ✨',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'What would you\nlike to share?',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 29,
                        height: 1.18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      'Turn anything into a little square\nthat connects people.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 48,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Create a QR code',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Start with a link or any text you like.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What are we creating?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: _quickStarts.map((option) {
                          final title = option['title'] as String;
                          final icon = option['icon'] as IconData;
                          final selected = _selectedType == title;

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: title == 'Website' ? 10 : 0,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () => _selectType(
                                  title,
                                  option['hint'] as String,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 180,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFFEDEAFF)
                                        : AppTheme.background,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: selected
                                          ? AppTheme.primary
                                          : AppTheme.border,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        icon,
                                        color: selected
                                            ? AppTheme.primary
                                            : AppTheme.textSecondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 7),
                                      Flexible(
                                        child: Text(
                                          title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? AppTheme.primary
                                                : AppTheme.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controller,
                        minLines: 3,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: _selectedType == 'Website'
                              ? 'https://example.com'
                              : 'Write something lovely...',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 43),
                            child: Icon(
                              _selectedType == 'Website'
                                  ? Icons.link_rounded
                                  : Icons.notes_rounded,
                              color: AppTheme.primary,
                            ),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              _isGenerating ? null : _generateQR,
                          icon: _isGenerating
                              ? const SizedBox(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.auto_awesome_rounded),
                          label: Text(
                            _isGenerating
                                ? 'Creating your QR...'
                                : 'Generate QR code',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'A little inspiration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Simple ideas, endless possibilities.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InspirationCard(
                      icon: Icons.language_rounded,
                      title: 'Your website',
                      subtitle: 'Share your corner of the internet',
                      color: const Color(0xFFEAE7FF),
                      onTap: () {
                        _selectType('Website', 'https://example.com');
                        _controller.text = 'https://';
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InspirationCard(
                      icon: Icons.favorite_rounded,
                      title: 'A message',
                      subtitle: 'Share a note or a little reminder',
                      color: const Color(0xFFFFE9F0),
                      onTap: () {
                        _selectType('Text', 'Write something lovely...');
                        _controller.clear();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppTheme.primary,
                      size: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Made for your everyday sharing',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your QR codes are created right on your device.',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspirationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _InspirationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppTheme.primary),
            ),
            const SizedBox(height: 13),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
