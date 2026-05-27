import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_models.dart';

// Removed Trip class from here as it is now in lib/models/app_models.dart

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- USER TRIPS ---
  Stream<List<Trip>> getUserTrips(String status) {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(uid)
        .collection('trips')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Trip.fromFirestore(doc.id, doc.data())).toList());
  }

  // --- TOURS ---
  Stream<List<Tour>> getTours() {
    return _db.collection('tours').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Tour.fromFirestore(doc.id, doc.data())).toList());
  }

  // --- GUIDES ---
  Stream<List<Guide>> getGuides() {
    return _db.collection('guides').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Guide.fromFirestore(doc.id, doc.data())).toList());
  }

  // --- EXPERIENCES ---
  Stream<List<Experience>> getExperiences() {
    return _db.collection('experiences').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Experience.fromFirestore(doc.id, doc.data())).toList());
  }

  // --- NEWS ---
  Stream<List<Map<String, dynamic>>> getNews() {
    return _db.collection('news').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // --- JOURNEYS (Top Journeys) ---
  Stream<List<Map<String, dynamic>>> getJourneys() {
    return _db.collection('journeys').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // --- BANNERS ---
  Stream<List<String>> getBanners() {
    return _db.collection('banners').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()['url'] as String).toList());
  }

  // --- SEED DATA (Helper to populate database) ---
  Future<void> seedInitialData() async {
    // Check if data already exists to avoid duplicates
    final snapshot = await _db.collection('tours').limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    // Seed Banners
    final banners = [
      "assets/banner_explore.png",
      "assets/banner_explore.png",
    ];
    for (var b in banners) {
      await _db.collection('banners').add({'url': b});
    }

    // Seed Journeys
    final journeys = [
      {
        "image": "assets/journey1.png",
        "title": "Bana Hill & Golden Bridge",
        "date": "24/04/2026",
        "days": "1 days",
        "price": "\$15.00",
      },
      {
        "image": "assets/journey2.png",
        "title": "Son Tra Peninsula",
        "date": "25/04/2026",
        "days": "2 days",
        "price": "\$20.00",
      }
    ];
    for (var j in journeys) {
      await _db.collection('journeys').add(j);
    }

    // Seed Guides
    final guides = [
      {"name": "Emmy Jin", "image": "assets/emmy.png", "role": "Fulltime Guide", "reviews": 127},
      {"name": "Yoo Jin", "image": "assets/yoojin.png", "role": "Part-time Guide", "reviews": 85},
    ];
    for (var g in guides) {
      await _db.collection('guides').add(g);
    }
    
    // Seed Tours
    final tours = [
      {
        "image": "assets/tour1.png",
        "title": "Da Nang - Ba Na Hills",
        "date": "May 10, 2026",
        "days": "1 Day",
        "price": "\$45.00",
        "isSaved": true,
        "isLiked": false,
        "likes": 1247
      }
    ];
    for (var t in tours) {
      await _db.collection('tours').add(t);
    }
  }
}
