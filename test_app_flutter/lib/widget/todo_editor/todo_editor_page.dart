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
import 'package:test_app_flutter/widget/todo_editor/todo_add_page.dart';

class TodoEditorPage extends StatefulWidget {
  const TodoEditorPage({super.key});

  @override
  State<TodoEditorPage> createState() => _TodoEditorPageState();
}

class _TodoEditorPageState extends State<TodoEditorPage> {
  late final _appController = GetIt.instance<AppController>();
  final Map<TodoItem, bool> _checkCompletionStates = {};

  get _appPage => AppPage(
        scaffold: AppScaffold(
            titleText: 'TODO Editor',
            floatingAction: AppItemAction<BuildContext>(
                label: AppLabel(iconData: Icons.add, text: 'Add Item'),
                onPressed: (_) async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => TodoAddPage()));
                },
                isBlocking: false)),
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
                  filter: (item) => !item.isDone,
                  builder: _itemBuilder,
                  showCount: false),
              ListItemGroup<TodoItem>(
                  titleText: 'Completed',
                  filter: (item) => item.isDone,
                  builder: _itemBuilder,
                  showCount: true),
            ],
          )
        ],
      );

  void _checkCompletion(TodoItem item) async {
    setState(() {
      _checkCompletionStates[item] =
          true; // set item check completion to disable checkbox
    });

    await Future.delayed(Duration(seconds: 1)); // delay 1s

    final todoListUpdate =
        _appController.todoItemsEmitter.value.map((todoItem) {
      if (todoItem == item) {
        return TodoItem(
          title: todoItem.title,
          description: todoItem.description,
          isDone: !todoItem.isDone,
        );
      }
      return todoItem;
    }).toList();

    _appController.todoItemsEmitter.value = todoListUpdate;

    setState(() {
      _checkCompletionStates[item] = false; // enable checkbox
    });
  }

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
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description ?? ''),
      leading: Checkbox(
          value: item.isDone,
          onChanged: _checkCompletionStates[item] == true
              ? null
              : (_) => _checkCompletion(item)),
    );
  }
}
