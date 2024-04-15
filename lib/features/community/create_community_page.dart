import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final _communityNameController = TextEditingController();
  final int _maxLength = 21;

  bool subredditExists = false;

  String _communityType = 'Public';
  String _communityTypeDescription =
      'Anyone can view, post, and comment to this community.';
  bool _is18Plus = false;

  @override
  void initState() {
    super.initState();
    _communityNameController.addListener(checkSubredditExistence);
  }

  void checkSubredditExistence() async {
    final subredditName = _communityNameController.text.trim();
    final networkService = Provider.of<NetworkService>(context, listen: false);
    subredditExists =
        await networkService.isSubredditNameAvailable(subredditName);
    subredditExists = !subredditExists;
    if (subredditName.isEmpty) {
      setState(() {
        subredditExists = false;
      });
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
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
                  fillColor: const Color.fromRGBO(32, 32, 32, 1),
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
              if (subredditExists)
                const Text('Subreddit already exists',
                    style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Expanded(
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
                    activeTrackColor: const Color.fromRGBO(0, 110, 199, 1),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color.fromRGBO(30, 30, 30, 1),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _isButtonEnabled() ? _createCommunity : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled()
                        ? const Color.fromRGBO(54, 143, 233, 1)
                        : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Create Community',
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          _isButtonEnabled() ? Colors.white : Colors.grey[400],
                    ),
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
                const Padding(
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
                  subtitle:
                      const Text('Anyone can view this community, but only '
                          'approved users can post.'),
                  onTap: () => _selectCommunityType('Restricted', context),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Private'),
                  subtitle:
                      const Text('Only approved users can view and submit '
                          'to this community.'),
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
        _communityNameController.text != "" &&
        subredditExists == false);
  }

  void _createCommunity() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final subredditName = _communityNameController.text.trim();
    final isNSFW = _is18Plus;
    final success = await networkService.createCommunity(subredditName, isNSFW);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubRedditPage(subredditName: subredditName)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create community'),
        ),
      );
    }
  }
}
