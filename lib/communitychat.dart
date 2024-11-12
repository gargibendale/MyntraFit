import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ChatPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pinkAccent[100],
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.grey[800]),
          displaySmall: TextStyle(color: Colors.grey[700]),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color.fromARGB(255, 255, 237, 225)),
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isAnonymous = false;
  TextEditingController storyController = TextEditingController();
  List<String> _imageUrls = [];
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null) {
      for (XFile image in selectedImages) {
        String url = await _uploadImage(image);
        setState(() {
          _imageUrls.add(url);
        });
      }
    }
  }

  Future<String> _uploadImage(XFile image) async {
    Uint8List data = await image.readAsBytes();
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '_' + image.name;
    Reference ref =
        FirebaseStorage.instance.ref().child('Chat_images/$fileName');
    try {
      await ref.putData(data);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      return '';
    }
  }

  Future<void> _submitStory() async {
    String story = storyController.text.trim();
    if (story.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Share your thoughts here')));
      return;
    }
    Map<String, dynamic> data = {
      'story': story,
      'timestamp': FieldValue.serverTimestamp(),
      'images': _imageUrls,
    };
    if (!isAnonymous && user != null) {
      String userId = user!.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        String userName = userDoc.exists && userDoc['fullName'] != null
            ? "${userDoc['fullName']}".trim()
            : 'Anonymous';
        data['userId'] = userId;
        data['userName'] = userName;
      } catch (e) {
        data['userId'] = userId;
        data['userName'] = 'Anonymous';
      }
    }
    try {
      await FirebaseFirestore.instance.collection('reports').add(data);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Posted successfully')));
      storyController.clear();
      setState(() {
        _imageUrls.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to submit post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        title: Text(
          'Share Your Thoughts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'What do you think about our products?',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Post Anonymously',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  Switch(
                    value: isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        isAnonymous = value;
                      });
                    },
                    activeColor: Colors.pinkAccent[100],
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: storyController,
                maxLines: 5,
                style: TextStyle(color: Colors.grey[800]),
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.red[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Upload Picture (Optional)',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImages,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey[800],
                        backgroundColor:
                            const Color.fromARGB(255, 255, 185, 141),
                      ),
                      child: Text('Pick Images'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submitStory,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pinkAccent[100],
                      ),
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _imageUrls.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: _imageUrls.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.network(
                              _imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.remove_circle,
                                    color: Colors.redAccent[100]),
                                onPressed: () {
                                  setState(() {
                                    _imageUrls.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatPageApp());
}
