// main.dart
import 'dart:convert';
import 'dart:math' show pow, log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const BMIApp());
}

enum Gender { male, female, other }

enum ActivityLevel { sedentary, lightlyActive, active, veryActive }

enum Goal { lose, maintain, gain }

class UserProfile {
  String name;
  Gender gender;
  double currentWeight;
  double goalWeight;
  Goal goal;
  DateTime createdAt;

  UserProfile({
    required this.name,
    required this.gender,
    required this.currentWeight,
    required this.goalWeight,
    required this.goal,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender.toString(),
    'currentWeight': currentWeight,
    'goalWeight': goalWeight,
    'goal': goal.toString(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String,
    gender: Gender.values.firstWhere(
      (e) => e.toString() == json['gender'],
      orElse: () => Gender.male,
    ),
    currentWeight: (json['currentWeight'] as num).toDouble(),
    goalWeight: (json['goalWeight'] as num).toDouble(),
    goal: Goal.values.firstWhere(
      (e) => e.toString() == json['goal'],
      orElse: () => Goal.maintain,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class BmiEntry {
  final double bmi;
  final double weightKg;
  final double heightCm;
  final double? bodyFatPercent;
  final double? muscleMass;
  final double? whtrRatio;
  final double? waistCm;
  final DateTime date;

  BmiEntry({
    required this.bmi,
    required this.weightKg,
    required this.heightCm,
    this.bodyFatPercent,
    this.muscleMass,
    this.whtrRatio,
    this.waistCm,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'bmi': bmi,
    'weightKg': weightKg,
    'heightCm': heightCm,
    'bodyFatPercent': bodyFatPercent,
    'muscleMass': muscleMass,
    'whtrRatio': whtrRatio,
    'waistCm': waistCm,
    'date': date.toIso8601String(),
  };

  factory BmiEntry.fromJson(Map<String, dynamic> json) => BmiEntry(
    bmi: (json['bmi'] as num).toDouble(),
    weightKg: (json['weightKg'] as num).toDouble(),
    heightCm: (json['heightCm'] as num).toDouble(),
    bodyFatPercent: json['bodyFatPercent'] != null
        ? (json['bodyFatPercent'] as num).toDouble()
        : null,
    muscleMass: json['muscleMass'] != null
        ? (json['muscleMass'] as num).toDouble()
        : null,
    whtrRatio: json['whtrRatio'] != null
        ? (json['whtrRatio'] as num).toDouble()
        : null,
    waistCm: json['waistCm'] != null
        ? (json['waistCm'] as num).toDouble()
        : null,
    date: DateTime.parse(json['date'] as String),
  );
}

// ───────────────────────────── APP ROOT WITH THEME TOGGLE ──────────────────────

class BMIApp extends StatefulWidget {
  const BMIApp({super.key});

  @override
  State<BMIApp> createState() => _BMIAppState();
}

class _BMIAppState extends State<BMIApp> {
  bool _isDark = false;
  bool _isAmoled = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  void _toggleAmoled() {
    setState(() {
      _isAmoled = !_isAmoled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _isAmoled ? Colors.black : null,
      ),
      home: BMIHomePage(
        isDark: _isDark,
        isAmoled: _isAmoled,
        onToggleTheme: _toggleTheme,
        onToggleAmoled: _toggleAmoled,
      ),
    );
  }
}

// ───────────────────────────── HOME PAGE ───────────────────────────────────────

class BMIHomePage extends StatefulWidget {
  final bool isDark;
  final bool isAmoled;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleAmoled;

  const BMIHomePage({
    super.key,
    required this.isDark,
    required this.isAmoled,
    required this.onToggleTheme,
    required this.onToggleAmoled,
  });

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  // Inputs
  Gender _gender = Gender.male;
  ActivityLevel _activityLevel = ActivityLevel.sedentary;
  Goal _goal = Goal.maintain;

  int _age = 25;
  double _height = 170; // value in current unit
  double _weight = 70; // value in current unit
  double _waist = 80; // waist circumference in cm
  bool _isCm = true; // true: cm, false: ft
  bool _isKg = true; // true: kg, false: lbs

  // Results
  double? _bmi;
  String _category = '';
  String _tip = '';
  double? _idealMin;
  double? _idealMax;
  double? _calMaintain;
  double? _calLose;
  double? _calGain;
  double? _bodyFatPercent;
  double? _muscleMass;
  double? _whtrRatio;
  double? _proteinGrams;
  double? _carbsGrams;
  double? _fatsGrams;

  // User Profile
  UserProfile? _userProfile;
  bool _showProfilePage = false;

  // Water tracking
  int _waterGlasses = 0;
  final int _waterGoal = 8;

  // History
  List<BmiEntry> _history = [];

  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('user_profile');
    if (profileJson != null) {
      setState(() {
        _userProfile = UserProfile.fromJson(
          jsonDecode(profileJson) as Map<String, dynamic>,
        );
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (_userProfile != null) {
      await prefs.setString('user_profile', jsonEncode(_userProfile!.toJson()));
    }
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('bmi_history') ?? [];
    setState(() {
      _history = list
          .map((e) => BmiEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
      _isLoadingHistory = false;
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _history
        .map((e) => jsonEncode(e.toJson()))
        .toList(growable: false);
    await prefs.setStringList('bmi_history', list);
  }

  Future<void> _updateWaterGlasses(int glasses) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterGlasses = glasses;
    });
    await prefs.setInt(
      'water_glasses_${DateTime.now().toDateString()}',
      glasses,
    );
  }

  Future<void> _loadWaterGlasses() async {
    final prefs = await SharedPreferences.getInstance();
    final glasses =
        prefs.getInt('water_glasses_${DateTime.now().toDateString()}') ?? 0;
    setState(() {
      _waterGlasses = glasses;
    });
  }

  // ─────────────────────────── CALCULATIONS ────────────────────────────────────

  void _toggleHeightUnit() {
    setState(() {
      if (_isCm) {
        // cm -> ft
        _height = _height / 30.48;
        if (_height < 3) _height = 3;
        if (_height > 7.5) _height = 7.5;
      } else {
        // ft -> cm
        _height = _height * 30.48;
        if (_height < 120) _height = 120;
        if (_height > 220) _height = 220;
      }
      _isCm = !_isCm;
    });
  }

  void _toggleWeightUnit() {
    setState(() {
      if (_isKg) {
        // kg -> lbs
        _weight = _weight * 2.20462;
        if (_weight < 70) _weight = 70;
        if (_weight > 440) _weight = 440;
      } else {
        // lbs -> kg
        _weight = _weight / 2.20462;
        if (_weight < 30) _weight = 30;
        if (_weight > 200) _weight = 200;
      }
      _isKg = !_isKg;
    });
  }

  // Convert current inputs to metric for formulas
  double _heightMeters() {
    if (_isCm) {
      return _height / 100.0;
    } else {
      // feet -> meter
      return _height * 0.3048;
    }
  }

  double _heightCm() => _heightMeters() * 100.0;

  double _weightKg() {
    if (_isKg) {
      return _weight;
    } else {
      return _weight / 2.20462;
    }
  }

  double _calculateBmiInternal() {
    final h = _heightMeters();
    final w = _weightKg();
    return w / pow(h, 2);
  }

  String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _bmiColor(String category) {
    switch (category) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String _healthTip(double bmi, ActivityLevel activity) {
    if (bmi < 18.5) {
      return "You are underweight. Increase calorie intake with healthy fats & proteins. "
          "Do light strength training 3x per week.";
    } else if (bmi < 25) {
      return "Great! You are in the healthy range. Maintain it with 30 minutes of walking or exercise daily.";
    } else if (bmi < 30) {
      return "You are slightly overweight. Try 40–45 minutes of brisk walking and reduce sugary drinks.";
    } else {
      return "You are obese. Focus on low-impact cardio (like walking, cycling) and talk to a health professional.";
    }
  }

  double _activityFactor(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.active:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
    }
  }

  double _calculateBmr(
    double weightKg,
    double heightCm,
    int age,
    Gender gender,
  ) {
    // Mifflin-St Jeor
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    if (gender == Gender.male) return base + 5;
    if (gender == Gender.female) return base - 161;
    return base;
  }

  // Navy Body Fat % Calculator
  double _calculateBodyFatPercent(
    double waistCm,
    double neckCm,
    double hipCm,
    Gender gender,
  ) {
    if (gender == Gender.male) {
      if (waistCm - neckCm <= 0) return 0;

      return 495 /
              (1.0324 -
                  0.19077 * (log(waistCm - neckCm) / log(10)) +
                  0.15456 * (log(_heightCm()) / log(10))) -
          450;
    } else {
      if (waistCm + hipCm - neckCm <= 0) return 0;

      return 495 /
              (1.29579 -
                  0.35004 * (log(waistCm + hipCm - neckCm) / log(10)) +
                  0.22100 * (log(_heightCm()) / log(10))) -
          450;
    }
  }

  // Muscle Mass calculation (Boer formula)
  double _calculateMuscleMass(double bodyFatPercent, double weightKg) {
    final leanBodyMass = weightKg * (100 - bodyFatPercent) / 100;
    return leanBodyMass * 0.75; // Approximate muscle mass
  }

  // Waist-to-Height Ratio
  double _calculateWHtR(double waistCm, double heightCm) {
    return waistCm / heightCm;
  }

  String _whtrCategory(double whtr) {
    if (whtr < 0.34) return 'Excellent';
    if (whtr < 0.43) return 'Good';
    if (whtr < 0.53) return 'At Risk';
    return 'High Risk';
  }

  // Calculate nutrition macros
  void _calculateNutrition(double bmr, ActivityLevel activity) {
    final tdee = bmr * _activityFactor(activity);

    // Protein: 1.6-2.2g per kg for active individuals
    _proteinGrams = _weightKg() * 1.8;

    // Carbs + Fats to meet calorie goal
    final caloriesFromProtein = _proteinGrams! * 4;
    final remainingCalories = tdee - caloriesFromProtein;

    // 50% carbs, 50% fats of remaining
    _carbsGrams = (remainingCalories * 0.5) / 4;
    _fatsGrams = (remainingCalories * 0.5) / 9;
  }

  // Calculate goal projection
  Map<String, dynamic> _calculateGoalProjection(
    double currentWeight,
    double goalWeight,
    double tdee,
  ) {
    final weightDiff = (goalWeight - currentWeight).abs();
    final calorieDeficit = 3500; // 1 kg = 3500 calories

    double weeklyCalorieChange = 0;
    String deficitType = '';

    if (_goal == Goal.lose && currentWeight > goalWeight) {
      weeklyCalorieChange = -3500; // 1 kg per week
      deficitType = 'Create a deficit of ~500 cal/day';
    } else if (_goal == Goal.gain && currentWeight < goalWeight) {
      weeklyCalorieChange = 3500;
      deficitType = 'Create a surplus of ~500 cal/day';
    }

    final weeksNeeded =
        (weightDiff * calorieDeficit / (weeklyCalorieChange.abs() + 0.001))
            .round();

    return {
      'weeklyChange': weeklyCalorieChange,
      'deficitType': deficitType,
      'weeksNeeded': weeksNeeded,
      'targetDate': DateTime.now().add(Duration(days: weeksNeeded * 7)),
    };
  }

  Future<void> _calculate() async {
    if (_age <= 0) return;

    HapticFeedback.mediumImpact(); // Haptic feedback ✅

    final bmi = _calculateBmiInternal();
    final cat = _bmiCategory(bmi);
    final color = _bmiColor(cat); // ignore: unused_local_variable

    final heightM = _heightMeters();
    final heightCm = _heightCm();
    final weightKg = _weightKg();

    // Ideal range from BMI 18.5–24.9
    final idealMin = 18.5 * pow(heightM, 2);
    final idealMax = 24.9 * pow(heightM, 2);

    // Calories
    final bmr = _calculateBmr(weightKg, heightCm, _age, _gender);
    final tdee = bmr * _activityFactor(_activityLevel);

    final maintain = tdee;
    final lose = tdee - 400; // simple deficit
    final gain = tdee + 400; // simple surplus

    final tip = _healthTip(bmi, _activityLevel);

    // Body Fat % (using simple estimation if waist not provided)
    final bodyFatPercent = _waist > 0
        ? _calculateBodyFatPercent(_waist, 35, 90, _gender)
        : null; // Will need neck/hip measurement
    final muscleMass = bodyFatPercent != null
        ? _calculateMuscleMass(bodyFatPercent, weightKg)
        : null;
    final whtrRatio = _waist > 0 ? _calculateWHtR(_waist, heightCm) : null;

    // Calculate nutrition
    _calculateNutrition(bmr, _activityLevel);

    final newEntry = BmiEntry(
      bmi: double.parse(bmi.toStringAsFixed(1)),
      weightKg: double.parse(weightKg.toStringAsFixed(1)),
      heightCm: double.parse(heightCm.toStringAsFixed(1)),
      bodyFatPercent: bodyFatPercent,
      muscleMass: muscleMass,
      whtrRatio: whtrRatio,
      waistCm: _waist,
      date: DateTime.now(),
    );

    setState(() {
      _bmi = newEntry.bmi;
      _category = cat;
      _idealMin = double.parse(idealMin.toStringAsFixed(1));
      _idealMax = double.parse(idealMax.toStringAsFixed(1));
      _calMaintain = maintain.roundToDouble();
      _calLose = lose.roundToDouble();
      _calGain = gain.roundToDouble();
      _tip = tip;
      _bodyFatPercent = bodyFatPercent;
      _muscleMass = muscleMass;
      _whtrRatio = whtrRatio;

      // add to history (max 10)
      _history.add(newEntry);
      if (_history.length > 10) {
        _history.removeAt(0);
      }
    });

    await _saveHistory();
  }

  void _shareResult() {
    if (_bmi == null) return;
    final bodyFatText = _bodyFatPercent != null
        ? "\nBody Fat: ${_bodyFatPercent!.toStringAsFixed(1)}%"
        : "";
    final muscleMassText = _muscleMass != null
        ? "\nMuscle Mass: ${_muscleMass!.toStringAsFixed(1)}kg"
        : "";
    final whtrText = _whtrRatio != null
        ? "\nWaist-to-Height Ratio: ${_whtrRatio!.toStringAsFixed(2)}"
        : "";
    final nutritionText = _proteinGrams != null
        ? "\n\nNutrition:\nProtein: ${_proteinGrams!.toStringAsFixed(0)}g\n"
              "Carbs: ${_carbsGrams!.toStringAsFixed(0)}g\nFats: ${_fatsGrams!.toStringAsFixed(0)}g"
        : "";

    final text =
        "My BMI is ${_bmi!.toStringAsFixed(1)} ($_category)."
        "\nIdeal weight range: ${_idealMin?.toStringAsFixed(1)}kg - ${_idealMax?.toStringAsFixed(1)}kg."
        "$bodyFatText$muscleMassText$whtrText"
        "\n\nDaily calories to maintain: ${_calMaintain?.toStringAsFixed(0)} kcal."
        "$nutritionText"
        "\n\nCalculated using BMI Pro.";
    Share.share(text);
  }

  // ─────────────────────────── BUILD ───────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Pro Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Theme Options'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        title: const Text('Dark Mode'),
                        value: widget.isDark,
                        onChanged: (_) => widget.onToggleTheme(),
                      ),
                      CheckboxListTile(
                        title: const Text('AMOLED'),
                        value: widget.isAmoled,
                        onChanged: (_) => widget.onToggleAmoled(),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
            tooltip: 'Theme',
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _WaterTrackerPage(
                  currentGlasses: _waterGlasses,
                  onUpdate: _updateWaterGlasses,
                ),
              ),
            ),
            icon: const Icon(Icons.water_drop),
            tooltip: 'Water Tracker',
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _ProfilePage(
                  profile: _userProfile,
                  onSave: (profile) {
                    setState(() => _userProfile = profile);
                    _saveUserProfile();
                  },
                ),
              ),
            ),
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // TOP SECTION: Gender + Age
              Row(
                children: [
                  Expanded(
                    child: _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _ChoiceChip(
                                label: "Male",
                                selected: _gender == Gender.male,
                                onTap: () =>
                                    setState(() => _gender = Gender.male),
                              ),
                              _ChoiceChip(
                                label: "Female",
                                selected: _gender == Gender.female,
                                onTap: () =>
                                    setState(() => _gender = Gender.female),
                              ),
                              _ChoiceChip(
                                label: "Other",
                                selected: _gender == Gender.other,
                                onTap: () =>
                                    setState(() => _gender = Gender.other),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Age",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_age > 5) _age--;
                                  });
                                },
                                icon: const Icon(Icons.remove_circle),
                              ),
                              Text(
                                "$_age",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_age < 100) _age++;
                                  });
                                },
                                icon: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // HEIGHT + WEIGHT
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Height row with unit toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Height",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(_isCm ? "cm" : "ft"),
                            const SizedBox(width: 8),
                            Switch(
                              value: _isCm,
                              onChanged: (_) => _toggleHeightUnit(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween(begin: 0, end: _height),
                      builder: (context, value, _) {
                        return Center(
                          child: Text(
                            _isCm
                                ? "${value.toStringAsFixed(0)} cm"
                                : "${value.toStringAsFixed(2)} ft",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    Slider(
                      min: _isCm ? 120 : 3.5,
                      max: _isCm ? 220 : 7.5,
                      value: _height,
                      onChanged: (v) => setState(() => _height = v),
                    ),
                    const SizedBox(height: 4),
                    // Weight row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Weight",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(_isKg ? "kg" : "lbs"),
                            const SizedBox(width: 8),
                            Switch(
                              value: _isKg,
                              onChanged: (_) => _toggleWeightUnit(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween(begin: 0, end: _weight),
                      builder: (context, value, _) {
                        return Center(
                          child: Text(
                            _isKg
                                ? "${value.toStringAsFixed(1)} kg"
                                : "${value.toStringAsFixed(1)} lbs",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    Slider(
                      min: _isKg ? 30 : 70,
                      max: _isKg ? 200 : 440,
                      value: _weight,
                      onChanged: (v) => setState(() => _weight = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ACTIVITY LEVEL
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Activity Level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ChoiceChip(
                          label: "Sedentary",
                          selected: _activityLevel == ActivityLevel.sedentary,
                          onTap: () => setState(
                            () => _activityLevel = ActivityLevel.sedentary,
                          ),
                        ),
                        _ChoiceChip(
                          label: "Lightly active",
                          selected:
                              _activityLevel == ActivityLevel.lightlyActive,
                          onTap: () => setState(
                            () => _activityLevel = ActivityLevel.lightlyActive,
                          ),
                        ),
                        _ChoiceChip(
                          label: "Active",
                          selected: _activityLevel == ActivityLevel.active,
                          onTap: () => setState(
                            () => _activityLevel = ActivityLevel.active,
                          ),
                        ),
                        _ChoiceChip(
                          label: "Very active",
                          selected: _activityLevel == ActivityLevel.veryActive,
                          onTap: () => setState(
                            () => _activityLevel = ActivityLevel.veryActive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // WAIST CIRCUMFERENCE
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Waist Circumference (cm)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "${_waist.toStringAsFixed(1)} cm",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Slider(
                      min: 50,
                      max: 150,
                      value: _waist,
                      onChanged: (v) => setState(() => _waist = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // GOAL
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Goal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _ChoiceChip(
                          label: "Lose Weight",
                          selected: _goal == Goal.lose,
                          onTap: () => setState(() => _goal = Goal.lose),
                        ),
                        _ChoiceChip(
                          label: "Maintain",
                          selected: _goal == Goal.maintain,
                          onTap: () => setState(() => _goal = Goal.maintain),
                        ),
                        _ChoiceChip(
                          label: "Gain Weight",
                          selected: _goal == Goal.gain,
                          onTap: () => setState(() => _goal = Goal.gain),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // CALCULATE BUTTON
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _calculate,
                  child: const Text(
                    "CALCULATE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // RESULT + SHARE + BMI BANDS
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: _bmi == null
                    ? const SizedBox.shrink()
                    : Column(
                        key: ValueKey(_bmi),
                        children: [
                          _Card(
                            color: _bmiColor(_category).withOpacity(0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Your Result",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: _shareResult,
                                      icon: const Icon(Icons.share),
                                      tooltip: "Share result",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _bmi!.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: _bmiColor(_category),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        _category,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: _bmiColor(_category),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (_idealMin != null && _idealMax != null)
                                  Text(
                                    "Ideal weight range: "
                                    "${_idealMin!.toStringAsFixed(1)} kg - "
                                    "${_idealMax!.toStringAsFixed(1)} kg",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                const SizedBox(height: 12),
                                if (_calMaintain != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Daily calorie suggestion:",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Maintain: ${_calMaintain!.toStringAsFixed(0)} kcal",
                                      ),
                                      Text(
                                        "Lose weight: ${_calLose!.toStringAsFixed(0)} kcal",
                                      ),
                                      Text(
                                        "Gain weight: ${_calGain!.toStringAsFixed(0)} kcal",
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 12),
                                if (_proteinGrams != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Daily Nutrition:",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Protein: ${_proteinGrams!.toStringAsFixed(0)}g",
                                      ),
                                      Text(
                                        "Carbs: ${_carbsGrams!.toStringAsFixed(0)}g",
                                      ),
                                      Text(
                                        "Fats: ${_fatsGrams!.toStringAsFixed(0)}g",
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 12),
                                if (_bodyFatPercent != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Advanced Metrics:",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Body Fat: ${_bodyFatPercent!.toStringAsFixed(1)}%",
                                      ),
                                      if (_muscleMass != null)
                                        Text(
                                          "Muscle Mass: ${_muscleMass!.toStringAsFixed(1)} kg",
                                        ),
                                      if (_whtrRatio != null)
                                        Text(
                                          "Waist-to-Height Ratio: ${_whtrRatio!.toStringAsFixed(2)} (${_whtrCategory(_whtrRatio!)})",
                                        ),
                                    ],
                                  ),
                                const SizedBox(height: 12),
                                Text(
                                  _tip,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // BMI BANDS CHART
                          _Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "BMI Categories",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _BmiBandRow(currentCategory: _category),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 16),

              // HISTORY + MINI CHART
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isLoadingHistory)
                      const Center(child: CircularProgressIndicator())
                    else if (_history.isEmpty)
                      const Text(
                        "No history yet. Calculate BMI to see it here.",
                      )
                    else ...[
                      SizedBox(
                        height: 140,
                        child: _HistoryChart(entries: _history),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _history.reversed
                            .map(
                              (e) => Text(
                                "${e.date.hour.toString().padLeft(2, '0')}:"
                                "${e.date.minute.toString().padLeft(2, '0')} - "
                                "BMI: ${e.bmi.toStringAsFixed(1)}",
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── REUSABLE WIDGETS ────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final Color? color;

  const _Card({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? scheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: -4,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceVariant,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _BmiBandRow extends StatelessWidget {
  final String currentCategory;

  const _BmiBandRow({required this.currentCategory});

  @override
  Widget build(BuildContext context) {
    final bands = [
      ('< 18.5', 'Underweight', Colors.blue),
      ('18.5–24.9', 'Normal', Colors.green),
      ('25–29.9', 'Overweight', Colors.orange),
      ('≥ 30', 'Obese', Colors.red),
    ];

    return Column(
      children: bands
          .map(
            (b) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 3),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: b.$3.withOpacity(currentCategory == b.$2 ? 0.18 : 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: currentCategory == b.$2 ? b.$3 : Colors.transparent,
                  width: 1.4,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: b.$3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    b.$2,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(b.$1, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// Simple bar chart for history
class _HistoryChart extends StatelessWidget {
  final List<BmiEntry> entries;

  const _HistoryChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final maxBmi =
        (entries.map((e) => e.bmi).reduce((a, b) => a > b ? a : b) as double)
            .clamp(1, 40);
    final minBmi =
        (entries.map((e) => e.bmi).reduce((a, b) => a < b ? a : b) as double)
            .clamp(1, 40);

    final range = (maxBmi - minBmi).abs() < 5 ? 5 : (maxBmi - minBmi);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: entries
          .asMap()
          .map((i, e) {
            final normalized = (e.bmi - minBmi) / range;
            final height = 40 + normalized * 80;
            return MapEntry(
              i,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        e.bmi.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.teal, Colors.tealAccent],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${e.date.day}/${e.date.month}",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
          .values
          .toList(),
    );
  }
}

// ─── PROFILE PAGE ────────────────────────────────────────────
class _ProfilePage extends StatefulWidget {
  final UserProfile? profile;
  final Function(UserProfile) onSave;

  const _ProfilePage({required this.profile, required this.onSave});

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _currentWeightController;
  late TextEditingController _goalWeightController;
  late Gender _selectedGender;
  late Goal _selectedGoal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _currentWeightController = TextEditingController(
      text: '${widget.profile?.currentWeight ?? 70}',
    );
    _goalWeightController = TextEditingController(
      text: '${widget.profile?.goalWeight ?? 65}',
    );
    _selectedGender = widget.profile?.gender ?? Gender.male;
    _selectedGoal = widget.profile?.goal ?? Goal.maintain;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: Gender.values
                        .map(
                          (g) => _ChoiceChip(
                            label: g.name.capitalize(),
                            selected: _selectedGender == g,
                            onTap: () => setState(() => _selectedGender = g),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Goal',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: Goal.values
                        .map(
                          (g) => _ChoiceChip(
                            label: g.name.capitalize(),
                            selected: _selectedGoal == g,
                            onTap: () => setState(() => _selectedGoal = g),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Weight (kg)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _currentWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g., 70',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Goal Weight (kg)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _goalWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g., 65',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final profile = UserProfile(
                    name: _nameController.text.isEmpty
                        ? 'User'
                        : _nameController.text,
                    gender: _selectedGender,
                    currentWeight:
                        double.tryParse(_currentWeightController.text) ?? 70,
                    goalWeight:
                        double.tryParse(_goalWeightController.text) ?? 65,
                    goal: _selectedGoal,
                    createdAt: widget.profile?.createdAt ?? DateTime.now(),
                  );
                  widget.onSave(profile);
                  Navigator.pop(context);
                },
                child: const Text('Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── WATER TRACKER PAGE ──────────────────────────────────────
class _WaterTrackerPage extends StatefulWidget {
  final int currentGlasses;
  final Function(int) onUpdate;

  const _WaterTrackerPage({
    required this.currentGlasses,
    required this.onUpdate,
  });

  @override
  State<_WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<_WaterTrackerPage> {
  late int _glasses;

  @override
  void initState() {
    super.initState();
    _glasses = widget.currentGlasses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Daily Water Intake',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$_glasses / 8 Glasses',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: _glasses / 8, minHeight: 8),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton.tonal(
                        onPressed: _glasses > 0
                            ? () {
                                setState(() => _glasses--);
                                widget.onUpdate(_glasses);
                              }
                            : null,
                        child: const Text('Remove'),
                      ),
                      FilledButton(
                        onPressed: _glasses < 8
                            ? () {
                                setState(() => _glasses++);
                                widget.onUpdate(_glasses);
                              }
                            : null,
                        child: const Text('Add Glass 💧'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_glasses >= 8)
              _Card(
                color: Colors.green.withOpacity(0.1),
                child: const Center(
                  child: Text(
                    '🎉 Goal Reached! Keep it up!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper extensions
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension DateTimeExtension on DateTime {
  String toDateString() => '$year-$month-$day';
}
