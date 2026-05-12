import 'package:flutter/material.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: PuventColors.primaryGreen.color
          // gradient: LinearGradient(
          //   colors: [
          //     PuventColors.primaryGreen.color,
          //     Colors.green.shade700,
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// LOGO O ICONO //CAMBIAR POR IMAGENA?
                  // Container(
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.15),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: const Icon(
                  //     Icons.lock_outline,
                  //     size: 80,
                  //     color: Colors.white,
                  //   ),
                  // ),

                  // const SizedBox(height: 30),

                  const Text(
                    "Bienvenido",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// CARD LOGIN
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          /// USERNAME
                          TextFormField(
                            controller: _userController,
                            decoration: InputDecoration(
                              labelText: "Usuario",
                              hintText: "Ingresa tu usuario",
                              prefixIcon:
                                  const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return "Ingrese su usuario";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          TextFormField(
                            controller: _passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              hintText: "Ingresa tu contraseña",
                              prefixIcon:
                                  const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return "Ingrese su contraseña";
                              }

                              if (value.length < 6) {
                                return "Mínimo 6 caracteres";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          /// BOTON LOGIN
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    PuventColors.primaryGreen.color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!
                                    .validate()) {
                                  // LOGIN
                                }
                              },
                              child: const Text(
                                "Entrar",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// REGISTRO
                          TextButton(
                            onPressed: () {
                              // IR A REGISTRO
                            },
                            child: const Text(
                              "¿No tienes cuenta? Crear cuenta",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}