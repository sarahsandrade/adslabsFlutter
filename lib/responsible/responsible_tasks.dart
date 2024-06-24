import 'package:first_app/responsible/responsible_api.dart';
import 'package:first_app/task/task_add_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/task/tasks_api.dart';
import 'package:first_app/task/task_edit_ui.dart';
import 'package:intl/intl.dart';

class ResponsibleTasks extends StatefulWidget {
  const ResponsibleTasks({super.key});

  @override
  State<ResponsibleTasks> createState() => _ResponsibleTasksState();
}

class _ResponsibleTasksState extends State<ResponsibleTasks> {
  late Responsible responsible;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
    final args = ModalRoute.of(context)!.settings.arguments as Responsible;
    Provider.of<TaskProvider>(context, listen: false).fetchTasks(args.id);
  });

  }
  @override
  Widget build(BuildContext context) {
    final responsible = ModalRoute.of(context)!.settings.arguments as Responsible;
    return Scaffold(
          appBar: AppBar(
            title: Text('Tarefas de ${responsible.nome}'),
          ),
          body: Consumer<TaskProvider>(builder: (context,taskProvider,child)=>
          taskProvider.tasks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return ListTile(
                      title: Text(
                        task.titulo,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                            color: task.pendente == true? Colors.red : Colors.black
                            ),
                      ),
                      // subtitle: Text('${task.status} - ${task.priority}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.description),
                              const SizedBox(width: 5),
                              Text('Descrição: ${task.descricao}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 5),
                              Text('Responsavel: ${task.responsaveiId}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 5),
                              Text(
                                  'Data Limite: ${DateFormat('yyyy-MM-dd').format(task.dataLimite)}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.work),
                              const SizedBox(width: 5),
                              Text('pendente: ${task.pendente}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => { 
                              Navigator.pushNamed(context, '/taskedit',arguments: task)},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => taskProvider.deleteTask(task.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),), 
        );
  }
  navigateToEditTask(BuildContext context, int id) {
    Navigator.pushNamed(context, '/taskedit',arguments: id);
  }
}


  