import 'package:flutter/material.dart';
import '../models/paso_model.dart';

class DynamicForm extends StatefulWidget {
  final PasoTemplate paso;
  final void Function(Map<String, dynamic>) onSubmit;
  const DynamicForm({super.key, required this.paso, required this.onSubmit});

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          ...widget.paso.fields.map((f) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '${f.name}${f.unit != null ? ' (${f.unit})' : ''}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (v) => _values[f.name] = double.tryParse(v ?? '0'),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSubmit(_values);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
