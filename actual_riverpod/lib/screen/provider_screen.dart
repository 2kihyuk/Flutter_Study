import 'package:actual_riverpod/layout/default_layout.dart';
import 'package:actual_riverpod/riverpod/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/state_notifier_provider.dart';

class ProviderScreen extends ConsumerWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(filteredShoppingListProvider);

    return DefaultLayout(
      title: 'ProviderScreen',
      actions: [
        PopupMenuButton<FilterState>(
          itemBuilder: (_) => FilterState.values
              .map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
          onSelected: (value) {
            ref.read(filterProvider.notifier).update((state) => value);
          },
        ),
      ],
      body: ListView(
        children: state
            .map(
              (e) => CheckboxListTile(
                title: Text(e.name),
                value: e.hasBought, //체크박스가 체크되어있는지 아닌지에 대한 값 bool.
                onChanged: (value) {
                  ref
                      .read(shoppingListProvider.notifier)
                      .togglehasBought(name: e.name);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
