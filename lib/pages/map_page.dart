import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'dart:math' as math;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double _currentZoom = 13.0;
  double _centerLat = 22.5726; // Kolkata latitude
  double _centerLng = 88.3639; // Kolkata longitude
  Offset _panOffset = Offset.zero;
  bool _showSuggestedRoutes = false;

  final List<Map<String, String>> suggestedRoutes = [
    {
      'route': 'Route 1: Via Salt Lake',
      'duration': '25 mins',
      'distance': '8.5 km',
    },
    {
      'route': 'Route 2: Via Park Street',
      'duration': '18 mins',
      'distance': '6.2 km',
    },
    {
      'route': 'Route 3: Via Esplanade',
      'duration': '32 mins',
      'distance': '12.1 km',
    },
  ];

  // Sample locations in Kolkata
  final List<Map<String, dynamic>> locations = [
    {'name': 'Salt Lake', 'lat': 22.5958, 'lng': 88.4497, 'color': Colors.red},
    {
      'name': 'Park Street',
      'lat': 22.5448,
      'lng': 88.3426,
      'color': Colors.blue,
    },
    {
      'name': 'Howrah Station',
      'lat': 22.5804,
      'lng': 88.3260,
      'color': Colors.green,
    },
    {'name': 'Sealdah', 'lat': 22.5697, 'lng': 88.3697, 'color': Colors.orange},
    {
      'name': 'New Market',
      'lat': 22.5568,
      'lng': 88.3506,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Find My Route'),
      body: Stack(
        children: [
          // OpenStreetMap Container
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _currentZoom = (_currentZoom * details.scale).clamp(
                    5.0,
                    18.0,
                  );
                });
              },
              // onPanUpdate: (details) {
              //   setState(() {
              //     _panOffset += details.delta;
              //   });
              // },
              child: Stack(
                children: [
                  // OpenStreetMap tiles
                  Container(
                    decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
                    child: OpenStreetMapWidget(
                      zoom: _currentZoom,
                      centerLat: _centerLat,
                      centerLng: _centerLng,
                      panOffset: _panOffset,
                    ),
                  ),
                  // Location markers overlay
                  ...locations.map(
                    (location) => _buildLocationMarker(
                      location['name'],
                      location['lat'],
                      location['lng'],
                      location['color'],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Zoom controls
          Positioned(
            top: 100,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "zoom_in",
                  onPressed: () {
                    setState(() {
                      _currentZoom = (_currentZoom + 1).clamp(5.0, 18.0);
                    });
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "zoom_out",
                  onPressed: () {
                    setState(() {
                      _currentZoom = (_currentZoom - 1).clamp(5.0, 18.0);
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "my_location",
                  onPressed: () {
                    setState(() {
                      _currentZoom = 13.0;
                      _panOffset = Offset.zero;
                      _centerLat = 22.5726;
                      _centerLng = 88.3639;
                    });
                  },
                  child: Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Search Routes Button
          Positioned(
            bottom: _showSuggestedRoutes ? 280 : 120,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showSuggestedRoutes = !_showSuggestedRoutes;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Search Routes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Suggested Bus Routes Panel
          if (_showSuggestedRoutes)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Suggested Bus Routes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: suggestedRoutes.length,
                        itemBuilder: (context, index) {
                          final route = suggestedRoutes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.withAlpha(51),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_bus,
                                  color: const Color(0xFF2196F3),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        route['route']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${route['duration']} • ${route['distance']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2196F3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Select',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Close button for suggested routes
          if (_showSuggestedRoutes)
            Positioned(
              top: 100,
              right: 80,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showSuggestedRoutes = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationMarker(
    String name,
    double lat,
    double lng,
    Color color,
  ) {
    // Convert lat/lng to screen coordinates
    final screenPos = _latLngToScreenPos(lat, lng);

    return Positioned(
      left: screenPos.dx - 20,
      top: screenPos.dy - 40,
      child: GestureDetector(
        onTap: () => _showLocationDetails(name),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.location_on, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Offset _latLngToScreenPos(double lat, double lng) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Simple projection from lat/lng to screen coordinates
    final x =
        ((lng - _centerLng) *
            111000 *
            math.cos(_centerLat * math.pi / 180) /
            math.pow(2, 18 - _currentZoom)) +
        screenWidth / 2 +
        _panOffset.dx;
    final y =
        ((_centerLat - lat) * 111000 / math.pow(2, 18 - _currentZoom)) +
        screenHeight / 2 +
        _panOffset.dy;

    return Offset(x, y);
  }

  void _showLocationDetails(String locationName) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.directions),
              title: Text('Get Directions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('More Info'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OpenStreetMapWidget extends StatelessWidget {
  final double zoom;
  final double centerLat;
  final double centerLng;
  final Offset panOffset;

  const OpenStreetMapWidget({
    super.key,
    required this.zoom,
    required this.centerLat,
    required this.centerLng,
    required this.panOffset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: MapTilePainter(
          zoom: zoom,
          centerLat: centerLat,
          centerLng: centerLng,
          panOffset: panOffset,
        ),
      ),
    );
  }
}

class MapTilePainter extends CustomPainter {
  final double zoom;
  final double centerLat;
  final double centerLng;
  final Offset panOffset;

  MapTilePainter({
    required this.zoom,
    required this.centerLat,
    required this.centerLng,
    required this.panOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Color(0xFFF0F8FF),
    );

    // Draw a simplified map representation
    _drawRoads(canvas, size);
    _drawWaterBodies(canvas, size);
    _drawParks(canvas, size);
  }

  void _drawRoads(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0 * (zoom / 13.0)
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 2.0 * (zoom / 13.0)
      ..style = PaintingStyle.stroke;

    // Major roads
    final roads = [
      [Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3)],
      [Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5)],
      [Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7)],
      [Offset(size.width * 0.2, 0), Offset(size.width * 0.2, size.height)],
      [Offset(size.width * 0.4, 0), Offset(size.width * 0.4, size.height)],
      [Offset(size.width * 0.6, 0), Offset(size.width * 0.6, size.height)],
      [Offset(size.width * 0.8, 0), Offset(size.width * 0.8, size.height)],
    ];

    for (final road in roads) {
      canvas.drawLine(road[0], road[1], roadPaint);
    }

    // Minor roads
    for (double i = 0.1; i < 1; i += 0.15) {
      canvas.drawLine(
        Offset(0, size.height * i),
        Offset(size.width, size.height * i),
        minorRoadPaint,
      );
      canvas.drawLine(
        Offset(size.width * i, 0),
        Offset(size.width * i, size.height),
        minorRoadPaint,
      );
    }
  }

  void _drawWaterBodies(Canvas canvas, Size size) {
    final waterPaint = Paint()
      ..color = Color(0xFFB3D9FF)
      ..style = PaintingStyle.fill;

    // Hooghly River representation
    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.1);
    riverPath.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.05,
      size.height * 0.6,
    );
    riverPath.quadraticBezierTo(
      size.width * 0.02,
      size.height * 0.8,
      0,
      size.height,
    );
    riverPath.lineTo(0, size.height * 0.1);
    riverPath.close();

    canvas.drawPath(riverPath, waterPaint);

    // Some ponds/lakes
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.7, size.height * 0.3),
        width: size.width * 0.08,
        height: size.height * 0.05,
      ),
      waterPaint,
    );
  }

  void _drawParks(Canvas canvas, Size size) {
    final parkPaint = Paint()
      ..color = Color(0xFFE8F5E8)
      ..style = PaintingStyle.fill;

    // Victoria Memorial area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.55,
          size.width * 0.15,
          size.height * 0.1,
        ),
        Radius.circular(8),
      ),
      parkPaint,
    );

    // Maidan
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.45,
          size.width * 0.2,
          size.height * 0.08,
        ),
        Radius.circular(8),
      ),
      parkPaint,
    );

    // Salt Lake Central Park
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.65,
          size.height * 0.2,
          size.width * 0.12,
          size.height * 0.08,
        ),
        Radius.circular(8),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
