// ignore_for_file: use_build_context_synchronously, file_names, library_private_types_in_public_api, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_application_lab_2/model/jobs.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HiveCRUDPage extends StatelessWidget {
  const HiveCRUDPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HiveInsertPage()),
                );
              },
              child: const Text('Insert Job'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FirestoreReadPage ()),
                );
              },
              child: const Text('Read from Firebase'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreUpdatePage()),
                );
              },
              child: const Text('Update Job'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirestoreDeletePage()),
                );
              },
              child: const Text('Delete Job'),
            ),
          ],
        ),
      ),
    );
  }
}

class HiveInsertPage extends StatefulWidget {
  const HiveInsertPage({super.key});

  @override
  _HiveInsertPageState createState() => _HiveInsertPageState();
}

class _HiveInsertPageState extends State<HiveInsertPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _directorController,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
            TextField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Category'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final director = _directorController.text;
                final rating = _ratingController.text;

                if (rating == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a valid number for rating'),
                  ));
                  return;
                }
                final job = {
                  'Title': title,
                  'Duration': director,
                  'Category': rating,
                };

                await FirebaseFirestore.instance.collection('jobs').add(job);

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Job added to Firestore'),
                ));


                _titleController.clear();
                _directorController.clear();
                _ratingController.clear();
              },
              child: const Text('Add Job'),
            ),
          ],
        ),
      ),
    );
  }
}


class FirestoreReadPage extends StatelessWidget {
  const FirestoreReadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read from Firestore'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final documents = snapshot.data?.docs ?? [];
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final job = Job.fromFirestore(documents[index]);
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text('Duration: ${job.duration}, Category: ${job.category}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getJobs() {
    return FirebaseFirestore.instance.collection('jobs').snapshots();
  }
}


class FirestoreUpdatePage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  FirestoreUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final id = _idController.text;
                final title = _titleController.text;
                final duration = _durationController.text;
                final category = _categoryController.text;

                try {
                  await updateJob(id, title, duration, category);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job updated in Firestore'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update job: $e'),
                    ),
                  );
                }
              },
              child: Text('Update Job'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateJob(String id, String title, String duration, String category) async {
    final collection = FirebaseFirestore.instance.collection('jobs');
    final document = collection.doc(id.toString());

    await document.update({
      'Title': title,
      'Duration': duration,
      'Category': category,
    });
  }
}

class FirestoreDeletePage extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();

  FirestoreDeletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete from Firestore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _idController,
               key: ValueKey('id_field'),
              decoration: InputDecoration(labelText: 'ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              key: ValueKey('Button'), 
              onPressed: () async {
                final id = _idController.text;

                try {
                  await deleteJob(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job deleted from Firestore'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete job: $e'),
                    ),
                  );
                }
              },
              child: Text('Delete Job'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteJob(String id) async {
    final collection = FirebaseFirestore.instance.collection('jobs');
    final document = collection.doc(id.toString());

    await document.delete();
  }
}
