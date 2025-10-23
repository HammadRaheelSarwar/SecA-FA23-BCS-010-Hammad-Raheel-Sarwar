import 'package:flutter/material.dart';

void main() => runApp(const DoctorPatientRecordsApp());

class DoctorPatientRecordsApp extends StatefulWidget {
  const DoctorPatientRecordsApp({super.key});

  @override
  State<DoctorPatientRecordsApp> createState() =>
      _DoctorPatientRecordsAppState();
}

class _DoctorPatientRecordsAppState extends State<DoctorPatientRecordsApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool isLoggedIn = false;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void login() => setState(() => isLoggedIn = true);
  void logout() => setState(() => isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Patient Records',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? DashboardScreen(toggleTheme: toggleTheme, onLogout: logout)
          : LoginScreen(onLogin: login),
    );
  }
}

// ----------------------- LOGIN SCREEN -----------------------

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String error = '';

  void attemptLogin() {
    if (_formKey.currentState!.validate()) {
      if (usernameCtrl.text == "doctor" && passwordCtrl.text == "1234") {
        widget.onLogin();
      } else {
        setState(() => error = "Invalid username or password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_hospital,
                      size: 60, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text("Doctor Login",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(labelText: "Username"),
                    validator: (v) =>
                        v!.isEmpty ? "Enter username" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (v) =>
                        v!.isEmpty ? "Enter password" : null,
                  ),
                  const SizedBox(height: 12),
                  if (error.isNotEmpty)
                    Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: attemptLogin,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 50)),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------- DATA MODELS -----------------------

class Patient {
  String name;
  int age;
  String condition;
  String gender;
  String phone;
  DateTime nextVisit;

  Patient({
    required this.name,
    required this.age,
    required this.condition,
    required this.gender,
    required this.phone,
    required this.nextVisit,
  });
}

// ----------------------- DASHBOARD -----------------------

class DashboardScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback onLogout;
  const DashboardScreen(
      {super.key, required this.toggleTheme, required this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Patient> patients = [
    Patient(
      name: 'John Doe',
      age: 45,
      condition: 'Diabetes',
      gender: 'Male',
      phone: '555-1234',
      nextVisit: DateTime.now().add(const Duration(days: 3)),
    ),
    Patient(
      name: 'Jane Smith',
      age: 37,
      condition: 'Hypertension',
      gender: 'Female',
      phone: '555-9876',
      nextVisit: DateTime.now().add(const Duration(days: 7)),
    ),
  ];

  String doctorName = 'Dr. Alex Johnson';

  int get upcomingVisits =>
      patients.where((p) => p.nextVisit.isAfter(DateTime.now())).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: widget.onLogout,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorSettingsScreen(
                    doctorName: doctorName,
                    onThemeToggle: widget.toggleTheme,
                    onSave: (newName) {
                      setState(() => doctorName = newName);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Welcome, $doctorName 👋",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDashboardCard(
                  context, "Total Patients", patients.length.toString(),
                  icon: Icons.people),
              _buildDashboardCard(
                  context, "Upcoming Visits", upcomingVisits.toString(),
                  icon: Icons.calendar_month),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text("Manage Patients"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        PatientListScreen(patients: patients, onUpdate: () {
                          setState(() {});
                        })),
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.add_circle),
            label: const Text("Add New Patient"),
            onPressed: () async {
              final newPatient = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPatientScreen()),
              );
              if (newPatient != null) {
                setState(() => patients.add(newPatient));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, String value,
      {required IconData icon}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ----------------------- PATIENT LIST -----------------------

class PatientListScreen extends StatefulWidget {
  final List<Patient> patients;
  final VoidCallback onUpdate;
  const PatientListScreen(
      {super.key, required this.patients, required this.onUpdate});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.patients
        .where((p) =>
            p.name.toLowerCase().contains(search.toLowerCase()) ||
            p.condition.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Patient Records")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search patient'),
              onChanged: (val) => setState(() => search = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final p = filtered[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(p.name[0]),
                  ),
                  title: Text(p.name),
                  subtitle: Text("${p.condition} • ${p.gender}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.patients.remove(p);
                        widget.onUpdate();
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientDetailScreen(patient: p),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------- PATIENT DETAIL -----------------------

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;
  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _info("Name", patient.name),
            _info("Age", "${patient.age}"),
            _info("Gender", patient.gender),
            _info("Condition", patient.condition),
            _info("Phone", patient.phone),
            _info("Next Visit",
                "${patient.nextVisit.day}/${patient.nextVisit.month}/${patient.nextVisit.year}"),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text("$title:")),
            Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
}

// ----------------------- ADD PATIENT -----------------------

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final condCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String gender = 'Male';
  DateTime nextVisit = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Patient")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Age"),
                validator: (v) => v!.isEmpty ? "Enter age" : null,
              ),
              TextFormField(
                controller: condCtrl,
                decoration: const InputDecoration(labelText: "Condition"),
              ),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: "Gender"),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (val) => setState(() => gender = val!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                      "Next Visit: ${nextVisit.day}/${nextVisit.month}/${nextVisit.year}"),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: nextVisit,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) setState(() => nextVisit = date);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final p = Patient(
                      name: nameCtrl.text,
                      age: int.parse(ageCtrl.text),
                      condition: condCtrl.text,
                      gender: gender,
                      phone: phoneCtrl.text,
                      nextVisit: nextVisit,
                    );
                    Navigator.pop(context, p);
                  }
                },
                child: const Text("Save Patient"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- DOCTOR SETTINGS -----------------------

class DoctorSettingsScreen extends StatefulWidget {
  final String doctorName;
  final VoidCallback onThemeToggle;
  final Function(String) onSave;

  const DoctorSettingsScreen(
      {super.key,
      required this.doctorName,
      required this.onThemeToggle,
      required this.onSave});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.doctorName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Doctor Name"),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              onPressed: () {
                widget.onSave(_nameCtrl.text);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.dark_mode),
              label: const Text("Toggle Theme"),
              onPressed: widget.onThemeToggle,
            ),
          ],
        ),
      ),
    );
  }
}
