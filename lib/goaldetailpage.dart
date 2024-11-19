import 'package:flutter/material.dart';

class GoalDetailPage extends StatefulWidget {
  final Map<String, dynamic> goal;
  const GoalDetailPage({Key? key, required this.goal}) : super(key: key);

  @override
  _GoalDetailPageState createState() => _GoalDetailPageState();
}

class _GoalDetailPageState extends State<GoalDetailPage> {
  final TextEditingController _progressController = TextEditingController();
  late double remainingAmount;
  late int daysLeft;
  late double dailyAmount;
  late double currentProgress;
  late double target;
  DateTime targetDate = DateTime.now().add(Duration(days: 30));
  late List<DateTime> paymentDates;

  @override
  void initState() {
    super.initState();
    target = widget.goal['target'];
    currentProgress = widget.goal['progress'];
    _progressController.text = currentProgress.toString();
    remainingAmount = target - currentProgress;
    daysLeft = _calculateDaysLeft();
    dailyAmount = remainingAmount / daysLeft;
    targetDate = DateTime.now().add(Duration(days: 30)); // Ejemplo: 30 días para alcanzar la meta
    paymentDates = [];
  }

  int _calculateDaysLeft() {
    return targetDate.difference(DateTime.now()).inDays;
  }

  void _updateProgress() {
    setState(() {
      currentProgress = double.tryParse(_progressController.text) ?? currentProgress;
      remainingAmount = target - currentProgress;
      daysLeft = _calculateDaysLeft();
      dailyAmount = remainingAmount / daysLeft;
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: targetDate,
    );

    if (pickedDate != null && pickedDate.isAfter(DateTime.now())) {
      setState(() {
        paymentDates.add(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Meta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Aquí podrías permitir editar el nombre o el objetivo
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Información de la meta
            Text(
              widget.goal['title'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Objetivo: \$${target.toStringAsFixed(2)}'),
            Text('Progreso actual: \$${currentProgress.toStringAsFixed(2)}'),
            Text('Cantidad restante: \$${remainingAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 20),

            // Editar el progreso de la meta
            TextField(
              controller: _progressController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Actualizar progreso',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _updateProgress();
              },
            ),

            const SizedBox(height: 20),

            // Información adicional sobre cómo alcanzar la meta
            Text(
              'Te falta agregar \$${remainingAmount.toStringAsFixed(2)} en los próximos $daysLeft días.',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Deberías agregar \$${dailyAmount.toStringAsFixed(2)} cada día.',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            // Calendario de metas (solo ejemplo con un rango de fechas)
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Seleccionar Fecha de Pago'),
            ),

            const SizedBox(height: 20),

            // Mostrar fechas seleccionadas (los días de pago)
            const Text(
              'Fechas de pago seleccionadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: paymentDates.length,
                itemBuilder: (context, index) {
                  // Utilizando el método de `toString` para obtener el formato de fecha.
                  return ListTile(
                    title: Text(
                      '${paymentDates[index].year}-${paymentDates[index].month.toString().padLeft(2, '0')}-${paymentDates[index].day.toString().padLeft(2, '0')}',
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
