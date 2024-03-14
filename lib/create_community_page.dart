import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({Key? key}) : super(key: key);

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final TextEditingController _communityNameController =
      TextEditingController();
  final int _maxLength = 21;

  String _communityType = 'Public';
  String _communityTypeDescription =
      'Anyone can view, post, and comment to this community.';
  bool _is18Plus = false;

  Future<http.Client> createMockHttpClient() async {
    return MockClient((request) async {
      final uri = request.url;
      final path = uri.path;
      // Simulate a check for existing subreddit
      if (path.contains('/subreddit/') && request.method == 'GET') {
        final subredditName = path.split('/').last;
        if (subredditName.toLowerCase() == 'creddit_sw_project') {
          // Simulate subreddit exists with detailed information
          return http.Response(
              jsonEncode({
                "profilePicture": "drive.creddit.com/test",
                "mods": ["SlaxSplash", "Baroudy 14", "No_Animator_8210"],
                "members": 1000,
                "name": "r/cReddit_SW_Project",
                "banner": "drive.creddit.com/test",
                "rules": ["Rule 1", "Rule 2", "Rule 3"],
              }),
              200);
        } else {
          // Simulate subreddit does not exist
          return http.Response(
              jsonEncode({"message": "Subreddit does not exist"}), 404);
        }
      } else if (path == '/subreddit' && request.method == 'POST') {
        final requestBody = json.decode(request.body);
        if (requestBody['name'].toLowerCase() != 'creddit_sw_project') {
          // Simulate successful community creation if the name isn't "creddit_sw_project"
          return http.Response(
              jsonEncode({"message": "Community created successfully"}), 200);
        } else {
          // Simulate failure to create community if the name is "creddit_sw_project" (since it already exists)
          return http.Response(
              jsonEncode({"message": "Subreddit already exists"}), 400);
        }
      }
      return http.Response('Not Found', 404);
    });
  }

  @override
  void initState() {
    super.initState();
    _communityNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(16, 16, 16, 1),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 0),
              const Text(
                'Community Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                controller: _communityNameController,
                maxLength: _maxLength,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(32, 32, 32, 1),
                  hintText: 'r/Community_name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Text(
                'Community Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              InkWell(
                onTap: () => _showCommunityTypeSelection(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _communityType,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                _communityTypeDescription,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '18+ Community',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: _is18Plus,
                    onChanged: (value) {
                      setState(() {
                        _is18Plus = value;
                      });
                    },
                    activeTrackColor: Color.fromRGBO(0, 110, 199, 1),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Color.fromRGBO(30, 30, 30, 1),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed:
                      _isButtonEnabled() ? _createCommunity : _createCommunity,
                  child: Text(
                    'Create Community',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          _isButtonEnabled() ? Colors.white : Colors.grey[400],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled()
                        ? Color.fromRGBO(54, 143, 233, 1)
                        : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommunityTypeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select Community Type',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: const Text('Public'),
                  subtitle: const Text(
                      'Anyone can view, post, and comment to this community.'),
                  onTap: () => _selectCommunityType('Public', context),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_open),
                  title: const Text('Restricted'),
                  subtitle: const Text(
                      'Anyone can view this community, but only approved users can post.'),
                  onTap: () => _selectCommunityType('Restricted', context),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Private'),
                  subtitle: const Text(
                      'Only approved users can view and submit to this community.'),
                  onTap: () => _selectCommunityType('Private', context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectCommunityType(String type, BuildContext context) {
    String description;
    switch (type) {
      case 'Public':
        description = 'Anyone can view, post, and comment to this community.';
        break;
      case 'Restricted':
        description =
            'Anyone can view this community, but only approved users can post.';
        break;
      case 'Private':
        description =
            'Only approved users can view and submit to this community.';
        break;
      default:
        description = '';
    }
    setState(() {
      _communityType = type;
      _communityTypeDescription = description;
    });
    Navigator.pop(context);
  }

  bool _isButtonEnabled() {
    return (_communityNameController.text.isNotEmpty &&
        _communityNameController.text != "");
  }

  void _createCommunity() {
    print('Creating community: ${_communityNameController.text}');
  }
}
