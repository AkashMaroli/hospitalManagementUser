import 'package:flutter/material.dart';
import 'package:hospitalmanagementuser/core/constants.dart';
import 'package:hospitalmanagementuser/data/services/auth_services.dart';
import 'package:hospitalmanagementuser/main_state_check.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        bool isLoading = false;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).canvasColor,
                  title: const Text(
                    'Logout Confirmation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content:
                      isLoading
                          ? SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: themeColor,
                              ),
                            ),
                          )
                          : const Text(
                            'Are you sure you want to logout from your account?',
                          ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  actions:
                      isLoading
                          ? []
                          : [
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
                                setState(() {
                                  isLoading = true;
                                });

                                await signOut(context);

                                if (context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => AuthStateListener(),
                                    ),
                                    (route) =>
                                        false, // removes all previous routes
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                );
              },
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
      tileColor: Colors.grey.withOpacity(0.1),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
