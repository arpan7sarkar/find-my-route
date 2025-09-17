import 'package:flutter/material.dart';

class LocationInput extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final VoidCallback onSwap;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;

  static const double _iconSize = 20.0;
  static const double _buttonIconSize = 20.0;
  static const double _padding = 16.0;
  static const double _margin = 16.0;
  static const double _borderRadius = 12.0;

  const LocationInput({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.onSwap,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(_margin),
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: _iconSize),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: startLocation.isEmpty
                        ? 'Start Location'
                        : startLocation,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onStartChanged,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Divider(color: Colors.grey[300]),
          ),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: _iconSize),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: endLocation.isEmpty
                        ? 'End Location'
                        : endLocation,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onEndChanged,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                    size: _buttonIconSize,
                  ),
                  onPressed: onSwap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: startLocation.isNotEmpty && endLocation.isNotEmpty
                  ? () {
                      // Handle search functionality
                      debugPrint(
                        'Searching route from $startLocation to $endLocation',
                      );
                    }
                  : null, // Disable button if either field is empty
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'SEARCH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
