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

  // Mevcut event filtreleme metodları aynı kalacak
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Bottom bar ile aynı renk
    final barColor = isDark
        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
        : Theme.of(context).colorScheme.primary.withOpacity(0.2);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              centerTitle: true,
              backgroundColor: barColor,
              title: Text(
                'Etkinlikler',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                indicatorColor: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Yaklaşan Etkinlikler',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
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
                                        Icon(
                                          Icons.event,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${event.title} (${event.time})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
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
        ? Center(
            child: Text(
              'Etkinlik bulunmamaktadır',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
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
    int participantCount =
        prefs.getInt('participantCount_${widget.event.id}') ?? 0;

    setState(() {
      _hasJoined = joined;
      _participantCount = participantCount;
    });
  }

  Future<void> _saveParticipationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('joined_${widget.event.id}', _hasJoined);
    await prefs.setInt(
        'participantCount_${widget.event.id}', _participantCount);
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
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              image: _buildImageDecoration(),
            ),
            child: widget.event.imageUrl.isEmpty
                ? Center(
                    child: Icon(
                      Icons.event,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Katılımcı Sayısı: $_participantCount',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _joinEvent,
                  icon: Icon(
                    _hasJoined ? Icons.check : Icons.person_add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    _hasJoined ? 'Katıldım' : 'Katıl',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
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
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
