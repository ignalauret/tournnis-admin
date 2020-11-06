import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';

class ActionButton extends StatefulWidget {
  ActionButton(this.label, this.onTap, {this.enabled = true});
  final String label;
  final Function onTap;
  final bool enabled;

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool tapped = false;

  void onTap() {
    setState(() {
      tapped = true;
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.enabled && !tapped ? onTap : null,
      child: Container(
        height: 70,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          color: widget.enabled && !tapped ? CustomColors.kAccentColor : Colors.white70,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: tapped
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
