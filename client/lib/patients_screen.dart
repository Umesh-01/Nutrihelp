import 'package:client/models/patient_list_object_model.dart';
import 'package:client/resources/api_provider.dart';
import 'package:client/resources/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key key}) : super(key: key);

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  dynamic patients;
  bool _loading = true;

  void fetchpatients() async {
    final localStorage = await SharedPreferences.getInstance();
    final userid = localStorage.getString('userId');
    final url = Uri.parse("https://nutrihelpb.herokuapp.com/patients/$userid");

    final res = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
        patients = parsePatients(res.body);
      });
    }
    return null;
  }

  @override
  void initState() {
    fetchpatients();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    SizedBox hsb(val) => SizedBox(height: deviceHeight * val);
    return template(
        body: ListView(children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Container(
              width: deviceWidth * 0.8,
              child: Text(
                'Patients ',
                style: GoogleFonts.poppins(fontSize: deviceWidth * 0.1),
              ),
            ),
          )
        ],
      ),
      _loading
          ? Container(
              width: 200,
              height: 200,
              child: const Center(child: CircularProgressIndicator()))
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patients[index].name,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              hsb(0.01),
                              Row(
                                children: [
                                  Text(patients[index].gender == "M"
                                      ? "Male  "
                                      : "Female  "),
                                  const Icon(
                                    Icons.circle,
                                    size: 6,
                                  ),
                                  Text(
                                      "  ${patients[index].age.toString()} Yrs."),
                                ],
                              ),
                              hsb(0.01),
                              Container(
                                width: deviceWidth * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'generate report',
                                          style: TextStyle(
                                              color: Color(0xff05483f)),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          deletePatient(
                                              context, patients[index].id);
                                        },
                                        child: const Text(
                                          'delete',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    ]));
  }
}
