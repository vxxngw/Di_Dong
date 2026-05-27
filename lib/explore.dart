import 'dart:async';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/app_models.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();

  int _currentBanner = 0;
  Timer? _timer;
  List<String> _bannerList = [];
  String _searchText = "";

  late Future<List<String>> _bannersFuture;
  late Future<List<Map<String, dynamic>>> _journeysFuture;
  late Future<List<Guide>> _guidesFutureData;
  late Future<List<Experience>> _experiencesFutureData;
  late Future<List<Tour>> _toursFutureData;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _autoSlide();
  }

  void _fetchData() {
    _bannersFuture = ApiService.getBanners();
    _journeysFuture = ApiService.getJourneys();
    _guidesFutureData = ApiService.getGuides();
    _experiencesFutureData = ApiService.getExperiences();
    _toursFutureData = ApiService.getTours();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _fetchData();
    });
    try {
      await Future.wait([
        _bannersFuture,
        _journeysFuture,
        _guidesFutureData,
        _experiencesFutureData,
        _toursFutureData,
      ]);
    } catch (_) {}
  }

  void _autoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _bannerList.isNotEmpty) {
        setState(() {
          _currentBanner = (_currentBanner + 1) % _bannerList.length;
        });

        _pageController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
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
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: const Color(0xFF00D1B2),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _bannerFuture(),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: -26,
                      child: _searchBar(),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverToBoxAdapter(child: _sectionTitle("Top Journeys")),
              SliverToBoxAdapter(child: _topJourneysFuture()),
              SliverToBoxAdapter(child: _sectionTitle("Best Guides")),
              SliverToBoxAdapter(child: _guidesFuture()),
              SliverToBoxAdapter(child: _sectionTitle("Top Experiences")),
              SliverToBoxAdapter(child: _experiencesFuture()),
              SliverToBoxAdapter(child: _sectionTitle("Featured Tours")),
              SliverToBoxAdapter(child: _toursFuture()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerFuture() {
    return FutureBuilder<List<String>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(height: 230, color: Colors.grey[200]);
        _bannerList = snapshot.data!;
        return SizedBox(
          height: 230,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _bannerList.length,
                onPageChanged: (i) => setState(() => _currentBanner = i),
                itemBuilder: (_, index) => Image.asset(
                  _bannerList[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Container(color: Colors.black.withOpacity(0.3)),
              const Positioned(
                left: 16,
                bottom: 70,
                child: Text(
                  "Explore",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 16,
                child: Row(
                  children: List.generate(
                    _bannerList.length,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentBanner == i ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Hi, where do you want to explore?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("SEE MORE", style: TextStyle(color: Colors.teal)),
        ],
      ),
    );
  }

  Widget _topJourneysFuture() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _journeysFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final journeys = snapshot.data!
            .where(
              (j) => (j["title"] ?? "").toString().toLowerCase().contains(
                _searchText.toLowerCase(),
              ),
            )
            .toList();
        if (journeys.isEmpty)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No journeys match your search."),
          );
        return SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: journeys.length,
            itemBuilder: (_, i) => _buildJourneyCard(journeys[i]),
          ),
        );
      },
    );
  }

  Widget _guidesFuture() {
    return FutureBuilder<List<Guide>>(
      future: _guidesFutureData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final guides = snapshot.data!
            .where(
              (g) =>
                  g.name.toLowerCase().contains(_searchText.toLowerCase()) ||
                  g.role.toLowerCase().contains(_searchText.toLowerCase()),
            )
            .toList();
        if (guides.isEmpty)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No guides match your search."),
          );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: guides.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (_, i) => _buildGuideCard(guides[i]),
          ),
        );
      },
    );
  }

  Widget _experiencesFuture() {
    return FutureBuilder<List<Experience>>(
      future: _experiencesFutureData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final exp = snapshot.data!
            .where(
              (e) =>
                  e.title.toLowerCase().contains(_searchText.toLowerCase()) ||
                  e.location.toLowerCase().contains(_searchText.toLowerCase()),
            )
            .toList();
        if (exp.isEmpty)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No experiences match your search."),
          );
        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: exp.length,
            itemBuilder: (_, i) => _buildExperienceCard(exp[i]),
          ),
        );
      },
    );
  }

  Widget _toursFuture() {
    return FutureBuilder<List<Tour>>(
      future: _toursFutureData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final tours = snapshot.data!
            .where(
              (t) => t.title.toLowerCase().contains(_searchText.toLowerCase()),
            )
            .toList();
        if (tours.isEmpty)
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No tours match your search."),
          );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: tours.map((t) => _buildTourCard(t)).toList()),
        );
      },
    );
  }

  Widget _buildJourneyCard(Map<String, dynamic> item) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              item["image"] ?? 'assets/placeholder.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(item["date"] ?? ''),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item["days"] ?? ''),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item["price"] ?? '',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Guide g) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            g.image,
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          g.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              "${g.reviews} Reviews",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.teal, size: 16),
            const SizedBox(width: 4),
            Text(
              g.role,
              style: const TextStyle(fontSize: 13, color: Colors.teal),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceCard(Experience e) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  e.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -25,
                left: 16,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(e.avatar),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        e.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.teal),
              const SizedBox(width: 4),
              Text(
                e.location,
                style: const TextStyle(color: Colors.teal, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTourCard(Tour t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.asset(
                  t.image,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Icon(
                    t.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(t.date),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(t.days),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  t.price,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
