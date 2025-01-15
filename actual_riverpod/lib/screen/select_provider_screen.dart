import 'package:actual_riverpod/layout/default_layout.dart';
import 'package:actual_riverpod/riverpod/select_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectProviderScreen extends ConsumerWidget {
  const SelectProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build');
    final state = ref.watch(selectProvider.select((value) => value.isSpicy)); //isSpicy 값에만 관심이 있다고 select를 통해서 선언함.
    ref.listen(selectProvider.select((value) => value.hasBought), (previous,next) {
      print('next : $next');
    });
    return DefaultLayout(
      title: 'SelectProviderScreen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(state.name),
            // Text(state.quantity.toString()),
            // Text(state.hasBought.toString()),
            // Text(state.isSpicy.toString()),
            Text(state.toString()),
            ElevatedButton(
              onPressed: (){
                ref.read(selectProvider.notifier).toggleIsSpicy();
              },
              child: Text('spicyToggle'),
            ),
            ElevatedButton(
              onPressed: (){
                ref.read(selectProvider.notifier).toggleHasBought();
              },
              child: Text('hasBoughtToggle'),
            ),
          ],
        ),
      ),
    );
  }
}
