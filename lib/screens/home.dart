import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_unsplash/config.dart';
import 'package:flutter_unsplash/screens/image_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?> fetchData(int page, String query) async {
    const String apiUrl = 'https://api.unsplash.com/search/photos';
    // Provide your API key here
    const String apiKey = Config.apiKey;

    final Map<String, dynamic> parameters = {
      'query': query,
      // 'page': '',
      'client_id': apiKey,
      'per_page': '10',
      'orientation': 'portrait',
      'page': '$page',
    };

    try {
      final response = await http.get(
        Uri.parse(apiUrl).replace(queryParameters: parameters),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Successful API call
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        // Handle API error
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle other errors (e.g., network issues)
      print('Error: $e');
      return null;
    }
  }

  Map<String, dynamic>? data;
  int? page;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unsplash Image Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Stack(children: [
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search for images...',
                    ),
                  )),
              Expanded(
                child: GridView.builder(
                    itemCount: data == null ? 0 : data!['results'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(
                                data: data!['results'][index],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          child: Hero(
                            tag: data!['results'][index]['id'],
                            child: Image.network(
                                data!['results'][index]['urls']['small'],
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (page == null) {
                    page = 1;
                  } else if (page == 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('You have reached the limit of 100 images.'),
                      ),
                    );
                    return;
                  } else if (searchController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a search term'),
                      ),
                    );
                    return;
                  } else if (searchController.text.length < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Search term must be at least 3 characters'),
                      ),
                    );
                    return;
                  } else if (searchController.text.length > 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Search term must be less than 50 characters'),
                      ),
                    );
                    return;
                  }
                  Map<String, dynamic>? data2 =
                      await fetchData(page!, searchController.text);
                  setState(() {
                    page = page! + 1;
                    data = data2;
                    print(data);
                  });
                },
                child: const Text('Refresh Images'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
