import 'package:billing/services/meeting_db.dart';
import 'package:flutter/material.dart';

class MeetingReport extends StatefulWidget {
  const MeetingReport({super.key});

  @override
  State<MeetingReport> createState() => _MeetingReportState();
}

class _MeetingReportState extends State<MeetingReport> {
  final MeetingDb _dbHelper = MeetingDb();
  List<Map<String, dynamic>> _meetingList = [];
  List<Map<String, dynamic>> _filteredMeetingList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeetings();
    _searchController.addListener(_filterMeetings);
  }

  Future<void> _fetchMeetings() async {
    final data = await _dbHelper.getAllMeetings();
    setState(() {
      _meetingList = data;
      _filteredMeetingList = data; // Initialize filtered list with all meetings
    });
  }

  void _filterMeetings() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMeetingList = _meetingList.where((meeting) {
        final name = meeting['name'].toLowerCase();
        final mobile = meeting['mobile'].toLowerCase();
        return name.contains(query) || mobile.contains(query);
      }).toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredMeetingList = _meetingList; // Reset filtered list when search is stopped
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Black border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Black border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // Black border
                    ),
                  ),
                ),
              )
            : const Text(
                'Meeting Report',
                style: TextStyle(
                  fontSize: 20, // Adjust as needed
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (_isSearching) {
                _stopSearch();
              } else {
                _startSearch();
              }
            },
          ),
        ],
        bottom: _isSearching ? PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(),
        ) : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _filteredMeetingList.length,
          itemBuilder: (context, index) {
            final meeting = _filteredMeetingList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Row(
                      children: [
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            meeting['name'],
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Mobile
                    Row(
                      children: [
                        const Text(
                          'Mobile:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            meeting['mobile'],
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Business
                    Row(
                      children: [
                        const Text(
                          'Business:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            meeting['business'],
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Address
                    Row(
                      children: [
                        const Text(
                          'Address:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            meeting['location'],
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
