import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/nearby_locations.dart';
import '../widgets/bottom_navigation.dart';
import 'routes_page.dart';
import 'community_page.dart';
import 'saathi_page.dart';
import 'package:transport/pages/map_page_two.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Use controllers so we can programmatically update the text fields
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  String _startLocation = '';
  String _endLocation = '';
  
  // Location variables
  double? lat;
  double? long;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: _startLocation);
    _endController = TextEditingController(text: _endLocation);
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location: ${lat!.toStringAsFixed(6)}, ${long!.toStringAsFixed(6)}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: CustomAppBar(title: 'Find My Route'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map preview container with actual map
            Container(
              height: 370,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(51),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(lat ?? 22.6983936, long ?? 88.3949568),
                        initialZoom: 11.0,
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.doubleTapDragZoom,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat ?? 22.6983936, long ?? 88.3949568),
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              child: const Icon(Icons.location_on, color: Colors.red, size: 50),
                            ),
                            // Add current location marker if available
                            if (lat != null && long != null)
                              Marker(
                                point: LatLng(lat!, long!),
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                child: const Icon(Icons.my_location, color: Colors.transparent, size: 50),
                              ),
                          ],
                        ),
                      ],
                    ),
                    // Location button in bottom right corner
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: _isLoadingLocation ? null : _getCurrentLocation,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: _isLoadingLocation
                                  ? const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.my_location,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Location Input with Swap Button (uses controllers)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    children: [
                      // Start Location Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: TextField(
                            controller: _startController,
                            onChanged: (value) {
                              setState(() {
                                _startLocation = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Start Location',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.blue[700],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // End Location Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: TextField(
                            controller: _endController,
                            onChanged: (value) {
                              setState(() {
                                _endLocation = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'End Location',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.blue[700],
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Swap Button: swap controller.text values
                  Positioned(
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          final temp = _startController.text;
                          _startController.text = _endController.text;
                          _endController.text = temp;

                          // keep our string variables in sync too
                          _startLocation = _startController.text;
                          _endLocation = _endController.text;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      _startLocation.isNotEmpty && _endLocation.isNotEmpty
                      ? () {
                          // Handle search functionality
                          debugPrint(
                            'Searching from $_startLocation to $_endLocation',
                          );
                        }
                      : null,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: const Text(
                      'SEARCH',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const NearbyLocations(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      // MapPage(),
      MapPageTwo(),
      // LocationPage(),
      const RoutesPage(),
      const CommunityPage(),
      const SaathiPage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
