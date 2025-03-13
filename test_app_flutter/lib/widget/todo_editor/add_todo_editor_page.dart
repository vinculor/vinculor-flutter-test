import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';

class AddTodoItemPage extends StatefulWidget {
  const AddTodoItemPage({super.key});

  @override
  State<AddTodoItemPage> createState() => _AddTodoItemPageState();
}

class _AddTodoItemPageState extends State<AddTodoItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = TodoItem(
        title: _titleController.text,
        description: _descriptionController.text,
        isDone: false,
      );
      Navigator.pop(context, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
