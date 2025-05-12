import 'package:flutter/material.dart';
import 'data.dart';

class ActionsPage extends StatefulWidget {
  UserGroup userGroup;

  ActionsPage({super.key, required this.userGroup});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  bool openValue = false;
  bool closeValue = false;
  bool lockValue = false;
  bool unlockValue = false;
  bool unlockShortlyValue = false;
  late UserGroup userGroup;

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    if (userGroup.actions.contains("open")) {
      openValue = true;
    }
    if (userGroup.actions.contains("close")) {
      closeValue = true;
    }
    if (userGroup.actions.contains("lock")) {
      lockValue = true;
    }
    if (userGroup.actions.contains("unlock")) {
      unlockValue = true;
    }
    if (userGroup.actions.contains("unlock_shortly")) {
      unlockShortlyValue = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actions')),
      body: Column(
        children: <Widget>[
          CheckboxListTile(
            value: openValue,
            onChanged: (bool? value) {
              setState(() {
                openValue = value!;
                if (openValue && !userGroup.actions.contains("open")) {
                  userGroup.actions.add("open");
                }
                else if (!openValue && userGroup.actions.contains("open")) {
                  userGroup.actions.remove("open");
                }
              });
            },
            title: const Text('Open'),
            subtitle: const Text('opens an unlocked door'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: closeValue,
            onChanged: (bool? value) {
              setState(() {
                closeValue = value!;
                if (closeValue && !userGroup.actions.contains("close")) {
                  userGroup.actions.add("close");
                }
                else if (!closeValue && userGroup.actions.contains("close")) {
                  userGroup.actions.remove("close");
                }
              });
            },
            title: const Text('Close'),
            subtitle: const Text('closes an open door'),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: lockValue,
            onChanged: (bool? value) {
              setState(() {
                lockValue = value!;
                if (lockValue && !userGroup.actions.contains("lock")) {
                  userGroup.actions.add("lock");
                }
                else if (!lockValue && userGroup.actions.contains("lock")) {
                  userGroup.actions.remove("lock");
                }
              });
            },
            title: const Text('Lock'),
            subtitle: const Text("locks a door or all the doors in a room or group of rooms, if closed"),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: unlockValue,
            onChanged: (bool? value) {
              setState(() {
                unlockValue = value!;
                if (unlockValue && !userGroup.actions.contains("unlock")) {
                  userGroup.actions.add("unlock");
                }
                else if (!unlockValue && userGroup.actions.contains("unlock")) {
                  userGroup.actions.remove("unlock");
                }
              });
            },
            title: const Text('Unlock'),
            subtitle: const Text("unlocks a locked door or all the locked doors in a room"),
          ),
          const Divider(height: 0),
          CheckboxListTile(
            value: unlockShortlyValue,
            onChanged: (bool? value) {
              setState(() {
                unlockShortlyValue = value!;
                if (unlockShortlyValue && !userGroup.actions.contains("unlock_shortly")) {
                  userGroup.actions.add("unlock_shortly");
                }
                else if (!unlockShortlyValue && userGroup.actions.contains("unlock_shortly")) {
                  userGroup.actions.remove("unlock_shortly");
                }
              });
            },
            title: const Text('Unlock shortly'),
            subtitle: const Text("Unlocks a door during 10 seconds and then locks it if it is closed"),
          ),
        ],
      ),
    );
  }
}