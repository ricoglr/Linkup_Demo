import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/entities.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final bool hasJoined;
  final int participantCount;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.hasJoined,
    required this.participantCount,
  });

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late bool _hasJoined;
  late int _participantCount;
  TextEditingController _commentController = TextEditingController();
  List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    _hasJoined = widget.hasJoined;
    _participantCount = widget.participantCount;
  }

  Future<void> _joinEvent() async {
    setState(() {
      if (_hasJoined) {
        _participantCount -= 1;
        _hasJoined = false;
      } else {
        _participantCount += 1;
        _hasJoined = true;
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('joined_${widget.event.id}', _hasJoined);
    await prefs.setInt(
        'participantCount_${widget.event.id}', _participantCount);
  }

  @override
  void dispose() {
    // Ekrandan çıkarken güncellenmiş veriyi geri döndür
    Navigator.pop(context, {
      'hasJoined': _hasJoined,
      'participantCount': _participantCount,
    });
    super.dispose();
  }

  void _addComment(String comment) {
    if (comment.isNotEmpty) {
      setState(() {
        _comments.insert(0, comment); // Yeni yorum başa ekleniyor
      });
      _commentController.clear(); // Yorum kutusunu temizle
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar - Resmin küçülmesi ve kaybolması
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double opacity = 1 - (constraints.maxHeight / 250);
                return FlexibleSpaceBar(
                  background: widget.event.imageUrl.isEmpty
                      ? Container(
                          color: Theme.of(context).colorScheme.primary,
                          width: double.infinity,
                          height: 250,
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : ClipRRect(
                          child: Image.network(
                            widget.event.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                  title: Text(
                    widget.event.title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(opacity),
                    ),
                  ),
                  centerTitle: true,
                );
              },
            ),
          ),
          // 2. Diğer içerikler
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.event.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.calendar_today,
                          'Tarih: ${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year}'),
                      _buildInfoRow(
                          Icons.access_time, 'Saat: ${widget.event.time}'),
                      _buildInfoRow(
                          Icons.location_on, 'Konum: ${widget.event.location}'),
                      _buildInfoRow(Icons.phone,
                          'İletişim: ${widget.event.contactPhone}'),
                      _buildInfoRow(Icons.business,
                          'Organizasyon: ${widget.event.organizationInfo}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _joinEvent();
                            },
                            icon: Icon(
                              _hasJoined ? Icons.check : Icons.person_add,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            label: Text(
                              _hasJoined ? 'Katıldım' : 'Katıl',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "$_participantCount kişi katıldı",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Yorum yazma kutusu
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: "Yorum yap...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                _addComment(_commentController.text);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(),
                      const SizedBox(height: 16),
                      // Yorumlar başlığı ve toplam yorum sayısı
                      Text(
                        "Yorumlar (${_comments.length})",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      // Yorumlar
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          String comment = _comments[index];
                          String userName =
                              "Kullanıcı Adı"; // Gerçek kullanıcı adı buraya gelecek
                          String time = DateTime.now()
                              .toLocal()
                              .toString(); // Gerçek zaman burada kullanılacak
                          return Column(
                            children: [
                              // Yorumun içeriği
                              Container(
                                padding: EdgeInsets.all(12),
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            time,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            comment,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.thumb_up,
                                            size: 15,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.thumb_down,
                                            size: 15,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            size: 15,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 15,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(), // Yorumları ayıran divider
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
