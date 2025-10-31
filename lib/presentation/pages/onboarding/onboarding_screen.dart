import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/data/services/sharedpreference_change_services.dart';
import 'package:hospitalmanagementuser/main_state_check.dart';
import 'package:hospitalmanagementuser/presentation/bloc/onboarding_screen_bloc/onboarding_screen_bloc.dart';
import 'package:hospitalmanagementuser/presentation/bloc/onboarding_screen_bloc/onboarding_screen_event.dart';
import 'package:hospitalmanagementuser/presentation/bloc/onboarding_screen_bloc/onboarding_screen_state.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      OnboardingData(
        title: 'Easy Booking',
        description:
            'Book appointments with your favorite professionals in just a few taps',
        icon: Icons.calendar_month_rounded,
      ),
      OnboardingData(
        title: 'Healthy life',
        description: "Let’s start living healthy and well with us right now!",
        icon: Icons.health_and_safety,
      ),
      OnboardingData(
        title: 'Experts Help',
        description: 'Expert doctors to help your health',
        icon: Icons.lightbulb_circle,
      ),
    ];

    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: pages.length),
      child: _OnboardingView(pages: pages),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  final List<OnboardingData> pages;
  const _OnboardingView({required this.pages});

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final currentPage = _pageController.page?.round() ?? 0;
      context.read<OnboardingBloc>().add(PageChangedEvent(currentPage));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) => previous.isFinished != current.isFinished,
      listener: (context, state) {
        if (state.isFinished) {
          updateSharedPreferenceData(false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => AuthStateListener()),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) =>
                      OnboardingPage(data: widget.pages[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: state.currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: state.currentPage == index
                                    ? Colors.teal
                                    : Colors.teal.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (state.currentPage < widget.pages.length - 1) {
                                context.read<OnboardingBloc>().add(NextPageEvent());
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                context.read<OnboardingBloc>().add(FinishOnboardingEvent());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              state.currentPage < widget.pages.length - 1
                                  ? 'Next'
                                  : 'Get Started',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (state.currentPage < widget.pages.length - 1)
                          TextButton(
                            onPressed: () {
                              context.read<OnboardingBloc>().add(SkipToLastPageEvent());
                              _pageController.jumpToPage(widget.pages.length - 1);
                            },
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 100, color: Colors.teal),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
