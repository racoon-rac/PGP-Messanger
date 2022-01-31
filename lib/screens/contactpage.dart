import 'package:flutter/material.dart';
import 'package:pgpmessanger/classes/widget/class_widget_contactlist.dart';
import 'package:pgpmessanger/classes/widget/mybottomnavigationbar.dart';
import 'package:pgpmessanger/screens/qrscanpage.dart';

import 'contactadd.dart';

class ContactPage extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  const ContactPage({Key? key, required this.routeObserver}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> implements RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ContactAddPage()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: ContactList(key: UniqueKey())),
      bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: 1,
          onTap: (int value) {
            if (value == 0) {
              Navigator.pop(context);
            }
          }),

    );
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
}
