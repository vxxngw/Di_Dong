import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/app_models.dart';

class PastTripsPage extends StatelessWidget {
  const PastTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trip>>(
      future: ApiService.getTrips("Past Trips"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final trips = snapshot.data ?? [];
        if (trips.isEmpty) {
          return const Center(child: Text("No past trips found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final t = trips[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PastTripCard(
                title: t.title,
                location: t.location,
                image: t.image,
                date: t.date,
                time: t.time,
                guide: "Local Guide",
                avatar: t.avatar,
                highlight: false,
              ),
            );
          },
        );
      },
    );
  }
}

class PastTripCard extends StatelessWidget {
  final String title;
  final String location;
  final String image;
  final String date;
  final String time;
  final String guide;
  final String avatar;
  final bool highlight;

  const PastTripCard({
    super.key,
    required this.title,
    required this.location,
    required this.image,
    required this.date,
    required this.time,
    required this.guide,
    required this.avatar,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: highlight ? Border.all(color: Colors.blue, width: 2) : null,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: AspectRatio(
              aspectRatio: 342 / 135,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Color(0xff19c2a4)),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(color: Color(0xff19c2a4), fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(date, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(time, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(guide, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff19c2a4), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(avatar),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}