import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/basic');
            },
            child: Text('Go Basic Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed('named_screen');
            },
            child: Text('Go Named Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/push');
            },
            child: Text('Go Push Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/pop');
            },
            child: Text('Go Pop Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/path_param/456');
            },
            child: Text('Go Path_Param Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/query_param');
            },
            child: Text('Go Query_Param Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/nested/a');
            },
            child: Text('Go Nested'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login');
            },
            child: Text('Go Login Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login2');
            },
            child: Text('Go Login2 Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/transition');
            },
            child: Text('Go Transition Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/error');
            },
            child: Text('Go Error Screen'),
          ),

        ],
      ),
    );
  }
}
