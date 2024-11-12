import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'dart:convert';

class RecommendationPage extends StatefulWidget {
  final int itemId;

  const RecommendationPage({Key? key, required this.itemId}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  Map<String, List<int>> recommendations = {
    "accessories": [],
    "bottomwear": [],
    "footwear": [],
    "topwear": []
  };
  bool isLoading = true;
  final random = Random();
  List<List<dynamic>> csvData = [];
  Map<String, dynamic> originalItem = {};

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    try {
      // Fetch recommendations from the server
      final response = await http.get(Uri.parse(
          'https://summary-currently-chipmunk.ngrok-free.app/recommendations?id=${widget.itemId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        recommendations = {
          "accessories": List<int>.from(data["accessories"] ?? []),
          "bottomwear": List<int>.from(data["bottomwear"] ?? []),
          "footwear": List<int>.from(data["footwear"] ?? []),
          "topwear": List<int>.from(data["topwear"] ?? []),
        };

        // Load CSV data
        await loadCsvData();

        // Get details for the original selected item
        originalItem = findItemDetailsById(widget.itemId);

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      print("Error fetching recommendations: $e");
    }
  }

  Future<void> loadCsvData() async {
    final csvString = await rootBundle.loadString('assets/merged4.csv');
    csvData = CsvToListConverter().convert(csvString, eol: "\n");
  }

  Map<String, dynamic> findItemDetailsById(int id) {
    for (var row in csvData) {
      if (row[0] == id) {
        return {
          'id': row[0],
          'imageLink': row[11],
          'productDisplayName': row[9],
          'description': '${row[4]} | ${row[5]} | ${row[6]} | ${row[8]}',
        };
      }
    }
    return {};
  }

  List<Widget> buildSlider(String category) {
    return recommendations[category]!.map((id) {
      int randomNumber = 500 + random.nextInt(1200 - 500 + 1);
      double randomNumber2 = 3.0 + random.nextDouble() * (5.0 - 3.5);
      final item = findItemDetailsById(id);
      return Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: item['imageLink'].trim() ??
                    'https://via.placeholder.com/150',
                height: 150,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  print(
                      "Image load error: ${error} for URL: $url"); // Print the error and URL
                  return const Icon(Icons.error);
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['productDisplayName'],
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Set maximum number of lines for wrapping
              softWrap: true, // Enable automatic text wrapping
            ),
            Text(
              item['description'],
              style: TextStyle(color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
              maxLines: 3, // Set maximum number of lines for wrapping
              softWrap: true, // Enable automatic text wrapping
            ),
            Text(
              "₹${randomNumber.toString()}",
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              overflow: TextOverflow
                  .ellipsis, // Set maximum number of lines for wrapping
              softWrap: true, // Enable automatic text wrapping
            ),
            RatingBar.builder(
              initialRating: randomNumber2,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 25,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customize your outfit!☆")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  // Display original item
                  if (originalItem.isNotEmpty)
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: originalItem['imageLink'].trim() ??
                              'https://via.placeholder.com/150',
                          height: 150,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) {
                            print(
                                "Image load error: ${error} for URL: $url"); // Print the error and URL
                            return const Icon(Icons.error);
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          originalItem['productDisplayName'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          originalItem['description'],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  // Recommendation sliders
                  if (recommendations['bottomwear']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Bottomwear", style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildSlider("bottomwear"),
                          ),
                        ),
                      ],
                    ),
                  // Recommendation sliders
                  if (recommendations['topwear']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Topwear", style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildSlider("topwear"),
                          ),
                        ),
                      ],
                    ),
                  if (recommendations['footwear']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Footwear", style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildSlider("footwear"),
                          ),
                        ),
                      ],
                    ),
                  if (recommendations['accessories']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Accessories", style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildSlider("accessories"),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
