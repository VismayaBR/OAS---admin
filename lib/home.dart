import 'package:admin/Auctions.dart';
import 'package:admin/Notif.dart';
import 'package:admin/search.dart';
import 'package:admin/usersdet.dart';
import 'package:flutter/material.dart';
import 'reports.dart';
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 0, 59),
      appBar: AppBar(
        actions: const [
          Icon(Icons.exit_to_app)],
        automaticallyImplyLeading: false,
        backgroundColor:const Color.fromARGB(255, 1, 1, 82),
        elevation: 0,
        title: const Text('Adlmin',style: TextStyle(

          fontWeight: FontWeight.w400,
          color: Color.fromARGB(184, 255, 255, 255)
        ),),
      ),
      body: Row(
        children: <Widget>[
          RotatedBox(
            quarterTurns: -1,
            child: TabBar(isScrollable: true,
              controller: _tabController,
              indicatorColor: const Color.fromARGB(255, 82, 0, 145),
              labelColor: const Color.fromARGB(255, 185, 63, 255),
              unselectedLabelColor:const  Color.fromARGB(255, 255, 255, 255),
              tabs: const [
                Tab(text: 'Reports'),
                Tab(text: 'Search Auctions'),
                Tab(text: 'Auctions'),
                Tab(text: 'Users'),
                Tab(text: 'Notifications'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Reportsfrmuser(),
                SearchAny(),
                AuctionDetails(),
                UserDetails(),
                Notifications()


               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
