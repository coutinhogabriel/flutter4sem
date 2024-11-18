import '/screens/admin/admin_create_account.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart'; // Importe o serviço de autenticação
import 'admin_dashboard.dart'; // Tela de Dashboard do administrador

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instanciando o serviço de autenticação

  void login() async {
    try {
      final user = await _authService.signIn(_emailController.text, _passwordController.text);
      if (user != null) {
        // Se o login for bem-sucedido, navegue para o AdminDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      }
    } catch (e) {
      // Se ocorrer um erro, exiba uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Entrar'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navega para a tela de criação de conta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminCreateAccount()),
                );
              },
              child: Text(
                'Criar Conta Administrador',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
