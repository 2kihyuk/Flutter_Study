import 'package:flutter/cupertino.dart';
import 'package:go_route_prac/screens/10_transition_screen_1.dart';
import 'package:go_route_prac/screens/10_transition_screen_2.dart';
import 'package:go_route_prac/screens/11_error_screen.dart';
import 'package:go_route_prac/screens/1_basic_screen.dart';
import 'package:go_route_prac/screens/2_Named_Screen.dart';
import 'package:go_route_prac/screens/3_push_screen.dart';
import 'package:go_route_prac/screens/4_pop_base_screen.dart';
import 'package:go_route_prac/screens/5_pop_return_screen.dart';
import 'package:go_route_prac/screens/6_path_params_screen.dart';
import 'package:go_route_prac/screens/7_query_parameter.dart';
import 'package:go_route_prac/screens/8_nested_child_screen.dart';
import 'package:go_route_prac/screens/8_nested_screen.dart';
import 'package:go_route_prac/screens/9_login_screen.dart';
import 'package:go_route_prac/screens/9_private_screen.dart';
import 'package:go_route_prac/screens/root_screen.dart';
import 'package:go_router/go_router.dart';

//로그인이 되었는지 안되었는지에 대한 변수.
bool authState = false;

final router = GoRouter(
  //모든 라우터에 다 적용이 됨. redirect는.
  redirect: (context, state) {
    if (state.matchedLocation == '/login/private' && !authState) {
      return '/login';
    }
    return null; //원래 이동하려던 라우트로 이동.
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return RootScreen();
      },
      routes: [
        GoRoute(
          path: '/basic',
          builder: (context, state) {
            return BasicScreen();
          },
        ),
        GoRoute(
          path: '/named',
          name: 'named_screen',
          builder: (context, state) {
            return NamedScreen();
          },
        ),
        GoRoute(
          path: '/push',
          builder: (context, state) {
            return PushScreen();
          },
        ),
        GoRoute(
          path: '/pop',
          builder: (context, state) {
            return PopBaseScreen();
          },
          routes: [
            //pop/return
            GoRoute(
              path: '/return',
              builder: (context, state) {
                return PopReturnScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/path_param/:id',
          builder: (context, state) {
            return PathParamScreen();
          },
          routes: [
            GoRoute(
              path: ':name',
              builder: (context, state) {
                return PathParamScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/query_param',
          builder: (context, state) {
            return QueryParameterScreen();
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            return NestedScreen(child: child);
          },
          routes: [
            GoRoute(
              path: 'nested/a',
              builder: (_, state) => NestedChildScreen(routeName: 'nested/a'),
            ),
            GoRoute(
              path: 'nested/b',
              builder: (_, state) => NestedChildScreen(routeName: 'nested/b'),
            ),
            GoRoute(
              path: 'nested/c',
              builder: (_, state) => NestedChildScreen(routeName: 'nested/c'),
            ),
          ],
        ),
        GoRoute(
          path: 'login',
          builder: (_, state) {
            return LoginScreen();
          },
          routes: [
            GoRoute(path: 'private', builder: (_, state) => PrivateScreen()),
          ],
        ),

        GoRoute(
          path: 'login2',
          builder: (_, state) {
            return LoginScreen();
          },
          routes: [
            GoRoute(
              path: 'private',
              builder: (_, state) => PrivateScreen(),
              redirect: (context, state) {
                if (!authState) {
                  return '/login2';
                }
                return null;
              },
            ),
          ],
        ),

        GoRoute(
          path: '/transition',
          builder: (context, state) {
            return TransitionScreenOne();
          },
          routes: [
            GoRoute(
              path: 'detail',
              pageBuilder:
                  (_, state) => CustomTransitionPage(
                    transitionDuration: Duration(seconds: 3),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: TransitionScreenTwo(),
                  ),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context,state) => ErrorScreen(Error: state.error.toString()),
  debugLogDiagnostics: true, //고라우터들의 행동들에 대해서 로그가 찍히게 하는 기능
);
