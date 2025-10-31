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

  String? registeredUsername;
  String? registeredPassword;
  String? loggedInUser;
  final List<Patient> patients = [];

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void registerDoctor(String username, String password) {
    setState(() {
      registeredUsername = username;
      registeredPassword = password;
    });
  }

  bool login(String username, String password) {
    if (username == registeredUsername && password == registeredPassword) {
      setState(() => loggedInUser = username);
      return true;
    }
    return false;
  }

  void logout() => setState(() => loggedInUser = null);

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
      home: loggedInUser == null
          ? LoginScreen(
              onLogin: login,
              onRegister: registerDoctor,
              isRegistered: registeredUsername != null,
            )
          : DashboardScreen(
              doctorName: loggedInUser!,
              patients: patients,
              toggleTheme: toggleTheme,
              onLogout: logout,
            ),
    );
  }
}

// ----------------------- LOGIN SCREEN -----------------------

class LoginScreen extends StatefulWidget {
  final bool Function(String, String) onLogin;
  final Function(String, String) onRegister;
  final bool isRegistered;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.isRegistered,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String error = '';
  bool isRegisterMode = false;

  void attemptAuth() {
    if (_formKey.currentState!.validate()) {
      if (isRegisterMode) {
        widget.onRegister(usernameCtrl.text, passwordCtrl.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful! Please login.')),
        );
        setState(() => isRegisterMode = false);
      } else {
        final success = widget.onLogin(usernameCtrl.text, passwordCtrl.text);
        if (!success) {
          setState(() => error = "Invalid username or password");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final modeText = isRegisterMode ? "Register" : "Login";
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
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
                  Text("$modeText Page",
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(labelText: "Username"),
                    validator: (v) => v!.isEmpty ? "Enter username" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordCtrl,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? "Enter password" : null,
                  ),
                  const SizedBox(height: 12),
                  if (error.isNotEmpty)
                    Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: attemptAuth,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(180, 50)),
                    child: Text(modeText),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      if (widget.isRegistered || isRegisterMode) {
                        setState(() => isRegisterMode = !isRegisterMode);
                      } else {
                        setState(() => isRegisterMode = true);
                      }
                    },
                    child: Text(isRegisterMode
                        ? "Already have an account? Login"
                        : "Create new account"),
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

// ----------------------- PATIENT MODEL -----------------------

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
  final String doctorName;
  final List<Patient> patients;
  final VoidCallback toggleTheme;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.doctorName,
    required this.patients,
    required this.toggleTheme,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int get upcomingVisits =>
      widget.patients.where((p) => p.nextVisit.isAfter(DateTime.now())).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        actions: [
          IconButton(
              onPressed: widget.toggleTheme,
              icon: const Icon(Icons.dark_mode)),
          IconButton(onPressed: widget.onLogout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Welcome, Dr. ${widget.doctorName} 👋",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCard(context, "Patients",
                  widget.patients.length.toString(), Icons.people),
              _buildCard(context, "Upcoming",
                  upcomingVisits.toString(), Icons.calendar_month),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Patient"),
            onPressed: () async {
              final newPatient = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPatientScreen()),
              );
              if (newPatient != null) {
                setState(() => widget.patients.add(newPatient));
              }
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text("View All Patients"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientListScreen(
                    patients: widget.patients,
                    onDelete: (p) {
                      setState(() => widget.patients.remove(p));
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ----------------------- PATIENT LIST -----------------------

class PatientListScreen extends StatelessWidget {
  final List<Patient> patients;
  final Function(Patient) onDelete;

  const PatientListScreen({super.key, required this.patients, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patients")),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (_, i) {
          final p = patients[i];
          return ListTile(
            leading: CircleAvatar(child: Text(p.name[0])),
            title: Text(p.name),
            subtitle: Text("${p.condition} • ${p.gender}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(p),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PatientDetailScreen(patient: p)),
            ),
          );
        },
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
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text("$title:")),
            Expanded(
                child:
                    Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
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
