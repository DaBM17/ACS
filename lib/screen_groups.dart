import 'package:flutter/material.dart';
import 'data.dart';
import "screen_list_groups.dart";
import "screen_info.dart";
import "screen_users.dart";
import "screen_schedule.dart";
import "screen_actions.dart";
import "screen_places.dart";

class ScreenGroup extends StatefulWidget {
  final UserGroup userGroup;

  ScreenGroup({super.key, required this.userGroup});

  @override
  State<ScreenGroup> createState() => _ScreenGroupState();
}

class _ScreenGroupState extends State<ScreenGroup> {
  late UserGroup userGroup;
  late List<User> users;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    users = widget.userGroup.users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group ${widget.userGroup.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => ScreenListGroups(userGroups: Data.userGroups),
            ));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Dos columnas
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGridItem(context, Icons.insert_drive_file, 'Info', InfoPage(userGroup: userGroup)),
            _buildGridItem(context, Icons.calendar_today, 'Schedule', SchedulePage(userGroup: userGroup)),
            _buildGridItem(context, Icons.build, 'Actions', ActionsPage(userGroup: userGroup)),
            _buildGridItem(context, Icons.location_city, 'Places', PlacesPage()),
            _buildGridItem(context, Icons.person, 'Users', UsersPage(users: users, userGroup: userGroup)),
          ],
        ),
      ),
    );
  }
  Widget _buildGridItem(BuildContext context, IconData icon, String label, Widget destinationPage) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(
          builder: (context) => destinationPage),
      ).then((_) {
        setState(() {});
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
