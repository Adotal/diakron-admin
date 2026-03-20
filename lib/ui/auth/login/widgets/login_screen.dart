import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/themes/dimens.dart';
import 'package:diakron_admin/ui/core/ui/input_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  // text: 'adotal1484@gmail.com',
  final TextEditingController _password = TextEditingController();
  // text: '123456789',

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Stack(
              children: [
                Container(
                  height:
                      Dimens.screenSize(context).height *
                      0.35, // 35% de la altura
                  decoration: const BoxDecoration(
                    color: AppColors.greenDiakron1,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60), // Curva
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // LOGO: Image.asset('assets/logo.png')
                        Icon(Icons.recycling, size: 80, color: Colors.white),
                        SizedBox(height: 10),
                        Text(
                          "DIAKRON",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          'ADMINISTRADORES',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Formulairo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Iniciar Sesión",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Campo Email
                  InputText(controller: _email, hintText: "E-mail"),
                  const SizedBox(height: 20),

                  // Campo Contraseña
                  InputText(
                    controller: _password,
                    hintText: "Contraseña",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // Checkbox "Mantener sesión"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Mantener sesión",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Checkbox(
                        value: false,
                        onChanged: (v) {},
                        activeColor: const Color(0xFF387C11),
                      ),
                    ],
                  ),

                  // Olvidé mi contraseña
                  GestureDetector(
                    onTap: () {
                      context.push(Routes.forgotpassword);
                    },
                    child: const Text(
                      "Olvidé mi contraseña",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BOTÓN INICIAR SESIÓN
                  ElevatedButton(
                    onPressed: () {
                      widget.viewModel.login.execute((
                        _email.value.text,
                        _password.value.text,
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 60),

                      backgroundColor: AppColors.greenDiakron1,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: ListenableBuilder(
                      listenable: widget.viewModel.login,
                      builder: (context, _) {
                        return widget.viewModel.login.running
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Iniciar Sesión",
                                style: TextStyle(fontSize: 18),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () {
                      context.push(Routes.singup);
                    },
                    child: const Column(
                      children: [
                        Text(
                          "¿Quieres formar parte de nosotros?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          "¡Regístrate!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Términos y condiciones.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      // Ve a home
      context.go(Routes.home);
    }
    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          persist: false,
          dismissDirection: DismissDirection.horizontal,
          content: Text("Error while login: ${widget.viewModel.login.result}"),
          action: SnackBarAction(
            label: "Try again",
            onPressed: () => widget.viewModel.login.execute((
              _email.value.text,
              _password.value.text,
            )),
          ),
        ),
      );
    }
  }
}
