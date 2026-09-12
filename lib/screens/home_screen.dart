import 'package:flutter/material.dart';

import '../models/enums.dart';
import 'collection_screen.dart';
import 'stats_screen.dart';

/// Home screen dengan bottom navigation — 4 tab: Anime, Film, Series, Stats.
/// Menggunakan IndexedStack untuk mempertahankan state dan scroll position per tab.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Keys untuk mempertahankan state setiap tab.
  final _pages = const [
    CollectionScreen(key: PageStorageKey('anime'), type: ItemType.anime),
    CollectionScreen(key: PageStorageKey('movie'), type: ItemType.movie),
    CollectionScreen(key: PageStorageKey('series'), type: ItemType.series),
    StatsScreen(key: PageStorageKey('stats')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.animation_outlined),
            selectedIcon: Icon(Icons.animation_rounded),
            label: 'Anime',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie_rounded),
            label: 'Film',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv_outlined),
            selectedIcon: Icon(Icons.tv_rounded),
            label: 'Series',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
