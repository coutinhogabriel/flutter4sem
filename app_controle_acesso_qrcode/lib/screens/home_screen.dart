import 'package:flutter/material.dart';
import 'visitor/visitor_form.dart';
import 'admin/admin_login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Controle de Acesso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão de Visitante chamativo
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisitorForm()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Cor de fundo chamativa
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 25), // Maior padding
                textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Fonte maior e em negrito
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bordas mais arredondadas
                ),
                shadowColor: Colors.blueAccent, // Cor de sombra mais vibrante
                elevation: 15, // Sombra mais forte
              ),
              child: Text('Entrar como Visitante'),
            ),
            SizedBox(height: 50), // Aumentei o espaço entre os botões
            // Botão de Administrador com estilo mais discreto
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.3), // Cor de fundo mais neutra e discreta
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8), // Menor padding
                textStyle: TextStyle(fontSize: 12), // Fonte ainda menor
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Bordas arredondadas menores
                ),
                elevation: 1, // Sombra muito suave
              ),
              child: Text('Entrar como Administrador'),
            ),
          ],
        ),
      ),
    );
  }
}
