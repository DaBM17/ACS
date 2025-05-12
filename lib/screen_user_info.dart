import 'dart:io';

import 'package:flutter/material.dart';
import 'data.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  User user;

  UserInfo({super.key, required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late User user;
  late TextEditingController nameController;
  late TextEditingController credentialController;
  File? _selectedImage;
  late FileImage imageAvatar;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    nameController = TextEditingController(text: widget.user.name);
    credentialController = TextEditingController(text: widget.user.credential);
    String rightName = user.name;
    if (rightName.contains("New User", 0)) {
      rightName = "new user";
    }
    imageAvatar = FileImage(File(Data.images[rightName.toLowerCase()]!));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        imageAvatar = FileImage(File(pickedFile.path));
      });
      // Data.images[user.name.toLowerCase()]!
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: imageAvatar,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "name",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              const Text(
                "credential",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: credentialController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a credential';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Actualizamos los valores del objeto y del título
                      widget.user.name = nameController.text;
                      if (!Data.images.keys.contains(user.name)) {
                        Data.images[user.name] = 'faces/new_user.png';
                      }
                      widget.user.credential = credentialController.text;
                      if (!Data.images.keys.contains(user.name)) {
                        Data.images[user.name] = imageAvatar.file.path;
                      }
                      Data.images[user.name.toLowerCase()] = imageAvatar.file.path;
                    });

                    // Mensaje de confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}