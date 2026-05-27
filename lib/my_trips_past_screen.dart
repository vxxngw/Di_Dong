import 'package:flutter/material.dart';

class MyTripsPastScreen extends StatelessWidget {
  const MyTripsPastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),

      // ✅ floating button
      floatingActionButton: FloatingActionButton(
        heroTag: 'past_trips_fab',
        backgroundColor: Colors.teal,
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
      ),

      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pastTrips.length,
                itemBuilder: (context, index) {
                  return _tripCard(pastTrips[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Stack(
      children: [
        Image.asset(
          'assets/banner_explore.png',
          height: 170,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 170,
          color: Colors.black.withOpacity(0.25),
        ),
        const Positioned(
          left: 16,
          bottom: 20,
          child: Text(
            'My Trips',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Positioned(
          right: 16,
          top: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.search, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ================= TAB BAR =================
  Widget _tabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _TabItem('Current Trips', false),
          _TabItem('Next Trips', false),
          _TabItem('Past Trips', true),
          _TabItem('Wish List', false),
        ],
      ),
    );
  }

  // ================= TRIP CARD =================
  Widget _tripCard(Map<String, String> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Stack(
              children: [
                Image.asset(
                  trip['image']!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        trip['location']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      _infoRow(Icons.calendar_today, trip['date']!),
                      const SizedBox(height: 4),
                      _infoRow(Icons.access_time, trip['time']!),
                      const SizedBox(height: 4),
                      _infoRow(Icons.person, trip['guide']!),
                    ],
                  ),
                ),

                // avatar
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(trip['avatar']!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  // ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'My Trips'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// ================= TAB ITEM =================
class _TabItem extends StatelessWidget {
  final String text;
  final bool active;

  const _TabItem(this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.teal : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ================= MOCK DATA =================
final pastTrips = [
  {
    'image': 'assets/img1.png',
    'location': 'Hanoi, Vietnam',
    'title': 'Quoc Tu Giam Temple',
    'date': 'Feb 2, 2020',
    'time': '8:00 - 10:00',
    'guide': 'Emmy',
    'avatar': 'assets/img1.png',
  },
  {
    'image': 'assets/img1.png',
    'location': 'Ho Chi Minh, Vietnam',
    'title': 'Dinh Doc Lap',
    'date': 'Feb 2, 2020',
    'time': '8:00 - 10:00',
    'guide': 'Khai Ho',
    'avatar': 'assets/img1.png',
  },
];