import 'package:flutter/material.dart';

class FormConstants {
  static const List<Map<String, dynamic>> formSections = [
    {
      'title': 'Temel Bilgiler',
      'icon': Icons.event_note,
      'description': 'Etkinliğinizin temel bilgilerini girin',
    },
    {
      'title': 'Tarih ve Zaman',
      'icon': Icons.calendar_today,
      'description': 'Etkinlik tarih ve zamanını belirleyin',
    },
    {
      'title': 'Konum ve Katılım',
      'icon': Icons.location_on,
      'description': 'Konum ve katılım detaylarını belirtin',
    },
    {
      'title': 'Ek Özellikler',
      'icon': Icons.extension,
      'description': 'Ek özellikleri yapılandırın',
    },
  ];

  static const List<String> eventTypes = [
    "Konferans",
    "Seminer",
    "Protesto",
    "Bağış Kampanyası"
  ];

  static const List<String> participationTypes = [
    "Fiziksel",
    "Sanal",
    "Fiziksel ve Sanal"
  ];
}
