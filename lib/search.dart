import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchAny extends StatefulWidget {
  const SearchAny({super.key});

  @override
  State<SearchAny> createState() => _SearchAnyState();
}

class _SearchAnyState extends State<SearchAny> {
  final Set<String> _clickedItems = {};

  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('bid_collection').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return data;
      }).toList();
    } catch (e) {
      // print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(133, 134, 0, 125),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No reports found');
            }

            var data = snapshot.data!;

            return Container(
              height: 422,
              width: 633,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 229, 190, 255),
                borderRadius: BorderRadius.circular(7),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    children: [
                      const TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Bidding item',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Bid amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'User',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Announce winner',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...data.map((item) {
                        final itemId = item['id'];
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['name'] ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['bid'].toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['username'].toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _clickedItems.contains(itemId)
                                          ? Colors.green
                                          : null,
                                ),
                                child: const Text('Won'),
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('winner')
                                      .add({
                                    'user': item['username'],
                                    'item': item['name'],
                                    'bid': item['bid'],
                                    'mobile': item['mobile']
                                  });
                                  QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('items')
                                          .where('title',
                                              isEqualTo: item['name'])
                                          .get();

                                  for (var doc in querySnapshot.docs) {
                                    await doc.reference.update({'status': '1'});
                                  }
                                  setState(() {
                                    _clickedItems.add(itemId);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
