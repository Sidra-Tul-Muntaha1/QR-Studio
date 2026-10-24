
import 'package:flutter/material.dart';
import 'package:qr_code_generator/screens/history_screen.dart';
import 'package:qr_code_generator/screens/home_screen.dart';
import 'package:qr_code_generator/screens/saved_screen.dart';
import 'package:qr_code_generator/services/storage_service.dart';



class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
      final GlobalKey<HistoryScreenState> _historyKey =
    GlobalKey<HistoryScreenState>();
    final GlobalKey<SavedScreenState> _savedKey =
    GlobalKey<SavedScreenState>();
  int _selectedIndex = 0;

  List<Widget> get _screens => [
  const HomeScreen(),
  HistoryScreen(key: _historyKey),
  SavedScreen(key: _savedKey),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
  setState(() {
    _selectedIndex = index;
  });

  if (index == 1) {
    _historyKey.currentState?.refreshHistory();
  }

  if (index == 2) {
    _savedKey.currentState?.refreshSaved();
  }
},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_2_outlined),
            selectedIcon: Icon(Icons.qr_code_2),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
