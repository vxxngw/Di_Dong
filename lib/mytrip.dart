import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/app_models.dart';
import 'trip_detail_screen.dart';
import 'chat_screen.dart';
import 'add_trip_screen.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  String tab = "Current Trips";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset("assets/banner_explore.png", height: 160, width: double.infinity, fit: BoxFit.cover),
              Container(height: 160, color: Colors.black.withOpacity(.3)),
              const Positioned(
                left: 20, bottom: 20,
                child: Text("My Trips", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tab("Current Trips"),
                _tab("Next Trips"),
                _tab("Past Trips"),
                _tab("Wish List"),
              ],
            ),
          ),
          Expanded(child: _buildTabContent())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'mytrips_fab',
        backgroundColor: Colors.teal,
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTripScreen()));
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tab(String name) {
    bool active = tab == name;
    return GestureDetector(
      onTap: () => setState(() => tab = name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: active ? Colors.teal : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(name, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTabContent() {
    return _buildTripsFuture(tab);
  }

  Widget _buildTripsFuture(String status) {
    return FutureBuilder<List<Trip>>(
      future: ApiService.getTrips(status),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final trips = snapshot.data!;
        if (trips.isEmpty) return const Center(child: Text("No trips found"));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final t = trips[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _tripCard(t),
            );
          },
        );
      },
    );
  }

  Widget _tripCard(Trip t) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.asset(t.image, height: 130, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  right: 12, bottom: -18,
                  child: CircleAvatar(radius: 22, backgroundColor: Colors.white, child: CircleAvatar(radius: 20, backgroundImage: AssetImage(t.avatar))),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.teal), const SizedBox(width: 4), Text(t.location, style: const TextStyle(color: Colors.teal, fontSize: 13))]),
                const SizedBox(height: 6),
                Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text("${t.date} • ${t.time}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 10),
                Row(children: [
                  OutlinedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: t)));
                  }, child: const Text("Detail")),
                  const SizedBox(width: 10),
                  OutlinedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(trip: t)));
                  }, child: const Text("Chat")),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}