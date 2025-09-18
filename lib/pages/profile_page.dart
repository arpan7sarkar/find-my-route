import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

// Converted to a StatefulWidget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// The State class that manages the widget's state and build process
class _ProfileScreenState extends State<ProfileScreen> {
  // The method to show the dialog is now part of the State class.
  // Note that it no longer needs a BuildContext parameter, as the
  // State object has its own `context` property.
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ProfileCardDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, size: 30),
          // onPressed now calls the method from this State class
          onPressed: _showProfileDialog,
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Tap the profile icon in the top-left to see the pop-up.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

// This widget does not need to be stateful, so it remains a StatelessWidget.
class ProfileCardDialog extends StatelessWidget {
  const ProfileCardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) => RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Hi, ',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text: FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) => Text(
                FirebaseAuth.instance.currentUser?.email ?? 'No email',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionButton(
              context,
              icon: Icons.settings_outlined,
              label: 'Manage Account',
              onPressed: () {
                print('Manage Account tapped');
              },
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              context,
              icon: Icons.logout,
              label: 'Sign Out',
              onPressed: () async {
                try {
                  await AuthService().signOut();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: Colors.black54),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}