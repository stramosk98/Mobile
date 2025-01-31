import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedActivity;
  double? _distance;

  final List<String> _activities = [
    'Transporte (Carro)',
    'Transporte (Bicicleta)',
    'Consumo de Energia',
    'Desperdício de Alimentos',
  ];

  void _saveActivity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      double impact = 0;
      if (_selectedActivity == 'Transporte (Carro)') {
        impact = (_distance ?? 0) * 0.21;
      } else if (_selectedActivity == 'Transporte (Bicicleta)') {
        impact = 0;
      } else if (_selectedActivity == 'Consumo de Energia') {
        impact = (_distance ?? 0) * 0.5;
      } else if (_selectedActivity == 'Desperdício de Alimentos') {
        impact = (_distance ?? 0) * 0.9;
      }

      Map<String, dynamic> newActivity = {
        'date': DateTime.now().toString(),
        'activity': _selectedActivity,
        'impact': '${impact.toStringAsFixed(2)} kg CO₂',
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> activities = prefs.getStringList('activities') ?? [];
      activities.add(jsonEncode(newActivity));
      await prefs.setStringList('activities', activities);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Atividade salva com sucesso! Impacto: ${newActivity['impact']}')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Atividade'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecione a Atividade:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _selectedActivity,
                items: _activities.map((activity) {
                  return DropdownMenuItem(
                    value: activity,
                    child: Text(activity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivity = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma atividade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Informe a Distância (em km ou energia):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Exemplo: 15.5',
                ),
                onSaved: (value) {
                  _distance = double.tryParse(value ?? '');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Salvar Atividade'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
