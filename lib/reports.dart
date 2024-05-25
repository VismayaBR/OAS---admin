import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reportsfrmuser extends StatefulWidget {
  const Reportsfrmuser({super.key});

  @override
  State<Reportsfrmuser> createState() => _ReportsfrmuserState();
}

class _ReportsfrmuserState extends State<Reportsfrmuser> {
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('report').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
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
              height: 322,
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
                    const  TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Text(
                                'UserName',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Text(
                                'Contents',
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
                              child: Text(item['user'] ?? 'N/A'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item['report'] ?? 'N/A'),
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
