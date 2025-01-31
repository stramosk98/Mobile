import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projeto_final/screens/list.dart';
import 'package:projeto_final/services/nasa.dart';
import 'package:projeto_final/services/picture.dart';
import 'services/database.dart';
import 'models/picture.dart';
import 'screens/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA Picture of the Day App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // Display the splash screen
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHandler _dbHandler = DatabaseHandler();
  late final PictureRepository _pictureRepository;

  Future<Map<String, dynamic>>? _pictureFuture;
  Future<List<Picture>>? _pictureListFuture;

  @override
  void initState() {
    super.initState();
    _dbHandler.initializeDB();
    _pictureRepository = PictureRepository(_dbHandler);
  }

  Future<Map<String, dynamic>> _fetchPicture(String date) async {
    try {
      final nasaResponse = await NasaService().fetchPicture(date);
      final picture = Picture(
        author: nasaResponse['copyright'] ?? 'Unknown',
        date: nasaResponse['date'],
        explanation: nasaResponse['explanation'],
        url: nasaResponse['hdurl'],
      );

      final saveResponse = await _savePictureToBackend(picture);

      if (saveResponse['status'] == 'success') {
        print('Data saved to backend successfully');
      } else {
        print('Failed to save data to backend: ${saveResponse['message']}');
      }

      return nasaResponse;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Map<String, dynamic>> _savePictureToBackend(Picture picture) async {
    const String backendUrl = 'http://127.0.0.1/api_flutter/store.php';
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: ''
        },
        body: jsonEncode(picture)
      );

      if (response.statusCode != 404) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  Future<List<Picture>> _fetchPictureList() async {
    const String backendUrl = 'http://127.0.0.1/api_flutter/list.php';

    try {
      final response = await http.get(Uri.parse(backendUrl));

      print(response.body);
      if (response.statusCode != 404) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Picture.fromMap(item)).toList();
      } else {
        throw Exception('Failed to fetch picture list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to backend: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.text = pickedDate.toString().split(" ")[0];
        _pictureFuture = _fetchPicture(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NASA Picture of the Day App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _controller.text.isEmpty ? 'Select a Date' : _controller.text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pictureFuture = _fetchPicture(_controller.text);
                });
              },
              child: const Text('Get NASA Picture'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PictureListScreen(
                      pictureListFuture: _fetchPictureList(),
                    ),
                  ),
                );
              },
              child: const Text('Get List of Pictures'),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _pictureFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found. Select a date and fetch the picture.'));
                  } else {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Author: ${data['copyright'] ?? 'Unknown'}', style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 10),
                          Text('Date: ${data['date']}', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 10),
                          const Text('Explanation:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(data['explanation'], style: const TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 300,
                            child: Image.network(
                              data['hdurl'],
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    );
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}