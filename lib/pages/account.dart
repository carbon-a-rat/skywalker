import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';
import 'package:skywalker/pages/login_page.dart';
import 'package:skywalker/server/pocketbase_controller.dart';
import 'package:skywalker/services.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _Accountpage();
}

class _Accountpage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    var pbc = getIt<PocketbaseController>();

    if (pbc.loggedIn == false) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              padbig(Text("Please login to access the launchers.")),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(title: "Login"),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      );
    }

    var user = pbc.current_user()!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.account_box, size: 100),
          Text('Account', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          padbig(
            Card.filled(
              elevation: 2.0,
              child: padbig(
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person, size: 40),
                        SizedBox(width: 10),
                        Text('Username: ', style: TextStyle(fontSize: 20)),
                        Text(user.name, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.email, size: 40),
                        SizedBox(width: 10),
                        Text('Email: ', style: TextStyle(fontSize: 20)),
                        Text(user.email, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 10),
                    pady(
                      FilledButton(
                        onPressed: () {
                          pbc.logout().then((value) {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const LoginPage(title: "Login"),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            }
                          });
                        },
                        child: Text('Logout', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
