import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/ui/input_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF387600), // El verde de Diakron
      body: Column(
        children: [
          // SECCIÓN SUPERIOR (AppBar Personalizada)
          SafeArea(
            bottom: false, // No padding abajo para que pegue con lo blanco
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const SizedBox(width: 30),
                  const Icon(Icons.recycling, color: Colors.white, size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'DIAKRON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cuerpo de la app)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    45.0,
                  ), // Curva pronunciada de tu imagen
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(25.0),
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      "¿Olvidaste tu\nContraseña?",
                      style: TextStyle(fontSize: 38),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      textAlign: TextAlign.start,
                      "Escribe tu correo electrónico para restablecer tu contraseña:",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    // Campo Contraseña
                    InputText(
                      controller: _email,
                      hintText: "Correo electrónico",
                    ),
                    const SizedBox(height: 20),
                    // BOTÓN ENVIAR CORREO
                    ElevatedButton(
                      onPressed: () {
                        // _handleLogin();
                        // widget.viewModel.login(
                        //   _email.value.text,
                        //   _password.value.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDiakron1,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Enviar enlace",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
