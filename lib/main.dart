import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(GestorFinanzasApp());
}

class GestorFinanzasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Finanzas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.brown,
        ).copyWith(
          secondary: Color(0xFFF4A460),
        ),
        scaffoldBackgroundColor: Color(0xFFFAF3E0),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8B4513),
          elevation: 4,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF4A460),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 0, 0),
          ),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ),
      home: LoginPage(),
    );
  }
}

// Simulación de autenticación
class AuthService {
  static bool isLoggedIn = false;
}

// Pantalla de Login / Registro
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _name = '';

  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submitForm() {
    if ((_isLogin && _formKeyLogin.currentState!.validate()) ||
        (!_isLogin && _formKeyRegister.currentState!.validate())) {
      // Simulación de inicio de sesión o registro exitoso
      AuthService.isLoggedIn = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }

  void _goToRecoverPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecoverPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Iniciar Sesión' : 'Crear Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Correo Electrónico'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Ingrese un correo electrónico válido';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Iniciar Sesión'),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: _goToRecoverPassword,
            child: Text('¿Olvidaste tu contraseña?'),
          ),
          TextButton(
            onPressed: _toggleFormType,
            child: Text('Crear una cuenta'),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKeyRegister,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese su nombre';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Correo Electrónico'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Ingrese un correo electrónico válido';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Registrar'),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: _toggleFormType,
            child: Text('Ya tengo una cuenta. Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}

class RecoverPasswordPage extends StatelessWidget {
  final _formKeyRecover = GlobalKey<FormState>();
  String _email = '';

  void _submitForm(BuildContext context) {
    if (_formKeyRecover.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enlace de recuperación enviado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyRecover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text('Enviar Enlace de Recuperación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalIngresos = 0.0;
  double totalGastos = 0.0;
  double saldoRestante = 0.0;

  Map<String, dynamic>? selectedGoal;
  Map<String, dynamic>? nearestGoal;

  @override
  void initState() {
    super.initState();
    _loadNearestGoal();
  }

  // Función para actualizar los balances
  void _updateBalance(double income, double expense) {
    setState(() {
      totalIngresos += income;
      totalGastos += expense;
      saldoRestante = totalIngresos - totalGastos;
    });
    _updateGoalsProgress(); // Actualiza el progreso de los objetivos tras actualizar saldo
  }

  // Cargar el objetivo financiero más cercano al 100% de progreso

  Future<void> _loadNearestGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? goalsString = prefs.getString('financial_goals');
    if (goalsString != null) {
      List<Map<String, dynamic>> goals =
          List<Map<String, dynamic>>.from(json.decode(goalsString) as List);

      if (goals.isNotEmpty) {
        // Ordenar por el progreso más cercano a 100%
        goals.sort((a, b) {
          double progressA = a['progress'];
          double progressB = b['progress'];
          return progressB.compareTo(progressA); // Orden descendente
        });

        setState(() {
          nearestGoal = goals.first; // El más cercano a 100% de progreso
        });
      }
    }
  }

  // Función para actualizar el progreso de los objetivos
  void _updateGoalsProgress() {
    if (selectedGoal != null) {
      double progress = saldoRestante / selectedGoal!['amount'];
      setState(() {
        selectedGoal!['progress'] =
            (progress * 100).clamp(0, 100); // Limita el valor entre 0% y 100%
      });
    }
    if (nearestGoal != null) {
      double progress = saldoRestante / nearestGoal!['amount'];
      setState(() {
        nearestGoal!['progress'] = (progress * 100).clamp(0, 100);
      });
    }
  }

  // Función para actualizar el objetivo seleccionado
  void _updateSelectedGoal(Map<String, dynamic> goal) {
    setState(() {
      selectedGoal = goal;
    });
    _updateGoalsProgress(); // Actualiza el progreso del nuevo objetivo seleccionado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService.isLoggedIn = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de saldos
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Saldos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Total de Ingresos: \$${totalIngresos.toStringAsFixed(2)}'),
                    Text(
                        'Total de Gastos: \$${totalGastos.toStringAsFixed(2)}'),
                    Text(
                        'Saldo Restante: \$${saldoRestante.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Progreso hacia objetivos financieros
            Text(
              'Progreso hacia Objetivo Financiero',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            nearestGoal != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Objetivo más cercano: ${nearestGoal!['name']} - Progreso: ${nearestGoal!['progress']}% - Monto: \$${nearestGoal!['amount'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      LinearProgressIndicator(
                        value: nearestGoal!['progress'] / 100,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orange,
                        minHeight: 10,
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            selectedGoal != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Objetivo seleccionado: ${selectedGoal!['name']} - Progreso: ${selectedGoal!['progress']}% - Monto: \$${selectedGoal!['amount'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      LinearProgressIndicator(
                        value: selectedGoal!['progress'] / 100,
                        backgroundColor: Colors.grey[300],
                        color: Colors.orange,
                        minHeight: 10,
                      ),
                    ],
                  )
                : Container(),
            // Opciones del Dashboard
            ListTile(
              leading: Icon(Icons.monetization_on, color: Colors.orange),
              title: Text('Objetivos Financieros'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinancialGoalsPage(
                        updateSelectedGoal: _updateSelectedGoal,
                        saldoRestante: saldoRestante),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_chart, color: Colors.green),
              title: Text('Registrar Ingreso o Gasto'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddTransactionPage(
                          updateBalance: _updateBalance,
                          updateGoalsProgress: _updateGoalsProgress)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Configuración de Usuario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialGoalsPage extends StatefulWidget {
  final Function(Map<String, dynamic> selectedGoal) updateSelectedGoal;
  final double saldoRestante; // Pasamos el saldo restante del Dashboard

  const FinancialGoalsPage({
    Key? key,
    required this.updateSelectedGoal,
    required this.saldoRestante,
  }) : super(key: key);

  @override
  _FinancialGoalsPageState createState() => _FinancialGoalsPageState();
}

class _FinancialGoalsPageState extends State<FinancialGoalsPage> {
  final _formKey = GlobalKey<FormState>();
  String _goalName = '';
  double _goalAmount = 0.0;
  DateTime? _deadline;
  List<Map<String, dynamic>> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Cargar objetivos desde SharedPreferences
  Future<void> _loadGoals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? goalsString = prefs.getString('financial_goals');
    if (goalsString != null) {
      setState(() {
        _goals =
            List<Map<String, dynamic>>.from(json.decode(goalsString) as List);
      });
      _updateGoalProgress(); // Actualizar el progreso con respecto al saldo restante
    }
  }

  // Guardar objetivos en SharedPreferences
  Future<void> _saveGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> newGoal = {
      'name': _goalName,
      'amount': _goalAmount,
      'progress': 0, // Inicialmente, el progreso es 0%
      'deadline': _deadline != null ? _deadline!.toIso8601String() : null
    };

    setState(() {
      _goals.add(newGoal);
    });

    prefs.setString('financial_goals', json.encode(_goals));
    _updateGoalProgress(); // Actualizar el progreso tras añadir un nuevo objetivo
  }

  // Calcular y actualizar el porcentaje de progreso de cada objetivo basado en el saldo restante
  void _updateGoalProgress() {
    setState(() {
      for (var goal in _goals) {
        double progress = widget.saldoRestante / goal['amount'];
        goal['progress'] = (progress * 100).clamp(0, 100);
      }
    });
  }

  // Seleccionar un objetivo y actualizar el Dashboard
  void _selectGoal(Map<String, dynamic> goal) {
    widget.updateSelectedGoal(goal);
    Navigator.pop(context); // Volver al dashboard
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveGoal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objetivos Financieros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Nombre del objetivo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un nombre para el objetivo';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _goalName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Monto deseado'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Ingrese un monto válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _goalAmount = double.parse(value!);
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Guardar Objetivo'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Lista de Objetivos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  var goal = _goals[index];
                  return ListTile(
                    title: Text(goal['name']),
                    subtitle: Text(
                        'Progreso: ${goal['progress']}% - Monto: \$${goal['amount'].toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _selectGoal(goal);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTransactionPage extends StatefulWidget {
  final Function(double, double) updateBalance;
  final Function updateGoalsProgress;

  AddTransactionPage(
      {required this.updateBalance, required this.updateGoalsProgress});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  double _amount = 0.0;
  String _category = 'Gasto'; // Por defecto se establece en "Gasto"
  final List<String> _categories = ['Gasto', 'Ingreso'];
  List<Map<String, dynamic>> _transactions = []; // Lista de transacciones

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Cargar transacciones al iniciar
  }

  // Función para cargar las transacciones almacenadas
  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactionsStringList =
        prefs.getStringList('transactions') ?? [];

    setState(() {
      _transactions = transactionsStringList
          .map((transactionString) =>
              jsonDecode(transactionString) as Map<String, dynamic>)
          .toList();
    });
  }

  // Función para registrar una transacción
  void _registerTransaction(
      String description, double amount, String category) {
    Map<String, dynamic> newTransaction = {
      'description': description,
      'amount': amount,
      'category': category,
    };

    // Guardar la transacción en SharedPreferences
    _saveTransaction(newTransaction).then((_) {
      // Actualizar el balance en función de si es un ingreso o gasto
      if (category == 'Ingreso') {
        widget.updateBalance(amount, 0); // Aumenta los ingresos
      } else if (category == 'Gasto') {
        widget.updateBalance(0, amount); // Aumenta los gastos
      }

      widget.updateGoalsProgress(); // Actualizar el progreso de los objetivos

      // Actualizar la lista de transacciones después de registrar una nueva
      setState(() {
        _transactions.add(newTransaction);
      });

      Navigator.pop(context); // Cerrar la página tras guardar
    });
  }

  // Función para guardar la transacción usando SharedPreferences
  Future<void> _saveTransaction(Map<String, dynamic> transaction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    // Guardar nueva transacción en la lista de transacciones
    transactions.add(jsonEncode(transaction));
    await prefs.setStringList('transactions', transactions);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Registrar la transacción
      _registerTransaction(_description, _amount, _category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Ingreso o Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Monto'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Ingrese un monto válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _amount = double.parse(value!);
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Categoría'),
                    items: _categories.map((String category) {
                      return DropdownMenuItem(
                          value: category, child: Text(category));
                    }).toList(),
                    onChanged: (value) {
                      _category = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm(); // Llamar al método para registrar la transacción
                      }
                    },
                    child: Text('Registrar'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Mostrar las transacciones registradas
            Expanded(
              child: _transactions.isEmpty
                  ? Center(child: Text('No hay transacciones registradas'))
                  : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        var transaction = _transactions[index];
                        return ListTile(
                          title: Text(transaction['description']),
                          subtitle: Text(
                              '${transaction['category']} - Monto: \$${transaction['amount'].toStringAsFixed(2)}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _currentUserName = '';
  String _currentEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserSettings(); // Cargar los ajustes guardados
  }

  // Cargar nombre de usuario y correo desde SharedPreferences
  Future<void> _loadUserSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserName = prefs.getString('userName') ?? 'No guardado';
      _currentEmail = prefs.getString('email') ?? 'No guardado';
    });
  }

  // Guardar nombre de usuario y correo en SharedPreferences
  Future<void> _saveUserSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setString('email', _email);

    // Mostrar los valores actualizados en la pantalla
    setState(() {
      _currentUserName = _userName;
      _currentEmail = _email;
    });

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración guardada exitosamente')),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveUserSettings(); // Guardar configuración
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar usuario y correo actual
            Text(
              'Usuario actual: $_currentUserName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Correo actual: $_currentEmail',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo para nombre de usuario
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre de usuario'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su nombre de usuario';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                  SizedBox(height: 16),
                  // Campo para correo electrónico
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Correo Electrónico'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Ingrese un correo electrónico válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  // Botón para guardar cambios
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
