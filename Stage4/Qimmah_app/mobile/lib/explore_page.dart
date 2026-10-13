import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// شكل المسار
class Trail {
  final int id;
  final String name;
  final double distanceKm;
  final String difficulty;

  Trail({required this.id, required this.name, required this.distanceKm, required this.difficulty});

  // يحوّل JSON من الباك إند إلى Trail
  factory Trail.fromJson(Map<String, dynamic> json) => Trail(
        id: json['id'],
        name: json['name'],
        distanceKm: (json['distance_km'] as num).toDouble(),
        difficulty: json['difficulty'],
      );
}

// يجيب المسارات من الباك إند
Future<List<Trail>> fetchTrails() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5001/api/trails'));

  if (response.statusCode != 200) {
    throw Exception('تعذّر تحميل المسارات');
  }

  final List data = jsonDecode(response.body);
  return data.map((json) => Trail.fromJson(json)).toList();
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trail>>(
      future: fetchTrails(),
      builder: (context, snapshot) {
        // لسا يحمّل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // صار خطأ
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        // وصلت البيانات
        final trails = snapshot.data!;
        return ListView(
          children: [
            for (final t in trails)
              ListTile(
                leading: const Icon(Icons.terrain),
                title: Text(t.name),
                subtitle: Text('${t.distanceKm} كم - ${t.difficulty}'),
              ),
          ],
        );
      },
    );
  }
}