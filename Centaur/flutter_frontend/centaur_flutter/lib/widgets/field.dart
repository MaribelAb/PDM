import 'package:flutter/material.dart';
import 'package:centaur_flutter/theme.dart';

class CustomField extends StatefulWidget {
  final String iconUrl;
  final String hint;
  TextEditingController? controller;
  bool obsecure;
  final bool passfield;

  CustomField({
    this.controller,
    this.iconUrl = '',
    this.hint = '',
    this.obsecure = false,
    required this.passfield,
  });

  @override
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            height: 26,
            width: 26,
            margin: EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  widget.iconUrl,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              obscureText: widget.passfield ? widget.obsecure : false,
              controller: widget.controller,
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          if (widget.passfield)
            IconButton(
              iconSize: 24,
              icon: Semantics(
                label: 'Botón para mostrar u ocultar contraseña',
                child: Tooltip(
                  message: widget.obsecure ? 'Mostrar contraseña' : 'Ocultar contraseña',
                  child: Icon(widget.obsecure ? Icons.visibility_off : Icons.visibility)
                )
              ),
              onPressed: () {
                setState(() {
                  widget.obsecure = !widget.obsecure;
                });
              },
            ),
        ],
      ),
    );
  }
}
