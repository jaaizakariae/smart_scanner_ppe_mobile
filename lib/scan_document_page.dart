import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'camera_screen.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ScanDocumentPage extends StatefulWidget {
  const ScanDocumentPage({Key? key}) : super(key: key);

  @override
  _ScanDocumentPageState createState() => _ScanDocumentPageState();
}

class _ScanDocumentPageState extends State<ScanDocumentPage> {
  String? _imagePath;
  String? _idToken;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _idToken = await user.getIdToken();
    }
  }

  Future<void> _uploadDocument() async {
    if (_imagePath == null || _idToken == null) return;

    final url = 'http://192.168.0.106:8080/api/v1/public/upload'; // Replace with your API endpoint
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(await http.MultipartFile.fromPath('file', _imagePath!));
    request.headers['Authorization'] = 'Bearer $_idToken';

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Document')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: _imagePath != null
                  ? Image.file(
                File(_imagePath!),
                fit: BoxFit.contain,
              )
                  : Center(
                child: Text(
                  'Your scanned document will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScreen()),
                  );
                  if (result != null && result is String) {
                    setState(() {
                      _imagePath = result;
                    });
                  }
                },
                child: const Text('Scan Document'),
              ),
              ElevatedButton(
                onPressed: _uploadDocument,
                child: const Text('Upload'),
              ),
            ],
          ),
          SizedBox(height: 20), // Add some spacing at the bottom
        ],
      ),
    );
  }
}
