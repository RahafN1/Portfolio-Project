import 'package:flutter/material.dart';

import '../../models/trail.dart';

class TrailCard extends StatelessWidget {
  final Trail trail;

  const TrailCard({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: trail.coverImage != null
              ? Image.network(
                  trail.coverImage!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.terrain, size: 50),
        ),
        title: Text(
          trail.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${trail.region} • ${trail.difficultyArabic} • ${trail.distance} كم',
        ),
      ),
    );
  }
}
