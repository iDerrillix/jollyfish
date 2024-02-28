import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/admin/admin_navigation_menu.dart';
import 'package:jollyfish/admin/pages/concerns/concern_details_page.dart';
import 'package:jollyfish/admin/pages/concerns/concerns_page.dart';
import 'package:jollyfish/admin/pages/dashboard_page.dart';
import 'package:jollyfish/admin/pages/deliveries/deliveries_page.dart';
import 'package:jollyfish/admin/pages/deliveries/delivery_Details_page.dart';
import 'package:jollyfish/admin/pages/orders/orders_details.dart';
import 'package:jollyfish/admin/pages/orders/orders_page.dart';
import 'package:jollyfish/admin/pages/products/ProductsCRUD.dart';
import 'package:jollyfish/admin/pages/products/category_details_page.dart';
import 'package:jollyfish/admin/pages/products/products_page.dart';
import 'package:jollyfish/navigation_menu.dart';
import 'package:jollyfish/pages/cart/cart_page.dart';
import 'package:jollyfish/pages/checkout/checkout_page.dart';
import 'package:jollyfish/pages/checkout/order_placed_page.dart';
import 'package:jollyfish/pages/forgot_password_page.dart';
import 'package:jollyfish/pages/home/home_page.dart';
import 'package:jollyfish/pages/home/product_page.dart';
import 'package:jollyfish/pages/login_page.dart';
import 'package:jollyfish/pages/notification/notification_page.dart';
import 'package:jollyfish/pages/profile/change-password/change_password_page.dart';
import 'package:jollyfish/pages/profile/main_profile_page.dart';
import 'package:jollyfish/pages/profile/orders/order_details_page.dart';
import 'package:jollyfish/pages/profile/orders/orders_page.dart';
import 'package:jollyfish/pages/profile/orders/review_page.dart';
import 'package:jollyfish/pages/profile/report-page/report_page.dart';
import 'package:jollyfish/pages/profile/update-profile/update_profile_page.dart';
import 'package:jollyfish/pages/signup_page.dart';
import 'package:jollyfish/utilities.dart';

class AppRouter {
  AppRouter._();

  static String initR = "/home";

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: "shellHome");
  static final _rootNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: "shellCart");
  static final _rootNavigatorNotif =
      GlobalKey<NavigatorState>(debugLabel: "shellNotif");
  static final _rootNavigatorProfile =
      GlobalKey<NavigatorState>(debugLabel: "shellProfile");

  static final _rootNavigatorDashboard =
      GlobalKey<NavigatorState>(debugLabel: "shellDashboard");
  static final _rootNavigatorProducts =
      GlobalKey<NavigatorState>(debugLabel: "shellProducts");
  static final _rootNavigatorOrders =
      GlobalKey<NavigatorState>(debugLabel: "shellOrders");
  static final _rootNavigatorDeliveries =
      GlobalKey<NavigatorState>(debugLabel: "shellDeliveries");
  static final _rootNavigatorConcerns =
      GlobalKey<NavigatorState>(debugLabel: "shellConcerns");

  static final GoRouter router = GoRouter(
    initialLocation: initR,
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final currentUser = _auth.currentUser;

      // If user is not logged in and trying to access a route other than login or signup, redirect to login page
      if (currentUser == null &&
          state.uri.path != '/login' &&
          state.uri.path != '/signup') {
        return '/login'; // Redirect to login page
      } // No redirect
    },
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
                    path: "product/:product_id",
                    name: "Product",
                    builder: (context, state) => ProductPage(
                      key: state.pageKey,
                      product_id: state.pathParameters['product_id'] ?? '',
                    ),
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
                    routes: [
                      GoRoute(
                        path: "orderplaced",
                        name: "Order Placed",
                        builder: (context, state) => OrderPlacedPage(
                          key: state.pageKey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: "/cart/:reload",
                builder: (context, state) {
                  final String reloadParam =
                      state.pathParameters['reload'] ?? '';
                  final bool reload = reloadParam.toLowerCase() == 'true';
                  return CartPage(
                    reload: reload,
                    key: state.pageKey,
                  );
                },
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
                        path: 'order-details/:id',
                        name: 'Order Details',
                        builder: (context, state) => OrderDetailsPage(
                          key: state.pageKey,
                          order_id: state.pathParameters['id'] ?? '',
                        ),
                        routes: [
                          GoRoute(
                            path: "review/:id",
                            name: "Leave a Review",
                            builder: (context, state) => ReviewPage(
                              order_id: state.pathParameters['id'] ?? '',
                            ),
                          ),
                        ],
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
                  GoRoute(
                    path: 'report/:id',
                    name: 'Report with ID',
                    builder: (context, state) => ReportPage(
                      orderNo: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        builder: (context, state, newnavigationShell) {
          return NavigationMenu(
            navigationShell: newnavigationShell,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _rootNavigatorDashboard,
            routes: [
              GoRoute(
                path: '/dashboard',
                name: "Dashboard",
                builder: (context, state) {
                  return DashboardPage(
                    key: state.pageKey,
                  );
                },
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorProducts,
            routes: [
              GoRoute(
                path: '/products',
                name: "Products",
                builder: (context, state) {
                  return ProductsPage();
                },
                routes: [
                  GoRoute(
                    path: "edit/:id",
                    name: "Edit Product",
                    builder: (context, state) => ProductsCRUD(
                      product_id: state.pathParameters['id'] ?? '',
                    ),
                  ),
                  GoRoute(
                    path: 'category/:id',
                    name: "Edit Category",
                    builder: (context, state) => CategoryDetailsPage(
                      category_id: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorOrders,
            routes: [
              GoRoute(
                path: '/orders',
                name: "Oncoming Orders",
                builder: (context, state) {
                  return AdminOrdersPage();
                },
                routes: [
                  GoRoute(
                    path: 'details/:id',
                    builder: (context, state) => OrdersDetails(
                      order_id: state.pathParameters['id'] ?? '',
                    ),
                  ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorDeliveries,
            routes: [
              GoRoute(
                  path: '/deliveries',
                  name: "Deliveries",
                  builder: (context, state) {
                    return DeliveriesPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'details/:id',
                      builder: (context, state) => DeliveryDetailsPage(
                        delivery_id: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ])
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rootNavigatorConcerns,
            routes: [
              GoRoute(
                  path: '/concerns',
                  name: "Concerns",
                  builder: (context, state) {
                    return ConcernsPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'details/:id',
                      builder: (context, state) => ConcernDetailsPage(
                        concern_id: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ])
            ],
          )
        ],
        builder: (context, state, navigationShell) {
          return AdminNavigationMenu(navigationShell: navigationShell);
        },
      )
    ],
  );
}
