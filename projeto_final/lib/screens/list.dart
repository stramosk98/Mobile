import 'package:flutter/material.dart';
import '../models/picture.dart';

class PictureListScreen extends StatelessWidget {
  final Future<List<Picture>> pictureListFuture;

  const PictureListScreen({super.key, required this.pictureListFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Pictures')),
      body: FutureBuilder<List<Picture>>(
        future: pictureListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pictures available.'));
          } else {
            final pictures = snapshot.data!;
            return ListView.builder(
              itemCount: pictures.length,
              itemBuilder: (context, index) {
                final picture = pictures[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(picture.url, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(picture.date),
                    subtitle: Text(picture.author),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(picture.date),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 160,
                                child: Image.network(
                                  picture.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  picture.explanation,
                                  maxLines: 8, 
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
