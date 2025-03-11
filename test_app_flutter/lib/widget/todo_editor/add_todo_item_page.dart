import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';
import 'package:test_app_flutter/widget/shared_library/shared/shared_app_scaffold.dart';

class AddTodoItemPage extends StatefulWidget {
  const AddTodoItemPage({super.key});

  @override
  State<AddTodoItemPage> createState() => _AddTodoItemPageState();
}

class _AddTodoItemPageState extends State<AddTodoItemPage> {
  static const double _formPadding = 16.0;
  static const double _fieldSpacing = 16.0;
  static const String _titleLabel = 'Title';
  static const String _titleHint = 'Enter the title of the todo item';
  static const String _descriptionLabel = 'Description (Optional)';
  static const String _descriptionHint =
      'Enter a description for the todo item';
  static const String _saveButtonText = 'Save';
  static const String _pageTitle = 'Add Todo Item';
  static const String _titleValidationMessage = 'Please enter a title';

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final _appController = GetIt.instance<AppController>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodoItem() {
    if (_formKey.currentState!.validate()) {
      _createAndSaveTodoItem();
      _navigateBack();
    }
  }

  void _createAndSaveTodoItem() {
    final newItem = TodoItem(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
    );

    _appController.addTodoItem(newItem);
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SharedAppScaffoldWidget(
      config: _buildAppPage().scaffold.toSharedAppScaffold(),
      body: _buildFormBody(),
    );
  }

  AppPage<TodoItem> _buildAppPage() {
    return AppPage<TodoItem>(
      scaffold: AppScaffold(
        titleText: _pageTitle,
        floatingAction: _buildSaveAction(),
      ),
      sections: const [], // 상수로 표시
    );
  }

  AppItemAction<BuildContext> _buildSaveAction() {
    return AppItemAction<BuildContext>(
      label: AppLabel(
        text: _saveButtonText,
        iconData: Icons.save,
      ),
      onPressed: (_) async => _saveTodoItem(),
    );
  }

  Widget _buildFormBody() {
    return Padding(
      padding: const EdgeInsets.all(_formPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleField(),
            const SizedBox(height: _fieldSpacing),
            _buildDescriptionField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _titleValidationMessage;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: _titleLabel,
        hintText: _titleHint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: _descriptionLabel,
        hintText: _descriptionHint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
