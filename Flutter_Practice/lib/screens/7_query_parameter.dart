import 'package:flutter/material.dart';
import 'package:go_route_prac/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class QueryParameterScreen extends StatelessWidget {
  const QueryParameterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      body: ListView(
        children: [
          Text('Query parameters : ${GoRouterState.of(context).uri.queryParameters}'),
          //query-parameter? utm = google
          ElevatedButton(onPressed: () {
            context.push(
              Uri(
                path: '/query_param',
                queryParameters: {
                  'name' : 'code',
                  'age' : '32'
                }
              ).toString(),
            );
          }, child: Text('Query Parameters')),
        ],
      ),
    );
  }
}
