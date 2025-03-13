import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_tile.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page_section/card_section.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page_section/list_section.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/todo_editor/add_todo_page.dart';

class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({super.key});

  @override
  State<TodoEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  late final _appController = GetIt.instance<AppController>();

  void _navigateToAddItem() async {
    final newItem = await Navigator.push<TodoItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddTodoPage()),
    );
    if (newItem != null) {
      _appController.addTodoItem(newItem);
    }
  }

  get _appPage => AppPage(
        scaffold: AppScaffold(
          titleText: 'TODO Editor',
          floatingAction: AppItemAction(
            label: AppLabel(
              text: 'Add Item',
              iconData: Icons.add,
            ),
            onPressed: (item) async {
              _navigateToAddItem();
            },
            isBlocking: false,
          ),
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
                titleText: 'In Progress',
                showCount: false,
                builder: _itemBuilder,
                filter: (items) => !items.isDone,
              ),
              ListItemGroup<TodoItem>(
                titleText: 'Completed',
                showCount: true,
                builder: _itemBuilder,
                filter: (items) => items.isDone,
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return _appPage.build();
  }

  List<Widget> _cardTiles(List<TodoItem> items) {
    return [
      AppTile(
        iconData: Icons.numbers,
        titleText: 'Count: ${items.length}',
      ).build(),
    ];
  }

  Widget _itemBuilder(TodoItem item) {
    final ValueNotifier<bool> isProcessing = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
        valueListenable: isProcessing,
        builder: (context, processing, _) {
          return ListTile(
            leading: Checkbox(
              value: item.isDone,
              checkColor: Colors.yellow,
              onChanged: processing
                  ? null
                  : (bool? newValue) async {
                      isProcessing.value = true;

                      await Future.delayed(const Duration(microseconds: 1000));

                      final oldItems = _appController.todoItemsEmitter.value;

                      final updatedItems = oldItems.map((todoItem) {
                        if (todoItem.title == item.title &&
                            todoItem.description == item.description) {
                          return TodoItem(
                            title: todoItem.title,
                            description: todoItem.description,
                            isDone: newValue ?? false,
                          );
                        }
                        return todoItem;
                      }).toList();

                      _appController.todoItemsEmitter.value = updatedItems;

                      isProcessing.value = false;
                    },
            ),
            title: Text(item.title),
            subtitle: Text(item.description ?? ''),
          );
        });
  }
}
