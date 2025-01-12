import 'package:actual_riverpod/layout/default_layout.dart';
import 'package:actual_riverpod/riverpod/state_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'StateProvider Screen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.toString()),
            ElevatedButton(
              onPressed: (){
                ref.read(numberProvider.notifier).update((state) => state+1 );
              },
              child: Text('up'),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => _NextScreen())
                );
              },
              child: Text('NEXT SCreen'),
            )
          ],
        ),
      ),
    );
  }
}


class _NextScreen extends ConsumerWidget {

  const _NextScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(numberProvider);
    return DefaultLayout(
      title: 'StateProvider Screen',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.toString()),
            ElevatedButton(
              onPressed: (){
                ref.read(numberProvider.notifier).update((state) => state+1 );
              },
              child: Text('up'),
            ),
            ElevatedButton(
              onPressed: (){
                ref.read(numberProvider.notifier).state = ref.read(numberProvider.notifier).state-1;
              },
              child: Text('down'),
            ),
          ],
        ),
      ),
    );
  }
}
