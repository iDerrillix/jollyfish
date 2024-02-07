import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/navigation_menu.dart';
import 'package:jollyfish/pages/cart/cart_page.dart';
import 'package:jollyfish/pages/checkout/checkout_page.dart';
import 'package:jollyfish/pages/forgot_password_page.dart';
import 'package:jollyfish/pages/home/home_page.dart';
import 'package:jollyfish/pages/home/product_page.dart';
import 'package:jollyfish/pages/login_page.dart';
import 'package:jollyfish/pages/notification/notification_page.dart';
import 'package:jollyfish/pages/profile/change-password/change_password_page.dart';
import 'package:jollyfish/pages/profile/main_profile_page.dart';
import 'package:jollyfish/pages/profile/orders/order_details_page.dart';
import 'package:jollyfish/pages/profile/orders/orders_page.dart';
import 'package:jollyfish/pages/profile/report-page/report_page.dart';
import 'package:jollyfish/pages/profile/update-profile/update_profile_page.dart';
import 'package:jollyfish/pages/signup_page.dart';

class AppRouter {
  AppRouter._();

  static String initR = "/login";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: "shellHome");
  static final _rootNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: "shellCart");
  static final _rootNavigatorNotif =
      GlobalKey<NavigatorState>(debugLabel: "shellNotif");
  static final _rootNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: "shellProfile");

  static final GoRouter router = GoRouter(
    initialLocation: initR,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'Signup',
        builder: (context, state) => SignupPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: "Forgot Password",
        builder: (context, state) => ForgotPasswordPage(),
      ),
      StatefulShellRoute.indexedStack(
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _rootNavigatorHome,
            routes: [
              GoRoute(
                path: "/home",
                name: "Home",
                builder: (context, state) => HomePage(
                  key: state.pageKey,
                ),
                routes: [
                  GoRoute(
                    path: "product",
                    name: "Product",
                    builder: (context, state) =>
                        ProductPage(key: state.pageKey),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorCart,
            routes: [
              GoRoute(
                path: "/cart",
                name: "Cart",
                builder: (context, state) => CartPage(
                  key: state.pageKey,
                ),
                routes: [
                  GoRoute(
                    path: "checkout",
                    name: "Checkout",
                    builder: (context, state) => CheckoutPage(
                      key: state.pageKey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorNotif,
            routes: [
              GoRoute(
                path: "/notif",
                name: "Notifications",
                builder: (context, state) => NotificationPage(
                  key: state.pageKey,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorProfile,
            routes: [
              GoRoute(
                path: "/profile",
                name: "Main Profile",
                builder: (context, state) => MainProfilePage(
                  key: state.pageKey,
                ),
                routes: [
                  GoRoute(
                    path: 'update-profile',
                    name: 'Update Profile',
                    builder: (context, state) => UpdateProfilePage(),
                  ),
                  GoRoute(
                    path: "orders",
                    name: "Orders",
                    builder: (context, state) => OrdersPage(
                      key: state.pageKey,
                    ),
                    routes: [
                      GoRoute(
                        path: 'order-details',
                        name: 'Order Details',
                        builder: (context, state) => OrderDetailsPage(
                          key: state.pageKey,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'change-password',
                    name: "Change Password",
                    builder: (context, state) => ChangePasswordPage(),
                  ),
                  GoRoute(
                    path: 'report',
                    name: 'Report',
                    builder: (context, state) => ReportPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) => NavigationMenu(
          navigationShell: navigationShell,
        ),
      ),
    ],
  );
}
