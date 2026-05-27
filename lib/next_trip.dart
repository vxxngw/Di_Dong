import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/app_models.dart';

class NextTripsPage extends StatelessWidget {
  const NextTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trip>>(
      future: ApiService.getTrips("Next Trips"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final trips = snapshot.data ?? [];
        if (trips.isEmpty) {
          return const Center(child: Text("No upcoming trips found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final t = trips[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TripCard(
                title: t.title,
                location: t.location,
                image: t.image,
                date: t.date,
                time: t.time,
                status: "Ready to go",
                avatar: t.avatar,
                badge: "Upcoming",
                buttons: const ["Detail", "Chat"],
              ),
            );
          },
        );
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final String title;
  final String location;
  final String image;
  final String date;
  final String time;
  final String status;
  final String avatar;
  final String? badge;
  final List<String> buttons;

  const TripCard({
    super.key,
    required this.title,
    required this.location,
    required this.image,
    required this.date,
    required this.time,
    required this.status,
    required this.avatar,
    this.badge,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.asset(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (badge != null)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              const Positioned(
                right: 10,
                top: 10,
                child: Icon(Icons.more_horiz, color: Colors.white),
              )
            ],
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
                      const SizedBox(height: 4),
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
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(time, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        status,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: buttons
                            .map(
                              (b) => OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xff19c2a4),
                                  side: const BorderSide(color: Color(0xff19c2a4)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                ),
                                onPressed: () {},
                                child: Text(b),
                              ),
                            )
                            .toList(),
                      )
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