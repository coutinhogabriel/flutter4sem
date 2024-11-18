import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String qrData = "Nenhum código escaneado ainda";
  MobileScannerController scannerController = MobileScannerController();

  // Função para enviar mensagem ao visitante
  void sendMessageToVisitor(String visitorData) {
    print('Mensagem enviada ao visitante: $visitorData');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entrada aprovada para: $visitorData'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Função para tratar a negação de entrada
  void denyEntry(String visitorData) {
    print('Entrada negada para: $visitorData');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entrada negada para: $visitorData'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Função chamada quando o QR Code for escaneado
  void onQRCodeScanned(String qrData) {
    // Pausa o scanner enquanto o diálogo está aberto
    scannerController.stop();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aprovação de Entrada'),
        content: Text('Dados do Visitante: $qrData'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              denyEntry(qrData); // Chama a função de negar entrada
              // Retoma o scanner após um pequeno delay para o usuário ver a ação
              Future.delayed(Duration(seconds: 1), () {
                scannerController.start();
              });
            },
            child: Text('Negar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              sendMessageToVisitor(qrData); // Envia mensagem de aprovação
              // Retoma o scanner após um pequeno delay para o usuário ver a ação
              Future.delayed(Duration(seconds: 1), () {
                scannerController.start();
              });
            },
            child: Text('Aprovar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel Administrativo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: scannerController,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    setState(() {
                      qrData = code;
                    });
                    onQRCodeScanned(qrData); // Chama a função de escaneamento
                  } else {
                    setState(() {
                      qrData = "Código inválido";
                    });
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Resultado do escaneamento: $qrData',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
