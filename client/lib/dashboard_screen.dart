import 'package:client/aboutus_screen.dart';
import 'package:client/add_patient_screen.dart';
import 'package:client/generate_report.dart';
import 'package:client/patients_screen.dart';
import 'package:client/recent_reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tilesTitle = [
      'Add patient',
      'recent reports',
      'patients',
      'generate report',
      'about us',
      'logout'
    ];
    const tilesIcons = [
      Icons.person_add_alt_1,
      Icons.list,
      Icons.view_sidebar,
      Icons.assignment_outlined,
      Icons.person_pin,
      Icons.logout
    ];
    final tilesFunctions = [
      () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddPatientScreen()));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RecentReportsScreen()));
      },
      () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PatientsScreen()));
      },
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GenerateReportScreen()));
      },
      () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
      },
      () async {
        final SharedPreferences isLogin = await SharedPreferences.getInstance();
        isLogin.setBool('login', false);
        isLogin.remove('userId');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    ];

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffA6E97C), Color(0xffF4F4F4)])),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: deviceHeight * 0.35,
                  width: deviceWidth,
                  color: const Color(0xff05483f),
                )),
            Positioned(
              top: deviceHeight * 0.17,
              child: Container(
                  width: deviceWidth * 0.9,
                  child: TextField(
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                      ),
                    ),
                  )),
            ),
            Positioned(
                top: deviceHeight * 0.09,
                child: Text('Health Predictor',
                    style: GoogleFonts.redressed(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: deviceWidth * 0.1)))),
            Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.23,
                ),
                Container(
                  height: deviceHeight * 0.75,
                  width: deviceWidth * 0.9,
                  child: GridView.builder(
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            ((MediaQuery.of(context).size.width) * 4) /
                                (MediaQuery.of(context).size.height) /
                                2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: tilesFunctions[index],
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(tilesIcons[index],
                                      size: deviceWidth * 0.15,
                                      color: const Color(0xff05483f)),
                                  SizedBox(
                                    height: deviceHeight * 0.02,
                                  ),
                                  Text(
                                    tilesTitle[index],
                                    style: TextStyle(
                                        color: const Color(0xff05483f),
                                        fontSize: deviceWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ));
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
