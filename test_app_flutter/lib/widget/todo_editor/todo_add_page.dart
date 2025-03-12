import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page_section/custom_section.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  State<TodoAddPage> createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleInput = TextEditingController();
  final TextEditingController _descriptionInput = TextEditingController();
  late final _appController = GetIt.instance<AppController>();

  void _saveTodoItem() {
    if (_formKey.currentState!.validate()) {
      final todoItem = TodoItem(
          title: _titleInput.text,
          description:
              _descriptionInput.text.isEmpty ? '' : _descriptionInput.text,
          isDone: false);

      final todoListUpdate =
          List<TodoItem>.from(_appController.todoItemsEmitter.value)
            ..add(todoItem);
      _appController.todoItemsEmitter.value = todoListUpdate;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleInput,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionInput,
                  decoration: const InputDecoration(
                      labelText: 'Description (Optional)'),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTodoItem,
                    child: const Text('Save'),
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
