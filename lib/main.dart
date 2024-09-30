import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Aquí definimos que la primera pantalla sea el login
      home: const LoginScreen(),
    );
  }
}

// 7. Pantalla de Login / Registro
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Al presionar el botón de inicio de sesión, se redirige al Dashboard
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: const Text('Iniciar Sesión'),
            ),
            TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirige a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroScreen()),
                );
              },
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de Registro
class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simular el registro y redirigir al Dashboard
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: const Text('Registrar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Regresa a la pantalla de login
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Pantalla de Inicio / Dashboard
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Acción para ver el perfil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfiguracionScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Resumen de Saldos', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Ingresos: \$2000'),
                Text('Gastos: \$1500'),
                Text('Dinero Restante: \$500'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Progreso hacia Objetivos', style: TextStyle(fontSize: 18)),
            LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 20),
            const Text('Gráfica de Gastos por Categoría', style: TextStyle(fontSize: 18)),
            Expanded(
              child: Center(
                child: PieChartWidget(), // Gráfico circular
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Redirigir a la pantalla de ingreso de datos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IngresoGastoScreen(type: 'Gasto')),
                );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Pantalla de Ingreso de Datos (Ingresos/Gastos)
class IngresoGastoScreen extends StatelessWidget {
  final String type; // 'Gasto' o 'Ingreso'

  const IngresoGastoScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar $type')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Fecha'),
              keyboardType: TextInputType.datetime,
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(child: Text('Alimentación'), value: 'Alimentación'),
                DropdownMenuItem(child: Text('Transporte'), value: 'Transporte'),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Guardar')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Regresa al dashboard
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Pantalla de Configuración
class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(child: Text('USD'), value: 'USD'),
                DropdownMenuItem(child: Text('EUR'), value: 'EUR'),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Moneda'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Guardar Cambios')),
          ],
        ),
      ),
    );
  }
}

// Componente Gráfico Placeholder
class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Gráfico Circular Placeholder'));
  }
}


