import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:jollyfish/constants.dart";
import "package:jollyfish/models/user_model.dart";
import "package:jollyfish/widgets/input_button.dart";
import "package:jollyfish/widgets/notif_item.dart";
import "package:jollyfish/widgets/profile_button.dart";

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({Key? key}) : super(key: key);

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  String? fullName = "";
  String? phoneNo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              color: accentColor,
              height: 350,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(width: 2, color: Colors.white),
                    //     borderRadius: BorderRadius.circular(100),
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(100),
                    //     child: Image.network(
                    //       width: 100,
                    //       height: 100,
                    //       fit: BoxFit.cover,
                    //       "https://pbs.twimg.com/media/EuNNxftXcAE1CyG.jpg",
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Text(
                    //   fullName ?? '',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 18,
                    //   ),
                    // ),
                    // Text(
                    //   phoneNo ?? '',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Account Overview",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ProfileButton(
                  name: "My Profile",
                  icon: Icon(
                    Icons.person,
                    color: Color(0xFF00B4B4),
                  ),
                  iconColor: Color(0xFFDDFFFF),
                  action: () {
                    context.goNamed("Update Profile");
                  },
                ),
                ProfileButton(
                  name: "My Orders",
                  icon: Icon(
                    Icons.shopping_bag,
                    color: Color(0xFF059D00),
                  ),
                  iconColor: Color(0xFFDEFFDD),
                  action: () {
                    context.goNamed("Orders");
                  },
                ),
                ProfileButton(
                  name: "Change Password",
                  icon: Icon(
                    Icons.lock,
                    color: Color(0xFFA3A800),
                  ),
                  iconColor: Color(0xFFFEFFDD),
                  action: () {
                    context.goNamed("Change Password");
                  },
                ),
                ProfileButton(
                  name: "Report A Problem",
                  icon: Icon(
                    Icons.warning,
                    color: Color(0xFFA10000),
                  ),
                  iconColor: Color(0xFFFFDDDD),
                  action: () {
                    context.goNamed("Report");
                  },
                ),
                InputButton(
                  label: "Logout",
                  function: () {
                    FirebaseAuth.instance.signOut();
                    context.goNamed('Login');
                  },
                  large: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.0028244, size.height * 0.8578857,
        size.width * 0.1276336, size.height * 0.8571429);
    path_0.cubicTo(
        size.width * 0.3183715,
        size.height * 0.8571429,
        size.width * 0.6997455,
        size.height * 0.8571429,
        size.width * 0.8905852,
        size.height * 0.8571429);
    path_0.quadraticBezierTo(size.width * 0.9997710, size.height * 0.8599429,
        size.width, size.height);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
