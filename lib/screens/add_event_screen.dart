import 'package:flutter/material.dart';

import '../animated/animated_dropdown.dart';
import '../animated/animated_text_field.dart';
import '../constant/form_constant.dart';
import '../widgets/data_selector.dart';
import '../constant/entities.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  String? _eventName;
  String? _eventType;
  String? _description;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _location;
  String? _contactPhone;
  String? _organizationInfo;

  static const formSections = [
    {
      'title': 'Etkinlik Bilgileri',
      'description': 'Etkinlik hakkında temel bilgileri girin.',
      'icon': Icons.title,
    },
    {
      'title': 'Tarih Bilgileri',
      'description': 'Etkinlik tarihlerini girin.',
      'icon': Icons.date_range,
    },
    {
      'title': 'Konum Bilgileri',
      'description': 'Etkinlik konumunu girin.',
      'icon': Icons.location_on,
    },
    {
      'title': 'İletişim Bilgileri',
      'description': 'Organizasyon ve iletişim detaylarını girin.',
      'icon': Icons.contact_phone,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(formSections[_currentStep]['title'] as String),
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
                child: Icon(
                  formSections[_currentStep]['icon'] as IconData?,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                children: [
                  _buildProgressBar(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      formSections[_currentStep]['description'] as String,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() => _currentStep = index);
                      },
                      children: [
                        _buildBasicInfoSection(),
                        _buildDateTimeSection(),
                        _buildLocationSection(),
                        _buildAdditionalSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(
        formSections.length,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            color: _currentStep >= index
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              ElevatedButton.icon(
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Geri'),
              ),
            if (_currentStep < formSections.length - 1)
              ElevatedButton.icon(
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('İleri'),
              ),
            if (_currentStep == formSections.length - 1)
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.check),
                label: const Text('Tamamla'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedTextField(
            label: "Etkinlik Adı",
            icon: Icons.title,
            onSaved: (value) => _eventName = value,
            validator: (value) =>
                value == null || value.isEmpty ? "Bu alan zorunludur." : null,
          ),
          const SizedBox(height: 16),
          AnimatedDropdown(
            label: "Etkinlik Türü",
            icon: Icons.category,
            items: FormConstants.eventTypes,
            onChanged: (value) => _eventType = value,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DateSelector(
            label: "Başlangıç Tarihi",
            initialDate: _startDate,
            onDateSelected: (date) => setState(() => _startDate = date),
          ),
          const SizedBox(height: 16),
          DateSelector(
            label: "Bitiş Tarihi",
            initialDate: _endDate,
            onDateSelected: (date) => setState(() => _endDate = date),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedTextField(
            label: "Konum",
            icon: Icons.location_on,
            onSaved: (value) => _location = value,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AnimatedTextField(
            label: "Ek Bilgiler",
            icon: Icons.note,
            maxLines: 4,
            onSaved: (value) => _description = value,
          ),
          const SizedBox(height: 16),
          AnimatedTextField(
            label: "İletişim Telefonu",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onSaved: (value) => _contactPhone = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Telefon numarası gereklidir";
              }
              if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                return "Geçerli bir telefon numarası giriniz";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AnimatedTextField(
            label: "Organizasyon Bilgileri",
            icon: Icons.business,
            maxLines: 3,
            onSaved: (value) => _organizationInfo = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Organizasyon bilgileri gereklidir";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final event = Event(
        id: DateTime.now().toString(),
        title: _eventName!,
        description: _description!,
        date: _startDate!,
        time: "10:00",
        location: _location!,
        category: _eventType!,
        imageUrl: "",
        organizerId: "current_user_id",
        createdAt: DateTime.now(),
        contactPhone: _contactPhone!,
        organizationInfo: _organizationInfo!,
      );

      // Event nesnesini kaydetme işlemleri burada yapılacak

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etkinlik başarıyla oluşturuldu!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
