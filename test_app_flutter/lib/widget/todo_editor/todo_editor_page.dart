import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_tile.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page_section/card_section.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page_section/list_section.dart';
import 'package:test_app_flutter/widget/todo_editor/add_todo_item_page.dart';

class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({super.key});

  @override
  State<TodoEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  static const String _pageTitle = 'TODO Editor';
  static const String _addButtonText = 'Add Item';
  static const String _inProgressTitle = 'In Progress';
  static const String _completedTitle = 'Completed';
  static const String _countPrefix = 'Count: ';

  late final _appController = GetIt.instance<AppController>();

  final Map<int, bool> _processingItems = <int, bool>{};

  AppPage<List<TodoItem>> get _appPage => AppPage<List<TodoItem>>(
        scaffold: AppScaffold(
          titleText: _pageTitle,
          floatingAction: _buildAddItemAction(),
        ),
        loadingEmitter: _appController.todoItemsEmitter,
        sections: [
          CardSection<List<TodoItem>>(
            emitter: _appController.todoItemsEmitter,
            tileBuilder: _cardTiles,
          ),
          ListSection(
            listEmitter: _appController.todoItemsEmitter,
            itemGroups: [
              ListItemGroup<TodoItem>(
                builder: _itemBuilder,
                titleText: _inProgressTitle,
                filter: (item) => !item.isDone,
                showCount: false,
              ),
              ListItemGroup<TodoItem>(
                builder: _itemBuilder,
                titleText: _completedTitle,
                filter: (item) => item.isDone,
                showCount: true,
              ),
            ],
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return _appPage.build();
  }

  AppItemAction<BuildContext> _buildAddItemAction() {
    return AppItemAction<BuildContext>(
      label: AppLabel(
        text: _addButtonText,
        iconData: Icons.add,
      ),
      onPressed: (BuildContext context) async {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const AddTodoItemPage(),
          ),
        );
      },
    );
  }

  List<Widget> _cardTiles(List<TodoItem> items) {
    return <Widget>[
      AppTile(
        iconData: Icons.numbers,
        titleText: '$_countPrefix${items.length}',
      ).build(),
    ];
  }

  Widget _itemBuilder(TodoItem item) {
    final int itemIndex = _appController.todoItemsEmitter.value.indexOf(item);
    final bool isProcessing = _processingItems[itemIndex] == true;

    return ListTile(
      leading: Checkbox(
        value: item.isDone,
        onChanged:
            isProcessing ? null : _buildCheckboxCallback(item, itemIndex),
      ),
      title: Text(item.title),
      subtitle: item.description != null ? Text(item.description!) : null,
    );
  }

  ValueChanged<bool?> _buildCheckboxCallback(TodoItem item, int itemIndex) {
    return (bool? value) async {
      setState(() {
        _processingItems[itemIndex] = true;
      });

      await _appController.toggleTodoItemStatus(item, itemIndex);

      if (mounted) {
        setState(() {
          _processingItems[itemIndex] = false;
        });
      }
    };
  }
}
