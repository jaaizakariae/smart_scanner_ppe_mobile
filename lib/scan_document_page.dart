import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'dart:io';

class ScanDocumentPage extends StatefulWidget {
  const ScanDocumentPage({Key? key}) : super(key: key);

  @override
  _ScanDocumentPageState createState() => _ScanDocumentPageState();
}

class _ScanDocumentPageState extends State<ScanDocumentPage> {
  String? _imagePath;

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
          SizedBox(height: 20), // Add some spacing at the bottom
        ],
      ),
    );
  }
}
