import 'package:flutter/material.dart';

class WrapList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final void Function()? onAdd;

  const WrapList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var (index, item) in items.indexed) _buildItem(context, index, item),
        if (onAdd != null) _buildAdd(context),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index, T item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: itemBuilder(context, index, item),
      ),
    );
  }

  Widget _buildAdd(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: onAdd,
      ),
    );
  }
}

class BasicWrapListItem extends StatelessWidget {
  final Widget item;
  final void Function()? onRemove;

  const BasicWrapListItem({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        item,
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            iconSize: 15,
            icon: const Icon(Icons.close),
          ),
      ],
    );
  }
}
