import 'package:first_app/task/tasks_api.dart';
import 'package:first_app/validacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
  
}

class _EditTaskPageState extends State<EditTaskPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    _descriptionController  = TextEditingController(text:task.descricao);
     _titleController  = TextEditingController(text:task.titulo);
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body:Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator:(value) {
                      if(!validarString(_titleController.text)){
                        return 'Nome invalido';
                      }
                      return null;
                    },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if(isValid){
                      final taskup = Task(
                      id: task.id,
                      titulo: _titleController.text,
                      descricao: _descriptionController.text,
                      responsaveiId: task.responsaveiId,
                      pendente: task.pendente,
                      dataLimite: task.dataLimite,
                    );
                     taskProvider.editTask(task.id,taskup).then((_) {
                       Navigator.pop(context);
                       taskProvider.fetchTasks(null);
                     }).catchError((error) {
                      print(error);
                       //TODO: deal with errors my dear friend
                     });
                    }
                  },
                  child: const Text('Edit Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}