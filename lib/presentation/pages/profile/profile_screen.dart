import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/profile_bloc/profile_screen_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/profile_bloc/profile_screen_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/profile_bloc/profile_screen_state.dart';
import 'package:hospitalmanagementuser/presentation/pages/profile/about_app_screen.dart';
import 'package:hospitalmanagementuser/presentation/pages/profile/privacy_policy.dart';
import 'package:hospitalmanagementuser/presentation/pages/profile/terms_and_conditions.dart';
import 'package:hospitalmanagementuser/presentation/widgets/logout_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadUserProfile()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,

        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFF008B8B)),
              );
            }

            if (state is ProfileError) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Failed to load profile",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Please check your connection and try again",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<ProfileBloc>().add(LoadUserProfile());
                          },
                          icon: Icon(Icons.refresh_rounded),
                          label: Text(
                            "Retry",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF008B8B),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      // Profile Header Card
                      Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF008B8B), Color(0xFF006666)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF008B8B).withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              // Profile Image
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child:
                                      user.profilePhotoUrl == null ||
                                              user.profilePhotoUrl!.isEmpty
                                          ? Icon(Icons.person)
                                          : Image.network(
                                            user.profilePhotoUrl ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stack,
                                            ) {
                                              return Image.asset(
                                                'assets/images/old-man-20.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // User Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName ?? "No Name",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      user.emailId ?? "No Email",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //! Editing option is commented
                              // Edit Button
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.white.withOpacity(0.2),
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              //   child: IconButton(
                              //     onPressed: () {
                              //       // Navigate to edit profile
                              //     },
                              //     icon: Icon(
                              //       Icons.edit_rounded,
                              //       color: Colors.white,
                              //       size: 22,
                              //     ),
                              //     tooltip: 'Edit Profile',
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                      // Menu Items
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSectionHeader('Information'),
                            _buildMenuItem(
                              context: context,
                              icon: Icons.shield_outlined,
                              title: 'Privacy Policy',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const PrivacyPolicyPage(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              context: context,
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const TermsAndConditionsPage(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              context: context,
                              icon: Icons.info_outline_rounded,
                              title: 'About App',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AboutAppScreen(),
                                  ),
                                );
                              },
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Logout Widget
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: LogoutWidget(),
                      ),

                      SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        bottomLeft: isLast ? Radius.circular(16) : Radius.zero,
        bottomRight: isLast ? Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF008B8B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Color(0xFF008B8B), size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
    );
  }

  static Container headerSection(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 40,
      color: const Color.fromARGB(255, 235, 235, 235),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 136, 136, 136),
            ),
          ),
        ],
      ),
    );
  }
}
