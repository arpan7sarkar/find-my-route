import 'package:flutter/material.dart';
import '../models/location_model.dart';

class NearbyLocations extends StatelessWidget {
  final List<NearbyLocation> locations;

  const NearbyLocations({super.key, List<NearbyLocation>? locations})
    : locations =
          locations ??
          const [
            NearbyLocation(
              name: 'Bus Stop',
              icon: Icons.directions_bus,
              type: 'transport',
            ),
            NearbyLocation(
              name: 'Hospital',
              icon: Icons.local_hospital,
              type: 'medical',
            ),
            NearbyLocation(
              name: 'School',
              icon: Icons.school,
              type: 'education',
            ),
            NearbyLocation(name: 'Park', icon: Icons.park, type: 'recreation'),
          ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nearby Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: locations.map((location) {
              return GestureDetector(
                onTap: () {
                  // Handle location selection
                  debugPrint('Selected ${location.name}');
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(location.icon, color: Colors.blue, size: 24),
                    ),
                    SizedBox(height: 8),
                    Text(
                      location.name,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
