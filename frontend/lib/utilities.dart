// ignore_for_file: must_be_immutable, avoid_print, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LabelledTextField extends StatelessWidget {
  final String label;
  TextEditingController? controller;
  bool? enabled;
  bool? hidden;

  //final Function(String) subFunction;
  LabelledTextField({
    super.key,
    required this.label,
    //required this.subFunction
  });

  LabelledTextField.readable({
    super.key,
    required this.label,
    required this.controller,
  });

  LabelledTextField.offOn({
    super.key,
    required this.label,
    required this.enabled,
  });

  LabelledTextField.hidden({
    super.key,
    required this.label,
    this.hidden = true,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: TextField(
            obscureText: hidden ?? false,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5.0,
              ),
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
            controller: controller,
            enabled: enabled,
            //onSubmitted: subFunction,
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final String label1;
  PasswordField(
      {super.key,
      this.obscureText = true,
      required this.controller,
      required this.label1});
  TextEditingController controller;
  bool obscureText = true;

  @override
  _PasswordFieldState createState() => _PasswordFieldState(
      obscureText: obscureText, controller: controller, label1: label1);
}

class _PasswordFieldState extends State<PasswordField> {
  final String label1;
  _PasswordFieldState(
      {required this.obscureText,
      required this.controller,
      required this.label1});
  bool obscureText;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gapPadding: 5.0,
              ),
              labelText: label1,
              labelStyle: TextStyle(
                color: Colors.white70, // White label text color
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  color: Colors.white70,
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Bet extends StatefulWidget {
  final String name;
  final String pool;
  final String players;
  const Bet(
      {super.key,
      required this.name,
      required this.pool,
      required this.players});

  @override
  State<Bet> createState() =>
      _BetState(name: name, pool: pool, players: players);
}

class _BetState extends State<Bet> {
  String name;
  String pool;
  String players;

  _BetState({required this.name, required this.pool, required this.players});
  //TODO add on pressed function

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Container(
          width: 100,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(name),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(pool), Text(players)],
                ),
              )
            ],
          ),
        ));
  }
}

class Pill extends StatefulWidget {
  final String rightText;
  final String leftText;
  const Pill({super.key, required this.rightText, required this.leftText});

  @override
  State<Pill> createState() =>
      _PillState(rightText: rightText, leftText: leftText);
}

class _PillState extends State<Pill> {
  String rightText;
  String leftText;

  _PillState({required this.rightText, required this.leftText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Container(
          width: 500,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(100, 0, 0, 0),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0), // shadow direction: bottom right
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 0.0),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(leftText),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(rightText)),
            ],
          ),
        ));
  }
}

class Option extends StatelessWidget {
  final String label;
  final String route;

  Option({super.key, required this.label, required this.route});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        width: 450,
        height: 75,
        decoration: const BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: IconButton(
                  icon: Icon(
                    size: 30,
                    Icons.arrow_right_outlined,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {},
                )),
          ],
        ),
      ),
    );
  }
}

class Select extends StatelessWidget {
  final String label;
  final String route;
  final IconData icon;
  final Function onpressed;

  Select(
      {super.key,
      required this.label,
      required this.route,
      required this.icon,
      required this.onpressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                  child: IconButton(
                    icon: Icon(
                      icon,
                      size: 70,
                      color: Colors.lightBlue[400],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, route);
                    },
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 30),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 25,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.lightBlue[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String label1;
  final String label2;
  final String route;

  Item({
    super.key,
    required this.label1,
    required this.label2,
    required this.route,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
      child: Container(
        width: 450,
        height: 100,
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      label1,
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      label2,
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Icon(
                  size: 30,
                  Icons.arrow_right_outlined,
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}
