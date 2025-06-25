import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  final String city;
  final String temperature;
  final VoidCallback onTap;
  final bool isDarkMode;

  const CityCard({
    super.key,
    required this.city,
    required this.temperature,
    required this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: isDarkMode ? Colors.grey[800] : Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.yellow, size: 32),
                const SizedBox(height: 8),
                Text(
                  city,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  temperature,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
