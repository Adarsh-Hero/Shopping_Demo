import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyEditText extends StatefulWidget {
  final String text;
  final String placeholder;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final onFieldSubmitted;
  final validator;
  final isSettingWorkout;

  MyEditText({
    this.text = "",
    this.placeholder = "Place input a value.",
    this.validator,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.onFieldSubmitted,
    this.isSettingWorkout = false,
  });

  @override
  _MyEditTextState createState() => _MyEditTextState();
}

class _MyEditTextState extends State<MyEditText> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.placeholder ;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        height: 45,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: -24.0,
                blurRadius: 24.0,
                offset: Offset(0, 24.0),
              ), // changes position of shado
            ]),
        child: Center(
          child: TextFormField(
            maxLines: 1,
            textInputAction: widget.textInputAction,
            onSaved: (input) => input,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
            controller: textController,
            keyboardType: widget.textInputType,
            readOnly: true,
            autocorrect: false,
            autofocus: true,
            cursorColor: Colors.black,
            focusNode: FocusNode(),
            textCapitalization: widget.textCapitalization,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                errorBorder: InputBorder.none,
                alignLabelWithHint: true,
                disabledBorder: InputBorder.none,
                labelText: widget.text,
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                hintText: widget.placeholder),
            onFieldSubmitted: (v) {
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted(v);
              }
            },
          ),
        ));
  }
}
