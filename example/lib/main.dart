import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_biometrics/flutter_biometrics.dart';
import 'package:flutter_biometrics/constants/algorithm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _publicKey = 'Not retrieved/Not set';
  String _signature = 'Unknown';
  String _payload = 'Zmx1dHRlcl9iaW9tZXRyaWNz';
  String _algorithm = Algorithm.ecdsa;

  @override
  void initState() {
    super.initState();
  }

  Future<void> createKeys() async {
    try {
      var biometrics = FlutterBiometrics();
      String publicKey = await biometrics.createKeys(
        reason: 'Please authenticate to create public/private key pair',
        algorithm: _algorithm,
      );

      print("------------> ${publicKey}");

      setState(() {
        _publicKey = publicKey;
      });

      if (!mounted) return;
    } catch (e) {
      print("error -----> ${e.toString()}");
    }
  }

  Future<void> sign() async {
    try {
      var biometrics = FlutterBiometrics();
      String signature = await biometrics.sign(
        payload: _payload,
        reason: 'Please authenticate to sign specified payload',
        algorithm: _algorithm,
      );

      print("------------> ${signature}");

      setState(() {
        _signature = signature;
      });

      if (!mounted) return;
    } catch (e) {
      print("error -----> $e");
      if (e is PlatformException) {
        print("error -----> ${e.code}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter biometrics with cryptography'),
          backgroundColor: Colors.blueGrey,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.center,
              child: Text(
                "1. Select a algorithm",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('ECDSA'),
                      value: Algorithm.ecdsa,
                      groupValue: _algorithm,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _algorithm = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('RSA'),
                      value: Algorithm.rsa,
                      groupValue: _algorithm,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _algorithm = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.center,
              child: Text(
                "2. Generate a key pair",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20.0),
              child: OutlinedButton(
                onPressed: createKeys,
                child: Text("Create keys"),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Public key: $_publicKey",
                style: TextStyle(color: Colors.white),
              ),
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.blueGrey,
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
              alignment: Alignment.center,
              child: Text(
                "3. Provide a payload to sign",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Payload to sign (Base64 encoded)',
                  hintText: 'Zmx1dHRlcl9iaW9tZXRyaWNz',
                ),
                onChanged: (value) {
                  setState(() {
                    _payload = value;
                  });
                },
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: sign,
                child: Text("Sign '$_payload'"),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Signature: $_signature",
                style: TextStyle(color: Colors.white),
              ),
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}
