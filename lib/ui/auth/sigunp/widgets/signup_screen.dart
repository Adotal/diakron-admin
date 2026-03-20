import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/input_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  // Controllers
  final TextEditingController _name = TextEditingController(
    text: 'password',
  );  
  final TextEditingController _lastnames = TextEditingController(
    text: 'password',
  );  
  final TextEditingController _email = TextEditingController(
    text: 'email@example.com',
  );
  final TextEditingController _phonenumer = TextEditingController(
    text: 'password',
  );  
  final TextEditingController _password = TextEditingController(
    text: 'password',
  );  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF387600), // El verde exacto
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            // Aquí puedes usar un Image.asset si tienes el logo
            const Icon(Icons.recycling, color: Colors.white, size: 30),
            const SizedBox(width: 10),
            const Text(
              'DIAKRON',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 24,
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              40,
            ), // Crea el efecto de curva hacia adentro
          ),
        ),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Registrarse",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                InputText(controller: _name, hintText: "Nombre(s)"),
                const SizedBox(height: 20),

                InputText(controller: _lastnames, hintText: "Apellidos"),
                const SizedBox(height: 20),

                InputText(controller: _phonenumer, hintText: "Número telefónico"),
                const SizedBox(height: 20),

                // Campo Email
                InputText(controller: _email, hintText: "E-mail"),
                const SizedBox(height: 20),

                // Campo Contraseña
                InputText(controller: _password, hintText: "Contraseña", obscureText: true),

                const SizedBox(height: 35),

                // BOTÓN INICIAR SESIÓN
                ElevatedButton(
                  onPressed: () {
                    // // NAVEGACIÓN A LA PANTALLA HOME
                    context.go(Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF387C11),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 25),

                GestureDetector(
                  onTap: () {
                    context.go(Routes.login);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿Ya tienes una cuenta? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),

                      const Text(
                        '¡Inicia Sesión!',
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
    );
  }
}
