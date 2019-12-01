import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Exit extends StatefulWidget {
  @override
  _ExitState createState() => _ExitState();
}

class _ExitState extends State<Exit> {
  String entryID, vname, vemail, vphone, hname, hemail, hphone;
  String entry, exit;
  //QRViewController _controller;
  GlobalKey _qrkey = new GlobalKey(debugLabel: 'QR');
  bool gotEntryID = false, entryGranted = false;
  Future<void> getDetails() async {
    Firestore.instance
        .collection('entries')
        .where("entry_id", isEqualTo: int.parse(entryID))
        .snapshots()
        .listen((d) {
      DocumentSnapshot s = d.documents.first;
      vname = s["visitor_name"];
      vemail = s["visitor_email"];
      vphone = s["visitor_phone"];
      hname = s["host_name"];
      hemail = s["host_email"];
      hphone = s["host_phone"];
      entry = s['entry_time'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            gotEntryID
                ? SizedBox()
                : Center(
                    child: RaisedButton(
                      child: Text("Scan Entry QR Code"),
                      onPressed: () async {
                        entryID = await BarcodeScanner.scan();
                        try {
                          if (entryID != null && int.parse(entryID) > 0) {
                            gotEntryID = true;
                            await getDetails();
                            setState(() {});
                          }
                        } catch (e) {
                          print("Sorry invalid qr found");
                          Fluttertoast.showToast(
                              msg: "Sorry Invalid QR Recognised!!!");
                        }
                      },
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            /* Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("Enter Entry ID: "),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (res) {
                      return null;
                    },
                    decoration: InputDecoration(hintText: "Entry ID"),
                    onChanged: (res) {
                      entryID = res;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        try {
                          if (entryID != null && int.parse(entryID) > 0)
                            gotEntryID = true;
                        } catch (e) {
                          print("Sorry invalid qr found");
                        }
                      });
                    },
                  ),
                )
              ],
            ), */
            gotEntryID
                ? Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Visitor Details:",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Name : $vname",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "$vemail",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "$vphone",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Host Details:",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Name : $hname",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "$hemail",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "$hphone",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            gotEntryID && !entryGranted
                ? RaisedButton(
                    child: Text("Grant Entry"),
                    onPressed: () {
                      setState(() {
                        entryGranted = true;
                        exit = DateTime.now()
                            .toIso8601String()
                            .substring(0, 19)
                            .replaceAll("T", "  ");
                      });
                    },
                  )
                : SizedBox(),
            entryGranted
                ? Text(
                    "Entry Granted!!!!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            entryGranted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Send Email to Visitor"),
                        onPressed: () async {
                          var email = Email(
                            recipients: ["$vemail"],
                            subject: "Last Entry to Innovaccer",
                            body:
                                "Dear ${vname.toUpperCase()}\n Details of the last entry to Innovaccer are as below: \nName: ${vname.toUpperCase()}\nPhone: $vphone\nCheck-in time: $entry\nCheck-out time: $exit\nHost name: ${hname.toUpperCase()}\nAddress Visited: Innovaccer",
                          );
                          await FlutterEmailSender.send(email);
                        },
                      ),
                      /* SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        child: Text("Send SMS to Host"),
                        onPressed: () async {
                          await FlutterSms.sendSMS(
                            message:
                                "Hello $hname\n A person with the name $vname is coming to meet you.\nThank You",
                            recipients: [hphone],
                          );
                        },
                      ) */
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
