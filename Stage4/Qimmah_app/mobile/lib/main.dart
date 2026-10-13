import 'package:flutter/material.dart';

void main() {
  runApp(const QimmahApp());
}

class QimmahApp extends StatelessWidget {
  const QimmahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qimmah',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F4A2C),
        useMaterial3: true,
      ),
      // يخلي التطبيق من اليمين لليسار
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0; // رقم التبويب المختار

  final _titles = const ['استكشف', 'الخريطة', 'مساراتي', 'حسابي'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قمّة')),
      body: Center(
        child: Text(_titles[_index], style: const TextStyle(fontSize: 24)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1F4A2C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'استكشف'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'الخريطة'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), activeIcon: Icon(Icons.bookmark), label: 'مساراتي'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}