import 'package:flutter/material.dart';

class TestimonialCarousel extends StatefulWidget {
  const TestimonialCarousel({Key? key}) : super(key: key);

  @override
  State<TestimonialCarousel> createState() => _TestimonialCarouselState();
}

class _TestimonialCarouselState extends State<TestimonialCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  final List<Testimonial> _testimonials = [
    Testimonial(
      name: 'Sarah Johnson',
      role: 'Regular Donor',
      image: '👩',
      text: 'This platform made it so easy to make a real difference. I love seeing the direct impact of my donations!',
      rating: 5,
    ),
    Testimonial(
      name: 'Michael Chen',
      role: 'Monthly Supporter',
      image: '👨',
      text: 'The transparency through blockchain technology gives me complete confidence in where my money goes.',
      rating: 5,
    ),
    Testimonial(
      name: 'Emma Williams',
      role: 'First-time Donor',
      image: '👩‍🦰',
      text: 'I was amazed by how simple the process was. Within minutes, I was helping people in need.',
      rating: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _testimonials.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _autoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'What Our Donors Say',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              return _buildTestimonialCard(_testimonials[index]);
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _testimonials.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF7B3FF2)
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(Testimonial testimonial) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            testimonial.image,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 12),
          Text(
            testimonial.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            testimonial.role,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              testimonial.rating,
              (index) => const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              testimonial.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
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
  final String image;
  final String text;
  final int rating;

  Testimonial({
    required this.name,
    required this.role,
    required this.image,
    required this.text,
    required this.rating,
  });
}
