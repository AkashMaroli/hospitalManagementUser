import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/data/services/auth_services.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false, // User must tap a button to dismiss
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Logout Confirmation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Are you sure you want to logout from your account?',
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await signOut();

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: const Color.fromARGB(255, 52, 247, 26),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // ignore: deprecated_member_use
      tileColor: Colors.grey.withOpacity(0.1),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
