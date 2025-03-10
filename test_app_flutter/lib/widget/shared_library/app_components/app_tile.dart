import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_button.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_confirmation_bottom_sheet.dart';

class AppTile {
  final List<Widget> preIconWidgets;
  final IconData? iconData;
  final String? iconText;
  final List<String> pretitleTexts;
  final String? titleText;
  final List<String> subtitleTexts;
  final bool isThreeLines;
  final EdgeInsets? padding;
  final EdgeInsets? extraPadding;
  final Icon? preIcon;
  final bool? showPreIcon;
  final double? opacity;
  final Future<void> Function(BuildContext)? onPressed;
  final bool isEnabled;
  final List<AppAction> startActions;
  final List<AppAction> endActions;
  final List<AppButton> endButtons;
  final List<Widget> endWidgets;
  final bool? expandToFullWidth;

  const AppTile({
    this.preIconWidgets = const [],
    this.iconData,
    this.iconText,
    this.pretitleTexts = const [],
    this.titleText,
    this.subtitleTexts = const [],
    this.isThreeLines = false,
    this.padding,
    this.extraPadding,
    this.preIcon,
    this.showPreIcon,
    this.opacity,
    this.onPressed,
    this.isEnabled = true,
    this.startActions = const [],
    this.endActions = const [],
    this.endButtons = const [],
    this.endWidgets = const [],
    this.expandToFullWidth,
  });

  AppTile copyWith({List<AppAction>? endActions}) {
    return AppTile(
      iconData: iconData,
      titleText: titleText,
      subtitleTexts: subtitleTexts,
      isThreeLines: isThreeLines,
      padding: padding,
      extraPadding: extraPadding,
      preIcon: preIcon,
      showPreIcon: showPreIcon,
      opacity: opacity,
      onPressed: onPressed,
      isEnabled: isEnabled,
      startActions: startActions,
      endActions: endActions ?? this.endActions,
      endButtons: endButtons,
    );
  }

  AppTileWidget build() => AppTileWidget(config: this);
}

class AppTileWidget extends StatelessWidget {
  final AppTile config;
  const AppTileWidget({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return _slidable(context);
  }

  Widget _slidable(BuildContext context) {
    final inkWell = _inkWell(context);

    if (config.startActions.isEmpty && config.endActions.isEmpty) {
      return inkWell;
    }

    return ClipRect(child: inkWell);
  }

  Future<void> _onSlidableActionPressed(BuildContext context, AppAction appAction) async {
    await showAppModalBottomSheet(context, appAction);
  }

  Widget _inkWell(BuildContext context) {
    final tile = _tile(context);

    if (config.onPressed == null || !config.isEnabled) {
      return tile;
    }

    return InkWell(
      onTap: () => config.onPressed!(context),
      child: tile,
    );
  }

  Widget _tile(BuildContext context) {
    final preLeading = config.preIcon != null
        ? SizedBox(
            width: 24,
            child: config.showPreIcon == true ? config.preIcon : SizedBox(),
          )
        : null;

    final leadingWidgets = [
      if (config.iconData != null) Icon(config.iconData),
      if (config.iconText != null) Text(config.iconText!, style: Theme.of(context).textTheme.labelSmall),
    ];

    final leading = leadingWidgets.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: leadingWidgets,
          )
        : null;

    final pretitle = config.pretitleTexts.isNotEmpty
        ? Text(
            config.pretitleTexts.join('\n'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          )
        : null;

    final title = config.titleText != null
        ? Text(
            config.titleText!,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
          )
        : null;

    final subtitle = config.subtitleTexts.isNotEmpty
        ? Text(
            config.subtitleTexts.join('\n'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          )
        : null;

    final trailingWidgets = <Widget>[];

    if (config.endButtons.isNotEmpty) {
      trailingWidgets.addAll(config.endButtons.map((b) => b.build()));
    }

    if (config.endWidgets.isNotEmpty) {
      trailingWidgets.addAll(config.endWidgets);
    }

    if (config.onPressed != null) {
      trailingWidgets.add(SizedBox(
        width: 24,
        child: config.isEnabled ? Icon(Icons.chevron_right) : SizedBox(),
      ));
    }

    final trailing = trailingWidgets.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(8),
              ...trailingWidgets,
              Gap(8),
            ],
          )
        : null;

    final tileWithPadding = Padding(
      padding: EdgeInsets.only(
        left: config.padding?.left ?? 8 + (config.extraPadding?.left ?? 0),
        top: config.padding?.top ?? 4 + (config.extraPadding?.top ?? 0),
        right: config.padding?.right ?? 4 + (config.extraPadding?.right ?? 0),
        bottom: config.padding?.bottom ?? 8 + (config.extraPadding?.bottom ?? 0),
      ),
      child: Row(
        crossAxisAlignment: config.isThreeLines ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisSize: (config.expandToFullWidth ?? true) ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (config.preIconWidgets.isNotEmpty) Gap(8),
          if (config.preIconWidgets.isNotEmpty) ...config.preIconWidgets,
          if (preLeading != null) Gap(8),
          if (preLeading != null) preLeading,
          if (leading != null) Gap(8),
          if (leading != null) leading,
          if (leading != null) Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pretitle != null) pretitle,
                if (title != null) title,
                if (subtitle != null) subtitle,
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );

    return config.opacity != null
        ? Opacity(
            opacity: config.opacity!,
            child: tileWithPadding,
          )
        : tileWithPadding;
  }
}
