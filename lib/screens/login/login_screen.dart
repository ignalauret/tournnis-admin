import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/custom_text_field.dart';
import 'package:tournnis_admin/providers/auth.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CustomColors.kWhiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.kCardBorderRadius)),
        contentPadding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 0,
        ),
        titlePadding: const EdgeInsets.only(
          top: 20,
          bottom: 0,
          left: 20,
          right: 20,
        ),
        title: Text(
          "Error en la autenticación",
          style: CustomStyles.kTitleStyle,
        ),
        content: Text(
          message,
          style: TextStyle(color: CustomColors.kMainColor),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Continuar",
              style: TextStyle(
                color: CustomColors.kAccentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    ).then((_) {
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(size.width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/img/logo.png"),
            SizedBox(height: 35),
            CustomTextField(
              controller: _usernameController,
              hint: "Ingrese el usuario",
              label: "Usuario",
            ),
            CustomTextField(
              controller: _passwordController,
              hint: "Ingrese la contraseña",
              label: "Contraseña",
              obscure: true,
            ),
            SizedBox(height: 35),
            FlatButton(
              child: Text("Ingresar"),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              onPressed: () async {
                String result = await context
                    .read<Auth>()
                    .logIn(_usernameController.text, _passwordController.text);
                if (result.isEmpty) return;
                var errorMessage =
                    "Lo sentimos hubo un problema, intentelo denuevo mas tarde";
                if (result.contains("INVALID_PASSWORD")) {
                  errorMessage = "Contraseña incorrecta";
                } else if (result.contains("EMAIL_NOT_FOUND")) {
                  errorMessage = "Usuario no encontrado";
                } else if (result.contains("INVALID_EMAIL")) {
                  errorMessage = "Usuario invalido";
                }
                _showErrorMessage(errorMessage);
              },
              textColor: Colors.white,
              color: CustomColors.kMainColor,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Constants.kCardBorderRadius),
              ),
              disabledColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
