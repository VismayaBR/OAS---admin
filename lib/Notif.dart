import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _selectedOption = 'global'; // Default selected option
  String? _selectedUser; // Store selected user ID
  List<Map<String, dynamic>> _users = []; // List to store fetched users
  var message = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _users = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _onSubmit() async {
    if (message.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    if (_selectedOption == 'user' && _selectedUser == null) {
      // Show an error if user option is selected but no user is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a user')),
      );
      return;
    }

    try {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      String formattedDate = formatter.format(now);
      await FirebaseFirestore.instance.collection('notification').add({
        'type': _selectedOption,
        'user': _selectedUser ?? '',
        'notification': message.text,
        'date': formattedDate
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification submitted successfully')),
      );
      message.clear();
      setState(() {
        _selectedUser = null;
        _selectedOption = 'global';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting notification: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(133, 134, 0, 125),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                'Post notifications',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 217, 203, 255),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ListTile(
                        title: const Text(
                          'Global',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: 'global',
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                              _selectedUser = null; // Clear selected user
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ListTile(
                        title: const Text(
                          'User',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: 'user',
                          groupValue: _selectedOption,
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedOption == 'user')
                  DropdownButton<String>(
                    hint: Text('Select a user'),
                    value: _selectedUser,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUser = newValue;
                      });
                    },
                    items: _users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user['name'],
                        child: Text(user['name'] ?? 'N/A'),
                      );
                    }).toList(),
                  ),
              ],
            ),
            Container(
              height: 255,
              width: 698,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: message,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '  Type here...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              height: 39,
              width: 88,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(197, 32, 10, 46),
                    blurRadius: 14,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ],
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadiusDirectional.circular(7),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 51, 6, 76),
                    Color.fromARGB(255, 19, 2, 65)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.4, 0.7],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: _onSubmit,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
