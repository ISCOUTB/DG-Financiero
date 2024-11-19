import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'summary_page.dart';
import 'goaldetailpage.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Finanzas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.light(secondary: Colors.orangeAccent),
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black54),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: const IconThemeData(
          color: Colors.deepPurple,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelStyle: TextStyle(color: Colors.deepPurple),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(secondary: Colors.orangeAccent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/summary': (context) => const SummaryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        }

        return null;
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? registeredUsers = prefs.getStringList('registeredUsers');
    List<String>? registeredPasswords = prefs.getStringList('registeredPasswords');

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (registeredUsers == null || registeredPasswords == null) {
      _showError('No se encontraron usuarios registrados.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userIndex = registeredUsers.indexOf(email);
    if (userIndex == -1 || registeredPasswords[userIndex] != password) {
      _showError('Usuario o contraseña incorrectos.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    prefs.setBool('isLoggedIn', true);
    prefs.setString('loggedUser', email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Inicio de sesión exitoso!')),
    );

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                _isLoading
                    ? const CircularProgressIndicator()
                    : AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ),
                const SizedBox(height: 16),
                
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      '¿No tienes una cuenta? Regístrate',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!email.contains('@')) {
      _showError('Correo electrónico no válido.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      _showError('La contraseña debe tener al menos 6 caracteres.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? registeredUsers = prefs.getStringList('registeredUsers') ?? [];
    List<String>? registeredPasswords = prefs.getStringList('registeredPasswords') ?? [];

    if (registeredUsers.contains(email)) {
      _showError('El usuario ya está registrado.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    registeredUsers.add(email);
    registeredPasswords.add(password);

    await prefs.setStringList('registeredUsers', registeredUsers);
    await prefs.setStringList('registeredPasswords', registeredPasswords);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Registro exitoso!')),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Registrarse'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 1),
                child: const Text(
                  'Registro de Usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Registrar'),
                      ),
                    ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 1),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController(); // Para ingresos
  final TextEditingController _expensesController = TextEditingController(); // Para egresos
  bool _isSaving = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Cargar datos del perfil guardados
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? 'Usuario';
      _incomeController.text = prefs.getString('userIncome') ?? '0.00'; // Cargar ingresos
      _expensesController.text = prefs.getString('userExpenses') ?? '0.00'; // Cargar egresos
    });
  }

  // Guardar datos del perfil
  Future<void> _saveProfileData() async {
    setState(() {
      _isSaving = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userIncome', _incomeController.text); // Guardar ingresos
    await prefs.setString('userExpenses', _expensesController.text); // Guardar egresos

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado correctamente')),
    );
  }

  // Seleccionar imagen de perfil
  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animación del título
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 1),
                child: const Text(
                  'Actualizar Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Imagen de perfil con opción para cambiarla
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Center(
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.deepPurple,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/placeholder.png') as ImageProvider,
                      child: _profileImage == null
                          ? const Icon(Icons.camera_alt, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo para ingresar nombre
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo para ingresar ingresos
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: TextField(
                  controller: _incomeController,
                  decoration: InputDecoration(
                    labelText: 'Ingresos Mensuales',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),

              // Campo para ingresar egresos
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: TextField(
                  controller: _expensesController,
                  decoration: InputDecoration(
                    labelText: 'Egresos Mensuales',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),

              // Botón para guardar cambios
              _isSaving
                  ? const CircularProgressIndicator()
                  : AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      child: ElevatedButton(
                        onPressed: _saveProfileData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
              const SizedBox(height: 20),

              // Consejos financieros
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Consejos para una vida financiera sana:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Lleva un registro de tus ingresos y egresos.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '2. Crea un presupuesto y cúmplelo al máximo.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '3. Establece metas financieras claras y alcanzables.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '4. Invierte en tu futuro, ahorra para emergencias.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '5. Evita el endeudamiento innecesario.',
                      style: TextStyle(fontSize: 16),
                    ),
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


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _goals = [];
  double totalProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Cargar metas guardadas desde SharedPreferences
  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _goals = prefs.getStringList('financialGoals')?.map((goal) {
        return json.decode(goal) as Map<String, dynamic>;
      }).toList() ?? [];
      totalProgress = _goals.isNotEmpty
          ? _goals
              .map((goal) =>
                  (goal['progress'] as double) / (goal['target'] as double) * 100)
              .reduce((a, b) => a + b) /
              _goals.length
          : 0.0;
    });
  }

  // Agregar una nueva meta
  Future<void> _addGoal(String title, double target) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _goals.add({"title": title, "target": target, "progress": 0.0});
    });
    await _saveGoals();
  }

  // Guardar metas en SharedPreferences
  Future<void> _saveGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedGoals = _goals.map((goal) => json.encode(goal)).toList();
    await prefs.setStringList('financialGoals', savedGoals);
  }

  // Eliminar una meta
  void _deleteGoal(int index) {
    setState(() {
      _goals.removeAt(index);
    });
    _saveGoals();
  }

  // Mostrar cuadro de diálogo para agregar una nueva meta
  void _showAddGoalDialog() {
    String title = '';
    double target = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Objetivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Meta'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  target = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty && target > 0) {
                  _addGoal(title, target); // Añade la meta
                  Navigator.pop(context); // Cierra el diálogo después de agregar la meta
                } else {
                  // Mostrar un mensaje de error si los campos están vacíos o inválidos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, complete todos los campos')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Gráfico de barras para mostrar el progreso de las metas
  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: _goals.map((goal) {
            final target = goal['target'] as double;
            final progress = goal['progress'] as double;
            return BarChartGroupData(
              x: _goals.indexOf(goal),
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: progress / target * 100,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.greenAccent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Objetivos Financieros'),
      actions: [
        // Icono para el perfil
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        // Icono para el resumen
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SummaryPage()),
            );
          },
        ),
        // Icono para agregar una nueva meta
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: _showAddGoalDialog,
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Progreso Total: ${totalProgress.toStringAsFixed(2)}%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _goals.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'No tienes objetivos aún. ¡Agrega uno para empezar!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(goal['title']),
                          subtitle: Text(
                              'Progreso: ${goal['progress']} / ${goal['target']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteGoal(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoalDetailPage(goal: goal),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
          _buildBarChart(),
        ],
      ),
    ),
  );
}
}