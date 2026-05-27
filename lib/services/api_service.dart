import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String country,
    required String userType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'userType': userType,
      }),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  static Future<List<String>> getBanners() async {
    final response = await http.get(Uri.parse('$baseUrl/banners'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  static Future<List<Map<String, dynamic>>> getJourneys() async {
    final response = await http.get(Uri.parse('$baseUrl/journeys'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load journeys');
    }
  }

  static Future<List<Guide>> getGuides() async {
    final response = await http.get(Uri.parse('$baseUrl/guides'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Guide.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load guides');
    }
  }

  static Future<List<Experience>> getExperiences() async {
    final response = await http.get(Uri.parse('$baseUrl/experiences'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Experience.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load experiences');
    }
  }

  static Future<List<Tour>> getTours() async {
    final response = await http.get(Uri.parse('$baseUrl/tours'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Tour.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tours');
    }
  }

  static Future<List<Trip>> getTrips(String status) async {
    final response = await http.get(Uri.parse('$baseUrl/trips?status=$status'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Trip.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load $status');
    }
  }

  static Future<void> addTrip({
    required String title,
    required String location,
    required String date,
    required String time,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/trips'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'location': location,
        'date': date,
        'time': time,
        'status': 'Current Trips',
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add trip');
    }
  }

  static Future<void> deleteTrip(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/trips/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete trip');
    }
  }
}
