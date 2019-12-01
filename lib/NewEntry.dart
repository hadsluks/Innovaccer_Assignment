import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sms/flutter_sms.dart';

class NewEntry extends StatefulWidget {
  NewEntry({Key key}) : super(key: key);

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  String vname, vemail, vphone, hname, hemail, hphone;
  DateTime entry;
  int entryID;
  QrImage image;
  GlobalKey _repaintKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  RepaintBoundary rp;
  bool entryGenerated = false, generatingEntry = false;
  void capture(RenderRepaintBoundary boundary) async {
    //print(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Stack(
            children: <Widget>[
              entryGenerated
                  ? SizedBox()
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text("Visitor Name:"),
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Visitor Name";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                  ),
                                  onChanged: (String s) {
                                    vname = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Visitor E-Mail:"),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Visitor Email";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  onChanged: (String s) {
                                    vemail = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Visitor Phone:"),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Visitor Phone";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Phone",
                                  ),
                                  onChanged: (String s) {
                                    vphone = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Host Name:"),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Host Name";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                  ),
                                  onChanged: (String s) {
                                    hname = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Host E-Mail:"),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Host Email";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  onChanged: (String s) {
                                    hemail = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Host Phone:"),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  validator: (res) {
                                    if (res.length == 0)
                                      return "Enter Host Phone";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Phone",
                                  ),
                                  onChanged: (String s) {
                                    hphone = s;
                                  },
                                ),
                              )
                            ],
                          ),
                          RaisedButton(
                            child: Text("Generate Entry"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  entryGenerated = true;
                                  generatingEntry = true;
                                });

                                await Firestore.instance
                                    .collection('entries')
                                    .getDocuments()
                                    .then((d) {
                                  entryID = d.documents.length + 1;
                                });
                                setState(() {});
                                entry=DateTime.now();
                                Firestore.instance
                                    .collection('entries')
                                    .document()
                                    .setData({
                                  'entry_id': entryID,
                                  'visitor_name': '$vname',
                                  'visitor_email': '$vemail',
                                  'visitor_phone': '$vphone',
                                  'host_name': '$hname',
                                  'host_email': '$hemail',
                                  'host_phone': '$hphone',
                                  'entry_time' : '${entry.toIso8601String().substring(0,19)}'
                                });
                              }
                              setState(() {
                                generatingEntry = false;
                              });
                              /* final temp=await getTemporaryDirectory();
                 */
                              /* email = Email(
                  recipients: [vemail],
                  subject: "Test Email",
                  body:
                      "Hello $vname\n You have made an entry to Innovaccer at ${DateTime.now().toUtc().toString().substring(0, 19)}\nThank You",
                );
                await FlutterEmailSender.send(email); */
                            },
                          ),
                        ],
                      ),
                    ),
              entryGenerated
                  ? Opacity(
                      opacity: generatingEntry ? 0.2 : 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
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
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          entryID != null
                              ? Text(
                                  "Entry ID : $entryID",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          entryID != null
                              ? Text(
                                  "Entry Recognition QR :",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          entryID != null
                              ? Center(
                                  child: RepaintBoundary(
                                    key: _repaintKey,
                                    child: QrImage(
                                      size: 200.0,
                                      data: entryID.toString(),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              RaisedButton(
                                child: Text("Send Emails"),
                                onPressed: () async {
                                  RenderRepaintBoundary boundary = _repaintKey
                                      .currentContext
                                      .findRenderObject();
                                  ui.Image image = await boundary.toImage();
                                  var pngBytes = (await image.toByteData(
                                          format: ui.ImageByteFormat.png))
                                      .buffer
                                      .asUint8List();
                                  final tempdir = await getTemporaryDirectory();
                                  final file = await new File(
                                          "${tempdir.path}/qr$entryID.png")
                                      .create();
                                  await file.writeAsBytes(pngBytes);

                                  var email = Email(
                                    recipients: ["$vemail"],
                                    subject: "Entry to Innovaccer",
                                    attachmentPath:
                                        tempdir.path + "/qr$entryID.png",
                                    body:
                                        "Dear ${vname.toUpperCase()},\n You have made an Entry to Innovaccer. Your Entry ID is $entryID and your Entry QR Code is attached here. Show the qr code at the time of exit.\n\n Thank You",
                                  );
                                  await FlutterEmailSender.send(email);
                                  email = Email(
                                    recipients: ["$hemail"],
                                    subject: "A visitor asking for you",
                                    body:
                                        "Dear ${hname.toUpperCase()},\n Its been a busy day at work and we have one more visitor for us. \n \n Sending in the details to you!\n\n ${vname.toUpperCase()}, with contact details as \nMobile Number : $vphone\nEmail : $vemail",
                                  );
                                  await FlutterEmailSender.send(email);
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                child: Text("Send SMS"),
                                onPressed: () async {
                                  await FlutterSms.sendSMS(
                                    message:
                                        "Hello ${hname.toUpperCase()}\n A person with the name ${vname.toUpperCase()} is coming to meet you.\nThank You",
                                    recipients: [hphone],
                                  );
                                  await FlutterSms.sendSMS(
                                    message:
                                        "Hello ${vname.toUpperCase()}\n You have entered Innovaccer with Entry ID $entryID",
                                    recipients: [vphone],
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              generatingEntry
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
            ],
          )),
    );
  }
}
