import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jollyfish/app_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/firebase_options.dart';
import 'package:jollyfish/navigation_menu.dart';
import 'package:jollyfish/pages/cart/cart_page.dart';
import 'package:jollyfish/pages/home/home_page.dart';
import 'package:jollyfish/pages/home/product_page.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/pages/notification/notification_page.dart';
import 'package:jollyfish/pages/profile/main_profile_page.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/profile_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

GoRouter router = GoRouter(
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
            path: "/home",
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: "/product",
                builder: (context, state) => ProductPage(),
              ),
            ]),
        GoRoute(
          path: "/cart",
          builder: (context, state) => const CartPage(),
          routes: [
            GoRoute(
              path: "/checkout",
              builder: (context, state) => Container(),
            ),
          ],
        ),
        GoRoute(
          path: "/notification",
          builder: (context, state) => const NotificationPage(),
        ),
        GoRoute(
          path: "/mainprofile",
          builder: (context, state) => const MainProfilePage(),
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => Container(),
            ),
            GoRoute(
              path: "/orders",
              builder: (context, state) => Container(),
            ),
            GoRoute(
              path: "/password",
              builder: (context, state) => Container(),
            ),
            GoRoute(
              path: "/report",
              builder: (context, state) => Container(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      scaffoldMessengerKey: Utilities.messengerKey,
      debugShowCheckedModeBanner: false,
      title: "JollyFish",
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          buttonColor: accentColor,
        ),
        colorScheme: ColorScheme.light(
          primary: accentColor,
        ),
        primaryColorLight: accentColor,
        primaryColor: accentColor,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FB),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Color.fromARGB(255, 255, 242, 216),
          iconTheme:
              MaterialStatePropertyAll(IconThemeData(color: accentColor)),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: accentColor),
          ),
        ),
      ),
    );
  }
}

/*
return CupertinoApp(
      theme: CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFFFFA800),
          scaffoldBackgroundColor: Color(0xFFF8F9FB)),
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          border: Border(
            top: BorderSide(
              color: Colors.transparent,
            ),
          ),
          backgroundColor: Color(0xFFFFFFFF),
          inactiveColor: Color.fromARGB(255, 133, 133, 133),
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.cart_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_fill),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            builder: (context) {
              switch (index) {
                case 0:
                  return const MainPage();
                case 1:
                  return const MainPage();
                default:
                  return Center(
                    child: Icon(index == 0
                        ? CupertinoIcons.gear
                        : CupertinoIcons.search),
                  );
              }
            },
          );
        },
      ),
    );
*/
