import 'package:actual_riverpod/layout/default_layout.dart';
import 'package:actual_riverpod/model/shopping_item_model.dart';
import 'package:actual_riverpod/riverpod/state_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateNotifierProviderScreen extends ConsumerWidget {
  const StateNotifierProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ShoppingItemModel> state = ref.watch(shoppingListProvider);

    return DefaultLayout(
      title: 'StateNotifierProvider',
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
