import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  final String userName;
  final String profilePictureUrl;
  final String bannerUrl;
  final String displayName;
  final String about;

  const ProfileSettings({
    Key? key,
    required this.userName,
    required this.profilePictureUrl,
    required this.bannerUrl,
    this.displayName = '',
    this.about = '',
  }) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late TextEditingController _displayNameController;
  late TextEditingController _aboutController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: widget.displayName);
    _aboutController = TextEditingController(text: widget.about);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _changeBannerImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Banner Image selected: ${image.path}');
      // Update state to reflect new banner image, if applicable
    }
  }

  Future<void> _changeProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Profile Image selected: ${image.path}');
      // Update state to reflect new profile image, if applicable
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              print('Save profile settings');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              InkWell(
                onTap: _changeBannerImage,
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.bannerUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white70, size: 24),
                ),
              ),
              Positioned(
                top: 60, // Adjusted to ensure visibility
                child: InkWell(
                  onTap: _changeProfileImage,
                  child: CircleAvatar(
                    radius: 43,
                    backgroundImage: NetworkImage(widget.profilePictureUrl),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 15,
                        child: const Icon(Icons.camera_alt,
                            size: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
              height:
                  0), // Adjusted spacing to accommodate new profile pic position
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display name - optional',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This will be displayed to viewers of your profile page and does not change your username.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _aboutController,
                  decoration: InputDecoration(
                    labelText: 'About you',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
