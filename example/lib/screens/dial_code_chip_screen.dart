import 'package:example/widgets/switch_el.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../widgets/app_drawer.dart';

class DialCodeChipScreen extends StatefulWidget {
  @override
  _DialCodeChipScreenState createState() => _DialCodeChipScreenState();
}

class _DialCodeChipScreenState extends State<DialCodeChipScreen> {
  bool showDialCode = true;
  bool showFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchEl(
              value: showDialCode,
              onChanged: (v) => setState(() => showDialCode = v),
              title: 'show dial code'),
          SwitchEl(
              value: showFlag,
              onChanged: (v) => setState(() => showFlag = v),
              title: 'show flag'),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('US'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('FR'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('BR'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('ES'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
