import 'package:flutter/material.dart';
import 'package:jamal_v1/widgets/navigation_menu.dart';

class LocalSettings extends StatefulWidget {
  @override
  _LocalSettingsState createState() => _LocalSettingsState();
}

class _LocalSettingsState extends State<LocalSettings> {
  final List<String> settingTitles = [
    "Privacy",
    "Profile",
    "Notifications",
    "Storage",
    "FAQs",
    "Invite friends",
    "App theme",
    "Log out"
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: NavigationDrawerWidget(),
      body: Stack(children: [
        SizedBox(
          child: Image.asset("assets/bg.jpg"),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.height * 0.1,
                ),
                Text(
                  // insert user's name here
                  "Settings",
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headline4
                  //     .copyWith(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 30),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: MaterialButton(
                //     color: Colors.lightBlue,
                //     onPressed: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => UserProfilePage(),
                //       ));
                //     },
                //     child: Text("View profile"),
                //   ),
                // ),
                Column(
                  children: [
                    for (final title in settingTitles)
                      TextButton(
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //padding: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    )),
                                // decoration: BoxDecoration(
                                //   color: Colors.grey[200],
                                //   border: Border.all(
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ),
                              Icon(IconData(61068,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true))
                            ]),
                      ),
                  ],
                ),
              ],
            )),
      ]),
    );
  }
}