import 'package:flutter/material.dart';
import 'dart:io';
import '../constant/entities.dart';
import '../services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
    _eventService.addListener(_loadEvents);
  }

  @override
  void dispose() {
    _eventService.removeListener(_loadEvents);
    _tabController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    setState(() {
      _events = List.from(_eventService.events)
        ..sort((a, b) => a.date.compareTo(b.date));
    });
  }

  List<Event> get _todayEvents {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _events.where((event) {
      final eventDateTime = _combineDateTime(event.date, event.time);
      return (event.date.isAfter(today) && event.date.isBefore(tomorrow)) ||
          (eventDateTime.isAfter(now) &&
              eventDateTime.isBefore(now.add(const Duration(hours: 3))));
    }).toList()
      ..sort((a, b) => _combineDateTime(a.date, a.time)
          .compareTo(_combineDateTime(b.date, b.time)));
  }

  List<Event> get _thisWeekEvents {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekEnd = today.add(const Duration(days: 7));

    return _events.where((event) {
      return event.date.isAfter(today) && event.date.isBefore(weekEnd);
    }).toList();
  }

  List<Event> get _allEvents {
    final now = DateTime.now();
    return _events.where((event) {
      final eventDateTime = _combineDateTime(event.date, event.time);
      return eventDateTime.isAfter(now);
    }).toList()
      ..sort((a, b) => _combineDateTime(a.date, a.time)
          .compareTo(_combineDateTime(b.date, b.time)));
  }

  List<Event> get _nextThreeHoursEvents {
    final now = DateTime.now();
    final threeHoursLater = now.add(const Duration(hours: 3));

    return _events.where((event) {
      final eventDateTime = _combineDateTime(event.date, event.time);
      return eventDateTime.isAfter(now) &&
          eventDateTime.isBefore(threeHoursLater);
    }).toList()
      ..sort((a, b) => _combineDateTime(a.date, a.time)
          .compareTo(_combineDateTime(b.date, b.time)));
  }

  DateTime _combineDateTime(DateTime date, String timeStr) {
    final timeParts = timeStr.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              title: const Text('Etkinlikler'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Bugün'),
                  Tab(text: 'Bu Hafta'),
                  Tab(text: 'Tümü'),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            if (_nextThreeHoursEvents.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.access_time, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Yaklaşan Etkinlikler',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _nextThreeHoursEvents
                            .map((event) => Card(
                          margin: const EdgeInsets.only(right: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(Icons.event,
                                    color:
                                    Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  '${event.title} (${event.time})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEventList(_todayEvents),
                  _buildEventList(_thisWeekEvents),
                  _buildEventList(_allEvents),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    return events.isEmpty
        ? const Center(child: Text('Etkinlik bulunmamaktadır'))
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }
}

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int _participantCount = 0;
  bool _hasJoined = false;

  @override
  void initState() {
    super.initState();
    _loadParticipationStatus();
  }

  Future<void> _loadParticipationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool joined = prefs.getBool('joined_${widget.event.id}') ?? false;
    int participantCount = prefs.getInt('participantCount_${widget.event.id}') ?? 0;

    setState(() {
      _hasJoined = joined;
      _participantCount = participantCount;
    });
  }

  Future<void> _saveParticipationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('joined_${widget.event.id}', _hasJoined);
    await prefs.setInt('participantCount_${widget.event.id}', _participantCount);
  }

  void _joinEvent() {
    setState(() {
      if (_hasJoined) {
        _participantCount -= 1;
        _hasJoined = false;
      } else {
        _participantCount += 1;
        _hasJoined = true;
      }
    });

    _saveParticipationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: _buildImageDecoration(),
            ),
            child: widget.event.imageUrl.isEmpty
                ? Center(
              child: Icon(
                Icons.event,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.category, widget.event.category),
                _buildInfoRow(
                  Icons.calendar_today,
                  '${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year}',
                ),
                _buildInfoRow(Icons.location_on, widget.event.location),
                _buildInfoRow(Icons.phone, widget.event.contactPhone),
                const SizedBox(height: 8),
                Text(
                  widget.event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Katılımcı Sayısı: $_participantCount',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _joinEvent,
                  icon: Icon(_hasJoined ? Icons.check : Icons.person_add),
                  label: Text(_hasJoined ? 'Katıldım' : 'Katıl'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfasi(event: widget.event),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Detay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage? _buildImageDecoration() {
    if (widget.event.imageUrl.isEmpty) return null;

    try {
      return DecorationImage(
        image: FileImage(File(widget.event.imageUrl)),
        fit: BoxFit.cover,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class DetaySayfasi extends StatelessWidget {
  final Event event;

  const DetaySayfasi({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etkinlik resmi
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: _buildImageDecoration(),
                ),
                child: event.imageUrl.isEmpty
                    ? Center(
                  child: Icon(
                    Icons.event,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                )
                    : null,
              ),
              const SizedBox(height: 16),
              // Etkinlik başlığı
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Etkinlik açıklaması
              Text(
                event.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Etkinlik bilgileri
              _buildInfoRow(Icons.calendar_today, 'Tarih: ${event.date.day}/${event.date.month}/${event.date.year}'),
              _buildInfoRow(Icons.access_time, 'Saat: ${event.time}'),
              _buildInfoRow(Icons.location_on, 'Konum: ${event.location}'),
              _buildInfoRow(Icons.phone, 'İletişim: ${event.contactPhone}'),
              _buildInfoRow(Icons.business, 'Organizasyon: ${event.organizationInfo}'),
              const SizedBox(height: 16),
              // Katılımcı
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage? _buildImageDecoration() {
    if (event.imageUrl.isEmpty) return null;

    try {
      return DecorationImage(
        image: FileImage(File(event.imageUrl)),
        fit: BoxFit.cover,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}