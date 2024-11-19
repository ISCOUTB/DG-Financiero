import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para los ingresos y egresos
    double ingresos = 5000;
    double egresos = 3000;
    double saldo = ingresos - egresos;

    // Datos simulados para la tendencia de ingresos y egresos a lo largo del tiempo
    List<double> ingresosHistoricos = [3000, 4000, 3500, 5000, 6000, 7000];
    List<double> egresosHistoricos = [1000, 2500, 1500, 3000, 3500, 4000];

    // Datos simulados para la distribución de gastos
    List<String> categorias = ['Alquiler', 'Comida', 'Transporte', 'Entretenimiento'];
    List<double> distribucionGastos = [1200, 800, 500, 500];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Finanzas'),
      ),
      body: SingleChildScrollView(  // Se agrega SingleChildScrollView para permitir desplazamiento
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección de resumen
            const Text(
              'Resumen de tus Finanzas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Muestra de los ingresos, egresos y saldo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ingresos:', style: TextStyle(fontSize: 18)),
                    Text('\$${ingresos.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Egresos:', style: TextStyle(fontSize: 18)),
                    Text('\$${egresos.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo:', style: TextStyle(fontSize: 18)),
                    Text('\$${saldo.toStringAsFixed(2)}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Gráfico de barras para mostrar el análisis visual de los ingresos y egresos
            AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: ingresos,
                          width: 30,
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.greenAccent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: egresos,
                          width: 30,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gráfico de línea para mostrar la tendencia de ingresos y egresos
            const Text(
              'Tendencia de Ingresos y Egresos a lo Largo del Tiempo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        ingresosHistoricos.length,
                        (index) => FlSpot(index.toDouble(), ingresosHistoricos[index]),
                      ),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: List.generate(
                        egresosHistoricos.length,
                        (index) => FlSpot(index.toDouble(), egresosHistoricos[index]),
                      ),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gráfico de pastel para mostrar la distribución de los gastos
            const Text(
              'Distribución de Gastos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.5,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: List.generate(categorias.length, (index) {
                    return PieChartSectionData(
                      color: _getCategoryColor(index),
                      value: distribucionGastos[index],
                      title: '${categorias[index]}: \$${distribucionGastos[index].toStringAsFixed(2)}',
                      radius: 100,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para asignar un color a cada categoría en el gráfico de pastel
  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}

