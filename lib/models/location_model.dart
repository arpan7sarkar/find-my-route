import 'package:flutter/material.dart';

class LocationModel {
  final String name;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class NearbyLocation {
  final String name;
  final IconData icon;
  final String type;

  const NearbyLocation({
    required this.name, 
    required this.icon, 
    required this.type
  });
}
