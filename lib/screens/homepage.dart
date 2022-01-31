import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/exceptions.dart';
import 'package:pgpmessanger/classes/sqlite/class_mypgptable.dart';
import 'package:pgpmessanger/classes/widget/mybottomnavigationbar.dart';
import 'package:pgpmessanger/classes/widget/widget_homebutton.dart';
import 'package:pgpmessanger/screens/initpage.dart';
import 'package:pgpmessanger/screens/userpage.dart';

class HomePage extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;

  const HomePage({Key? key, required this.routeObserver}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements RouteAware {
  String? nickname;
  String? pubkey;
  String? uid;

  void userRegistration() async {
    try {
      uid = await MyPGPTable().getUid();
      /*
      if (!(await FS_UserManager().isThereUser(uid!))) {
        print('User Not found in firestore.');
      } else {
        nickname = await MyPGPTable().getNickname();
      }*/
      nickname = await MyPGPTable().getNickname();
      setState(() {});
    } on DBColumnNotFoundException catch (e) {
      debugPrint(e.toString());
      debugPrint('User Not found in SQLite.');
      Future.microtask(() => Navigator.push(
            context,
            MaterialPageRoute(
            builder: (BuildContext context) => const InitPage(),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    userRegistration();

    return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          // Main Contents
          child: Column(children: [
            // Menu of User Information
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              // Menu of user information
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Menu title
                    Container(
                      child: const Text('User',
                          style: TextStyle(fontSize: 24, fontFamily: 'Roboto')),
                      decoration: const BoxDecoration(
                          border:
                              Border(right: BorderSide(color: Colors.black38))),
                      alignment: Alignment.center,
                      width: 100,
                    ),
                    // Menu objects
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (nickname is String)
                          HomeButton(
                              text: nickname!,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const UserPage()));
                              })
                        else
                          HomeButton(text: 'Loading...', onPressed: () {}),
                        HomeButton(
                          text: 'Manage',
                          onPressed: () {},
                          rightSideIcon: const Icon(Icons.settings_sharp),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
            // Menu of PGP Information
            /*Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),

              // Menu of PGP
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: const Text('PGP',
                          style: TextStyle(fontSize: 24, fontFamily: 'Roboto')),
                      decoration: const BoxDecoration(
                          border:
                              Border(right: BorderSide(color: Colors.black38))),
                      alignment: Alignment.center,
                      width: 100,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeButton(
                              text: 'Regenerate key',
                              rightSideIcon: const Icon(Icons.vpn_key),
                              onPressed: () {
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),*/
          ]),
        ),
        bottomNavigationBar: MyBottomNavigationBar(
            currentIndex: 0,
            onTap: (int value) async {
              if (value == 1) {
                Navigator.pushNamed(context, '/contact');
              }
            }));
  }

  // Start RouteAware //
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {
    setState(() {});
  }

  @override
  void didPush() {
    setState(() {});
  }

  @override
  void didPushNext() {}
// End RouteAware //
}
