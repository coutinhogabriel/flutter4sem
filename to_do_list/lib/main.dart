import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ListaTarefasApp());
}

class Tarefa {
  String descricao;
  bool concluida;
  String status;  // Campo para definir o status da tarefa

  Tarefa(this.descricao, this.concluida, this.status);
}

class ListaTarefasModel extends ChangeNotifier {
  // Listas separadas para cada coluna
  List<Tarefa> _aFazer = [];
  List<Tarefa> _fazendo = [];
  List<Tarefa> _feito = [];

  List<Tarefa> get aFazer => _aFazer;
  List<Tarefa> get fazendo => _fazendo;
  List<Tarefa> get feito => _feito;

  // Método para adicionar tarefa, mas só se a descrição não for vazia
  void adicionarTarefa(String descricao) {
    if (descricao.isNotEmpty) {
      _aFazer.add(Tarefa(descricao, false, 'A Fazer'));
      notifyListeners();
    }
  }

  // Excluir tarefa
  void excluirTarefa(int indice, String status) {
    if (status == 'A Fazer') {
      _aFazer.removeAt(indice);
    } else if (status == 'Fazendo') {
      _fazendo.removeAt(indice);
    } else if (status == 'Feito') {
      _feito.removeAt(indice);
    }
    notifyListeners();
  }

  // Mover tarefa entre as colunas (sem permitir ir para "Feito" sem o checkbox)
  void moverTarefa(int indice, String deStatus, String paraStatus) {
    if (paraStatus == 'Feito') {
      // Não permitimos mover para "Feito" diretamente pela seta
      return;
    }

    Tarefa tarefa;

    // Verifica de onde a tarefa está vindo e a remove da lista correspondente
    if (deStatus == 'A Fazer') {
      tarefa = _aFazer.removeAt(indice);
    } else if (deStatus == 'Fazendo') {
      tarefa = _fazendo.removeAt(indice);
    } else {
      throw Exception("Status inválido para mover a tarefa: $deStatus");
    }

    // Atualiza o status da tarefa
    tarefa.status = paraStatus;

    // Adiciona a tarefa na lista correspondente ao novo status
    if (paraStatus == 'A Fazer') {
      _aFazer.add(tarefa);
    } else if (paraStatus == 'Fazendo') {
      _fazendo.add(tarefa);
    } else {
      throw Exception("Status inválido para mover a tarefa: $paraStatus");
    }

    // Notifica que houve uma mudança
    notifyListeners();
  }

  // Marcar tarefa como concluída (quando o checkbox for ativado)
  void marcarComoConcluida(int indice, String status) {
    if (status == 'A Fazer') {
      _aFazer[indice].concluida = true;
      _aFazer[indice].status = 'Feito';  // Tarefa vai para "Feito"
      _feito.add(_aFazer.removeAt(indice));  // Move para "Feito"
    } else if (status == 'Fazendo') {
      _fazendo[indice].concluida = true;
      _fazendo[indice].status = 'Feito';  // Tarefa vai para "Feito"
      _feito.add(_fazendo.removeAt(indice));  // Move para "Feito"
    }
    notifyListeners();
  }
}

class ListaTarefasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ListaTarefasModel(),
        child: ListaTarefasScreen(),
      ),
    );
  }
}

class ListaTarefasScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nova Tarefa',
                suffixIcon: IconButton(
                  onPressed: () {
                    // Adiciona a tarefa apenas se a descrição não for vazia
                    String descricao = _controller.text.trim();
                    if (descricao.isNotEmpty) {
                      Provider.of<ListaTarefasModel>(context, listen: false)
                          .adicionarTarefa(descricao);
                    }
                    _controller.clear();
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ListaTarefasModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Coluna "A Fazer"
                    _buildColunaTarefas('A Fazer', model.aFazer, model),
                    // Coluna "Fazendo"
                    _buildColunaTarefas('Fazendo', model.fazendo, model),
                    // Coluna "Feito"
                    _buildColunaTarefas('Feito', model.feito, model),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildColunaTarefas(
      String status, List<Tarefa> tarefas, ListaTarefasModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              Tarefa tarefa = tarefas[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(tarefa.descricao),
                  subtitle: tarefa.concluida
                      ? Text('Concluída', style: TextStyle(color: Colors.green))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botão para mover entre as colunas (sem permitir ir para "Feito")
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          String novoStatus;
                          if (status == 'A Fazer') {
                            novoStatus = 'Fazendo';
                          } else if (status == 'Fazendo') {
                            novoStatus = 'A Fazer';
                          } else {
                            return;
                          }
                          model.moverTarefa(index, status, novoStatus);
                        },
                      ),
                      // Checkbox para marcar como concluída
                      Checkbox(
                        value: tarefa.concluida,
                        onChanged: (value) {
                          model.marcarComoConcluida(index, status);
                        },
                      ),
                      // Botão para excluir tarefa
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          model.excluirTarefa(index, status);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
