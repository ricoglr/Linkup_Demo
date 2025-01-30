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

  // Temsili veriler aynı kalacak
  final Map<String, dynamic> _userData = {
    'name': 'Kullanıcı Adı',
    'email': 'kullanici@email.com',
    'phone': '5XX XXX XX XX',
    'joinedEvents': 12,
    'createdEvents': 5,
  };

  // Temsili geçmiş etkinlikler aynı kalacak
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
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_userData['name'],
                  style: textTheme.titleLarge
                      ?.copyWith(color: colorScheme.onPrimary)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: colorScheme.onPrimary.withOpacity(0.24),
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value.toString(),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    final badges = _badgeService.getUserBadges("current_user_id");
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.military_tech, size: 24, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Rozetlerim',
                  style: textTheme.titleLarge,
                ),
                const Spacer(),
                Text(
                  '${badges.length} / ${_badgeService.getAllBadges().length}',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (badges.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Henüz rozet kazanılmadı.\nEtkinliklere katılarak rozetler kazanabilirsiniz!',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
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
                              style: textTheme.headlineSmall,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                badge.name,
                                style: textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.description,
                              style: textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kategori: ${badge.category}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Tamam',
                              style: TextStyle(color: colorScheme.primary),
                            ),
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
                          colorScheme.primary.withOpacity(0.1),
                          colorScheme.primary.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            badge.icon,
                            style: textTheme.headlineMedium,
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
                            style: textTheme.labelSmall?.copyWith(
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Profil Bilgileri',
              style: textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: colorScheme.primary),
            title: Text(_userData['name'], style: textTheme.bodyLarge),
            trailing: Icon(Icons.edit, color: colorScheme.primary),
            onTap: () {
              // TODO: İsim düzenleme
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: colorScheme.primary),
            title: Text(_userData['email'], style: textTheme.bodyLarge),
            trailing: Icon(Icons.edit, color: colorScheme.primary),
            onTap: () {
              // TODO: Email düzenleme
            },
          ),
          ListTile(
            leading: Icon(Icons.phone, color: colorScheme.primary),
            title: Text(_userData['phone'], style: textTheme.bodyLarge),
            trailing: Icon(Icons.edit, color: colorScheme.primary),
            onTap: () {
              // TODO: Telefon düzenleme
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPastEventsSection() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Katıldığım Etkinlikler',
              style: textTheme.titleLarge,
            ),
          ),
          if (_pastEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Henüz bir etkinliğe katılmadınız.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
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
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      event.category.substring(0, 1),
                      style: TextStyle(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  title: Text(event.title, style: textTheme.bodyLarge),
                  subtitle: Text(
                    '${event.date.day}/${event.date.month}/${event.date.year} - ${event.location}',
                    style: textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.verified,
                    color: colorScheme.primary,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Ayarlar',
              style: textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: colorScheme.primary),
            title: Text('Bildirimler', style: textTheme.bodyLarge),
            trailing: Switch(
              value: true,
              activeColor: colorScheme.primary,
              onChanged: (value) {
                // TODO: Bildirim ayarları
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: colorScheme.primary),
            title: Text('Karanlık Mod', style: textTheme.bodyLarge),
            trailing: Switch(
              value: false, // Tema durumu
              activeColor: colorScheme.primary,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.language, color: colorScheme.primary),
            title: Text('Dil', style: textTheme.bodyLarge),
            trailing: Icon(Icons.arrow_forward_ios, color: colorScheme.primary),
            onTap: () {
              // TODO: Dil seçimi
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              'Çıkış Yap',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.error,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Çıkış Yap',
                      style: textTheme.titleLarge,
                    ),
                    content: Text(
                      'Çıkış yapmak üzeresiniz. Çıkmak istediğinize emin misiniz?',
                      style: textTheme.bodyMedium,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'İptal',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          'Evet',
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ),
                    ],
                    backgroundColor: colorScheme.surface,
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
