import 'package:flutter/material.dart';
import 'dart:async';

class TestimonialsCarousel extends StatefulWidget {
  const TestimonialsCarousel({Key? key}) : super(key: key);

  @override
  State<TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<TestimonialsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  final List<Testimonial> _testimonials = [
    Testimonial(
      name: 'Sarah Johnson',
      role: 'Regular Donor',
      quote: 'The blockchain transparency gives me complete confidence. I can see exactly where my donations go!',
      avatar: '👩',
      rating: 5,
    ),
    Testimonial(
      name: 'Michael Chen',
      role: 'Monthly Supporter',
      quote: 'Finally, a platform I can trust. The real-time tracking is revolutionary for charitable giving.',
      avatar: '👨',
      rating: 5,
    ),
    Testimonial(
      name: 'Emma Wilson',
      role: 'First-time Donor',
      quote: 'So easy to use! I love seeing the impact of my contributions in real-time.',
      avatar: '👱‍♀️',
      rating: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _testimonials.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Text(
            'What Our Donors Say',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                return _buildTestimonialCard(_testimonials[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _testimonials.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Color(0xFF7B3FF2)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            testimonial.avatar,
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < testimonial.rating ? Icons.star : Icons.star_border,
                color: Color(0xFFFFBD00),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"${testimonial.quote}"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Text(
            testimonial.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            testimonial.role,
            style: TextStyle(
              color: Color(0xFF7B3FF2),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class Testimonial {
  final String name;
  final String role;
  final String quote;
  final String avatar;
  final int rating;

  Testimonial({
    required this.name,
    required this.role,
    required this.quote,
    required this.avatar,
    required this.rating,
  });
}
