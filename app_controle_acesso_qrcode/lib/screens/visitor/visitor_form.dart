import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VisitorForm extends StatefulWidget {
  @override
  _VisitorFormState createState() => _VisitorFormState();
}

class _VisitorFormState extends State<VisitorForm> {
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _apartmentController = TextEditingController(); // Novo campo para apartamento

  String? qrData;

  void generateQRCode() {
    setState(() {
      qrData = '${_nameController.text}, ${_documentController.text}, ${_apartmentController.text}'; // Incluindo o nome do apartamento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Visitante'),
        backgroundColor: Colors.blueAccent, // Cor da barra de app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Permite rolar a tela em dispositivos pequenos
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título informativo
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Preencha os dados abaixo para gerar seu QR Code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              
              // Campo de nome
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              
              // Campo de documento
              TextField(
                controller: _documentController,
                decoration: InputDecoration(
                  labelText: 'Documento (RG ou CPF)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Campo de apartamento ou pessoa visitada
              TextField(
                controller: _apartmentController,
                decoration: InputDecoration(
                  labelText: 'Apartamento / Pessoa Visitada',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Botão para gerar QR Code
              ElevatedButton(
                onPressed: generateQRCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Cor do botão
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
                  ),
                ),
                child: Text(
                  'Gerar QR Code',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

              // Exibição do QR Code
              if (qrData != null)
                Center(
                  child: QrImageView(
                    data: qrData!,
                    size: 250.0,
                    version: QrVersions.auto,
                    gapless: false,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                  ),
                ),
              if (qrData != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Aguardando Aprovação...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
