import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

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
  bool _isRecurring = false;
  bool _sendNotifications = false;
  String? _location;
  String? _participationType;
  bool _isFree = true;
  double? _ticketPrice;
  String? _organizerName;
  String? _contactInfo;
  int? _maxParticipants;
  String? _language;
  bool _allowComments = false;

  final List<Map<String, dynamic>> _formSections = [
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
              title: Text(_formSections[_currentStep]['title']),
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
                  _formSections[_currentStep]['icon'],
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: List.generate(
                        _formSections.length,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _formSections[_currentStep]['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton.icon(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Geri'),
                ),
              if (_currentStep < _formSections.length - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('İleri'),
                ),
              if (_currentStep == _formSections.length - 1)
                ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check),
                  label: const Text('Tamamla'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAnimatedTextField(
            "Etkinlik Adı",
            Icons.title,
            onSaved: (value) => _eventName = value,
            validator: (value) =>
                value == null || value.isEmpty ? "Bu alan zorunludur." : null,
          ),
          const SizedBox(height: 16),
          _buildAnimatedDropdown(
            "Etkinlik Türü",
            Icons.category,
            ["Konferans", "Seminer", "Protesto", "Bağış Kampanyası"],
            (value) => _eventType = value,
          ),
          const SizedBox(height: 16),
          _buildAnimatedTextField(
            "Açıklama",
            Icons.description,
            maxLines: 4,
            onSaved: (value) => _description = value,
          ),
        ],
      ),
    );
  }

  // Modern DateTime Section
  Widget _buildDateTimeSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAnimatedTextField(
            "Başlangıç Tarihi",
            Icons.calendar_today,
            onSaved: (value) => _startDate = DateTime.parse(value!),
            validator: (value) =>
                value == null || value.isEmpty ? "Bu alan zorunludur." : null,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 20),
          _buildAnimatedTextField(
            "Bitiş Tarihi",
            Icons.calendar_today,
            onSaved: (value) => _endDate = DateTime.parse(value!),
            validator: (value) =>
                value == null || value.isEmpty ? "Bu alan zorunludur." : null,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: CheckboxListTile(
              title: Text("Tekrar Eden Etkinlik"),
              value: _isRecurring,
              onChanged: (value) => setState(() => _isRecurring = value!),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: CheckboxListTile(
              title: Text("Bildirim Gönder"),
              value: _sendNotifications,
              onChanged: (value) => setState(() => _sendNotifications = value!),
            ),
          ),
        ],
      ),
    );
  }

  // Date Selector Widget
  Widget _buildDateSelector({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blueAccent),
            SizedBox(width: 16),
            Text(
              selectedDate == null
                  ? "$label Seç"
                  : "${label}: ${_formatDate(selectedDate)}",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

// Helper function to format date
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildLocationSection() {
    // Konum kısmını buraya entegre edebilirsiniz.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _buildAnimatedTextField(
          "Adres",
          Icons.location_on,
          onSaved: (value) => _location = value,
        ),
        const SizedBox(height: 16),
        _buildAnimatedDropdown(
          "Katılım Türü",
          Icons.people,
          ["Fiziksel", "Sanal", "Fiziksel ve Sanal"],
          (value) => _participationType = value,
        ),
        const SizedBox(height: 16),
        _buildAnimatedTextField(
          "Organizatör Adı",
          Icons.person,
          onSaved: (value) => _organizerName = value,
        ),
        const SizedBox(height: 16),
        _buildAnimatedTextField(
          "İletişim Bilgisi",
          Icons.phone,
          onSaved: (value) => _contactInfo = value,
        ),
      ]),
    );
  }

  Widget _buildAdditionalSection() {
    // Ek özellikler kısmını buraya entegre edebilirsiniz.
    return Container();
  }

  Widget _buildAnimatedTextField(
    String label,
    IconData icon, {
    int maxLines = 1,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: Icon(icon),
                  border: InputBorder.none,
                ),
                maxLines: maxLines,
                onSaved: onSaved,
                validator: validator,
                keyboardType: keyboardType,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDropdown(String label, IconData icon, List<String> items,
      Function(String?) onChanged) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
          ),
          items: items
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Form işleme kodları...
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etkinlik başarıyla oluşturuldu!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
