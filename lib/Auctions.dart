import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuctionDetails extends StatefulWidget {
  const AuctionDetails({super.key});

  @override
  State<AuctionDetails> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  String _selectedCategory = 'Items';

  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(_selectedCategory.toLowerCase()).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(133, 134, 0, 125),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'Items',
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  Text('Items',style: TextStyle(color: Colors.white),),
                  SizedBox(width: 20),
                  Radio<String>(
                    value: 'Services',
                    groupValue: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  Text('Services',style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data found');
                }
            
                var data = snapshot.data!;
            
                return Container(
                  height: 422,
                  width: 633,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 229, 190, 255),
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
                          TableRow(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Details',
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
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['title'] ?? 'N/A'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Summary'),
                                      SizedBox(
                                        width: 250,
                                        child: Text(item['summary'] ?? 'N/A'),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Starting amount'),
                                          Text(item['amount'].toString() ?? 'N/A'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Ending date'),
                                          Text(item['duration'] ?? 'N/A'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
