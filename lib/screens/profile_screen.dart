import 'package:flutter/material.dart';
import 'package:linkup/screens/login_screen.dart';
import '../constant/entities.dart';
import '../services/badge_service.dart';
import '../services/event_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final BadgeService _badgeService = BadgeService();
  final EventService _eventService = EventService();

  // Temsili veriler
  final Map<String, dynamic> _userData = {
    'name': 'Kullanıcı Adı',
    'email': 'kullanici@email.com',
    'phone': '5XX XXX XX XX',
    'joinedEvents': 12,
    'createdEvents': 5,
  };

  // Temsili geçmiş etkinlikler
  final List<Event> _pastEvents = [
    Event(
      id: '1',
      title: 'Çocuk Hakları Konferansı',
      description: 'Çocuk hakları üzerine farkındalık konferansı',
      date: DateTime.now().subtract(const Duration(days: 5)),
      time: '14:00',
      location: 'Ankara',
      category: 'Çocuk Hakları',
      imageUrl: '',
      organizerId: 'org1',
      createdAt: DateTime.now(),
      contactPhone: '555-0001',
      organizationInfo: 'UNICEF Türkiye',
    ),
    Event(
      id: '2',
      title: 'Kadın Hakları Paneli',
      description: 'Kadın hakları ve eşitlik paneli',
      date: DateTime.now().subtract(const Duration(days: 10)),
      time: '15:30',
      location: 'İstanbul',
      category: 'Kadın Hakları',
      imageUrl: '',
      organizerId: 'org2',
      createdAt: DateTime.now(),
      contactPhone: '555-0002',
      organizationInfo: 'UN Women',
    ),
    // ... diğer geçmiş etkinlikler
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_userData['name']),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatsCard(),
                _buildBadgesSection(),
                _buildProfileSection(),
                _buildPastEventsSection(),
                _buildSettingsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Katıldığı\nEtkinlikler', _userData['joinedEvents']),
            _buildStatItem(
                'Oluşturduğu\nEtkinlikler', _userData['createdEvents']),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    final badges = _badgeService.getUserBadges("current_user_id");

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.military_tech, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Rozetlerim',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${badges.length} / ${_badgeService.getAllBadges().length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (badges.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Henüz rozet kazanılmadı.\nEtkinliklere katılarak rozetler kazanabilirsiniz!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            Text(
                              badge.icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(badge.name)),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(badge.description),
                            const SizedBox(height: 8),
                            Text(
                              'Kategori: ${badge.category}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).primaryColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            badge.icon,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            badge.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Profil Bilgileri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(_userData['name']),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // TODO: İsim düzenleme
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(_userData['email']),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // TODO: Email düzenleme
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(_userData['phone']),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // TODO: Telefon düzenleme
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPastEventsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Katıldığım Etkinlikler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_pastEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Henüz bir etkinliğe katılmadınız.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pastEvents.length,
              itemBuilder: (context, index) {
                final event = _pastEvents[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      event.category.substring(0, 1),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  title: Text(event.title),
                  subtitle: Text(
                    '${event.date.day}/${event.date.month}/${event.date.year} - ${event.location}',
                  ),
                  trailing: Icon(
                    Icons.verified,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Ayarlar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirimler'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Bildirim ayarları
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Tema değiştirme
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Dil'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Dil seçimi
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Çıkış Yap',
                        style: TextStyle(
                            color: Color(0xFF2F3E46),
                            fontWeight: FontWeight.w500)),
                    content: Text(
                        'Çıkış yapmak üzeresiniz. Çıkmak istediğinize emin misiniz?',
                        style: TextStyle(
                            color: Color(0xFF2F3E46),
                            fontWeight: FontWeight.w300)),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('İptal',
                            style: TextStyle(
                                color: Color(0xFF2F3E46),
                                fontWeight: FontWeight.w300)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF84A98C)),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          'Evet',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}