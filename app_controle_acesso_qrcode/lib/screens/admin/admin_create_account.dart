import '/screens/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart'; // Importe o serviço de autenticação

class AdminCreateAccount extends StatefulWidget {
  const AdminCreateAccount({super.key});

  @override
  _AdminCreateAccountState createState() => _AdminCreateAccountState();
}

class _AdminCreateAccountState extends State<AdminCreateAccount> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instanciando o serviço de autenticação

  void createAccount() async {
    try {
      final user = await _authService.signUp(_emailController.text, _passwordController.text);
      if (user != null) {
        // Conta criada com sucesso, navega para o Dashboard do Administrador
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
      appBar: AppBar(title: const Text('Criar Conta Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createAccount,
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
