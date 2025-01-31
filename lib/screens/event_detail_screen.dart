import 'package:flutter/material.dart';
import '../constant/entities.dart';
import 'dart:io';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

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
              _buildInfoRow(Icons.calendar_today,
                  'Tarih: ${event.date.day}/${event.date.month}/${event.date.year}'),
              _buildInfoRow(Icons.access_time, 'Saat: ${event.time}'),
              _buildInfoRow(Icons.location_on, 'Konum: ${event.location}'),
              _buildInfoRow(Icons.phone, 'İletişim: ${event.contactPhone}'),
              _buildInfoRow(
                  Icons.business, 'Organizasyon: ${event.organizationInfo}'),
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
