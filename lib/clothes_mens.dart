import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myntra/recommendation.dart';

class DisplayMensPage extends StatefulWidget {
  @override
  _DisplayMensPageState createState() => _DisplayMensPageState();
}

class _DisplayMensPageState extends State<DisplayMensPage> {
  List<List<dynamic>>? csvData;
  List<Map<String, dynamic>> filteredData = [];
  final random = Random();

  Future<void> loadAndDisplayCsvData() async {
    csvData = await processCsv();

    if (csvData != null && csvData!.isNotEmpty) {
      // Extract header and data rows
      List<String> header = List<String>.from(csvData![0]);
      List<List<dynamic>> dataRows = csvData!.sublist(
        1,
      );

      // Trim all headers to ensure consistency
      header = header.map((col) => col.trim()).toList();

// Print header to check column names
      print("Headers: $header");

      // Filter rows based on the criteria and store them in a map format
      filteredData = dataRows
          .where((row) {
            int genderIndex = header.indexOf('gender');
            int masterCategoryIndex = header.indexOf('masterCategory');

            return (row[genderIndex] == 'Men' &&
                (row[masterCategoryIndex] == 'Topwear' ||
                    row[masterCategoryIndex] == 'Bottomwear'));
          })
          .map((row) {
            return Map<String, dynamic>.fromIterables(header, row);
          })
          .take(20)
          .toList();

      print(filteredData.length); // Check the entire dataset

      setState(() {}); // Refresh the UI to display filtered data
    } else {
      print("No data found.");
    }
  }

  Future<List<List<dynamic>>> processCsv() async {
    var result = await DefaultAssetBundle.of(context).loadString(
      "assets/merged4.csv",
    );
    return const CsvToListConverter().convert(result, eol: "\n");
  }

  @override
  void initState() {
    super.initState();
    loadAndDisplayCsvData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Men's Clothing"),
      ),
      body: filteredData.isNotEmpty
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                mainAxisSpacing: 0, // Spacing between rows
                crossAxisSpacing: 0, // Spacing between columns
                childAspectRatio: 0.36, // Lower ratio for increased height
              ),
              padding: EdgeInsets.all(10),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                var item = filteredData[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(3),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CachedNetworkImage(
                            imageUrl: item['link'].trim() ??
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
                        SizedBox(height: 10),
                        Text(
                          item['productDisplayName'] ?? 'Product Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "${item['articleType'] ?? "articleType"} | ${item['baseColour'] ?? "baseColour"} | ${item['season'] ?? "season"} | ${item['usage'] ?? "usage"}"),
                        SizedBox(height: 10),
                        Text(
                          "₹${(500 + random.nextInt(1200 - 500 + 1)).toString()}",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)),
                          overflow: TextOverflow
                              .ellipsis, // Set maximum number of lines for wrapping
                          softWrap: true, // Enable automatic text wrapping
                        ),
                        RatingBar.builder(
                          initialRating:
                              (3.0 + random.nextDouble() * (5.0 - 3.5)),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemSize: 25,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Pass the selected item ID to RecommendationPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationPage(
                                    itemId: item['id']), // Pass item ID here
                              ),
                            );
                          },
                          child: Text("Get outfit recommendation"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
